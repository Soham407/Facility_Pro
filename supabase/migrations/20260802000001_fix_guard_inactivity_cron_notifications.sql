-- Guard inactivity alerting was dead end-to-end. Three separate breaks:
--
--  1. cron 'check-guard-heartbeat' (*/15) ran `SELECT detect_inactive_guards()`,
--     which inserts panic_alerts and stops. The notification fan-out lives in
--     the check-guard-inactivity edge function, which the cron never called.
--
--  2. The only caller of that edge function, trigger_inactivity_check(), was
--     never scheduled (its cron line is commented out in
--     supabase/archive/PhaseA/cron_inactivity_detection.sql:77) and would have
--     401'd anyway: it sent `x-internal-api-key` with a hardcoded literal,
--     while the edge function validates `x-cron-secret` or a service-role
--     Bearer token.
--
--  3. detect_inactive_guards returns (out_guard_id, out_alert_created) but the
--     edge function filters on `alert_created` and reads `guard_name` /
--     `minutes_inactive`. Every field it touches was undefined, so
--     `alertsCreated` was always empty -- zero notifications even if reached.
--
-- Also closes a semantic gap. The spec (client_requirements_summary.md 4.C.1)
-- asks for an alert when "guard GPS position remains unchanged for over 30
-- minutes". The server function only detected a *missing* heartbeat (phone off
-- / app closed). A guard asleep at the post with the app running was invisible
-- to it -- that case was only ever caught by the client-side
-- hooks/useInactivityMonitor.ts, which is deleted alongside this migration.
--
-- Requires app.settings.service_role_key (Dashboard -> Project Settings ->
-- Database -> Configuration), same as 20260509000001_fix_hardcoded_service_key.sql.

-- ============================================================
-- 1. detect_inactive_guards: fix return contract, add static-position branch
-- ============================================================
DROP FUNCTION IF EXISTS public.detect_inactive_guards(INT);

CREATE FUNCTION public.detect_inactive_guards(p_threshold_minutes INT DEFAULT 15)
RETURNS TABLE (
  guard_id        UUID,
  guard_name      TEXT,
  minutes_inactive INT,
  alert_created   BOOLEAN,
  error_message   TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  r            RECORD;
  v_window     INTERVAL := (p_threshold_minutes || ' minutes')::INTERVAL;
  -- 5 m of latitude in degrees. Longitude is scaled by cos(lat) below.
  -- ponytail: bounding box, not haversine. At a 5 m threshold the box/circle
  -- difference is under the GPS noise floor; swap in earthdistance if this
  -- ever needs to be exact.
  v_drift_deg  CONSTANT NUMERIC := 5.0 / 111320.0;
  v_stat       RECORD;
  v_reason     TEXT;
  v_mins       INT;
BEGIN
  FOR r IN
    SELECT
      sg.id                                AS sg_id,
      al.check_in_location_id,
      (e.first_name || ' ' || e.last_name) AS name
    FROM public.attendance_logs al
    JOIN public.employees e       ON al.employee_id = e.id
    JOIN public.security_guards sg ON e.id = sg.employee_id
    WHERE al.check_out_time IS NULL
      AND al.log_date = CURRENT_DATE
  LOOP
    v_reason := NULL;

    SELECT
      count(*)                                          AS pts,
      max(gt.latitude)  - min(gt.latitude)              AS lat_span,
      max(gt.longitude) - min(gt.longitude)             AS lng_span,
      max(gt.latitude)                                  AS a_lat,
      EXTRACT(EPOCH FROM (NOW() - max(gt.tracked_at)))/60 AS mins_since
    INTO v_stat
    FROM public.gps_tracking gt
    WHERE gt.employee_id = r.sg_id
      AND gt.tracked_at >= NOW() - v_window;

    IF COALESCE(v_stat.pts, 0) = 0 THEN
      -- No heartbeat at all in the window: app closed, phone dead, or offline.
      v_reason := 'No GPS heartbeat for ' || p_threshold_minutes || ' minutes.';
      v_mins   := p_threshold_minutes;

    ELSIF v_stat.pts >= 2
      AND v_stat.lat_span < v_drift_deg
      AND v_stat.lng_span < v_drift_deg / GREATEST(cos(radians(v_stat.a_lat)), 0.01)
      -- Points must actually span the window, not just cluster in the last minute.
      AND (SELECT min(gt2.tracked_at) FROM public.gps_tracking gt2
           WHERE gt2.employee_id = r.sg_id
             AND gt2.tracked_at >= NOW() - v_window) <= NOW() - v_window + INTERVAL '2 minutes'
    THEN
      -- Heartbeats present but the guard has not moved: static at post.
      v_reason := 'Static inactivity: GPS position unchanged for '
                  || p_threshold_minutes || ' minutes.';
      v_mins   := p_threshold_minutes;
    END IF;

    IF v_reason IS NULL THEN
      CONTINUE;
    END IF;

    -- One open inactivity alert per guard per hour.
    IF EXISTS (
      SELECT 1 FROM public.panic_alerts pa
      WHERE pa.guard_id   = r.sg_id
        AND pa.alert_type = 'inactivity'
        AND pa.is_resolved = false
        AND pa.alert_time >= NOW() - INTERVAL '1 hour'
    ) THEN
      guard_id := r.sg_id; guard_name := r.name; minutes_inactive := v_mins;
      alert_created := false; error_message := 'suppressed: open alert within the hour';
      RETURN NEXT;
      CONTINUE;
    END IF;

    BEGIN
      INSERT INTO public.panic_alerts (
        guard_id, alert_type, location_id, description, is_resolved, alert_time
      ) VALUES (
        r.sg_id, 'inactivity', r.check_in_location_id, v_reason, false, NOW()
      );

      guard_id := r.sg_id; guard_name := r.name; minutes_inactive := v_mins;
      alert_created := true; error_message := NULL;
    EXCEPTION WHEN OTHERS THEN
      guard_id := r.sg_id; guard_name := r.name; minutes_inactive := v_mins;
      alert_created := false; error_message := SQLERRM;
    END;

    RETURN NEXT;
  END LOOP;
END;
$$;

-- ============================================================
-- 2. trigger_inactivity_check: call the edge function with valid auth
-- ============================================================
CREATE OR REPLACE FUNCTION public.trigger_inactivity_check()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_service_key TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RAISE WARNING 'trigger_inactivity_check: app.settings.service_role_key not configured; skipping';
    RETURN;
  END IF;

  PERFORM net.http_post(
    url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/check-guard-inactivity',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || v_service_key
    ),
    body    := '{}'::TEXT
  );
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING 'trigger_inactivity_check failed: %', SQLERRM;
END;
$$;

-- ============================================================
-- 3. Repoint the existing schedule at the notifying path
-- ============================================================
DO $$
BEGIN
  PERFORM cron.unschedule('check-guard-heartbeat');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule('check-guard-heartbeat', '*/15 * * * *', 'SELECT public.trigger_inactivity_check()');
