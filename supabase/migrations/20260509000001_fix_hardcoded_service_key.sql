-- Security remediation: remove hardcoded service role key from
-- send_panic_alert_sms, send_push_notification_to_manager, send_custom_sms.
--
-- The original migration (20260421150000_sms_push_rpc_functions.sql) embedded
-- the Supabase service role JWT as a SQL CONSTANT. Any authenticated user with
-- access to pg_proc could read it. The key must be rotated in the Supabase
-- dashboard before deploying this migration.
--
-- After rotation, set the new key as a custom DB parameter in
-- Supabase Dashboard → Project Settings → Database → Configuration:
--   app.settings.service_role_key = <new service role key>
--
-- This pattern matches the existing safe usage in
-- 20260316172102_schedule_check_checklist_hourly.sql.

-- ============================================================
-- 1. send_panic_alert_sms
-- ============================================================
CREATE OR REPLACE FUNCTION public.send_panic_alert_sms(
  p_alert_type    TEXT,
  p_guard_name    TEXT,
  p_guard_phone   TEXT    DEFAULT NULL,
  p_latitude      NUMERIC DEFAULT NULL,
  p_longitude     NUMERIC DEFAULT NULL,
  p_manager_phone TEXT    DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_location_msg TEXT;
  v_title        TEXT;
  v_body_text    TEXT;
  v_manager      RECORD;
  v_service_key  TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'app.settings.service_role_key not configured');
  END IF;

  IF p_latitude IS NOT NULL AND p_longitude IS NOT NULL THEN
    v_location_msg := format('Location: %s, %s', round(p_latitude::NUMERIC, 5), round(p_longitude::NUMERIC, 5));
  ELSE
    v_location_msg := 'Location unavailable';
  END IF;

  v_title     := format('PANIC ALERT: %s', upper(p_alert_type));
  v_body_text := format('Guard %s triggered a %s alert. %s', p_guard_name, p_alert_type, v_location_msg);

  IF p_manager_phone IS NOT NULL AND p_manager_phone <> '' THEN
    PERFORM net.http_post(
      url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body    := jsonb_build_object(
        'mobile',  p_manager_phone,
        'title',   v_title,
        'body',    v_body_text,
        'channel', 'sms'
      )::TEXT
    );
  END IF;

  FOR v_manager IN
    SELECT u.id
    FROM   users u
    JOIN   roles r ON u.role_id = r.id
    WHERE  r.role_name IN ('admin', 'company_md', 'company_hod')
  LOOP
    PERFORM net.http_post(
      url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body    := jsonb_build_object(
        'user_id', v_manager.id::TEXT,
        'title',   v_title,
        'body',    v_body_text,
        'channel', 'fcm',
        'data',    jsonb_build_object(
          'alert_type',  p_alert_type,
          'guard_name',  p_guard_name,
          'latitude',    COALESCE(p_latitude::TEXT, ''),
          'longitude',   COALESCE(p_longitude::TEXT, '')
        )
      )::TEXT
    );
  END LOOP;

  RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.send_panic_alert_sms(TEXT, TEXT, TEXT, NUMERIC, NUMERIC, TEXT) TO authenticated;


-- ============================================================
-- 2. send_push_notification_to_manager
-- ============================================================
CREATE OR REPLACE FUNCTION public.send_push_notification_to_manager(
  p_alert_type TEXT,
  p_guard_name TEXT,
  p_latitude   NUMERIC DEFAULT NULL,
  p_longitude  NUMERIC DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_location_msg TEXT;
  v_title        TEXT;
  v_body_text    TEXT;
  v_manager      RECORD;
  v_service_key  TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'app.settings.service_role_key not configured');
  END IF;

  IF p_latitude IS NOT NULL AND p_longitude IS NOT NULL THEN
    v_location_msg := format('Location: %s, %s', round(p_latitude::NUMERIC, 5), round(p_longitude::NUMERIC, 5));
  ELSE
    v_location_msg := 'Location unavailable';
  END IF;

  v_title     := format('ALERT: %s', upper(p_alert_type));
  v_body_text := format('Guard %s — %s. %s', p_guard_name, p_alert_type, v_location_msg);

  FOR v_manager IN
    SELECT u.id
    FROM   users u
    JOIN   roles r ON u.role_id = r.id
    WHERE  r.role_name IN ('admin', 'company_md', 'company_hod')
  LOOP
    PERFORM net.http_post(
      url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body    := jsonb_build_object(
        'user_id', v_manager.id::TEXT,
        'title',   v_title,
        'body',    v_body_text,
        'channel', 'fcm',
        'data',    jsonb_build_object(
          'alert_type', p_alert_type,
          'guard_name', p_guard_name,
          'latitude',   COALESCE(p_latitude::TEXT, ''),
          'longitude',  COALESCE(p_longitude::TEXT, '')
        )
      )::TEXT
    );
  END LOOP;

  RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.send_push_notification_to_manager(TEXT, TEXT, NUMERIC, NUMERIC) TO authenticated;


-- ============================================================
-- 3. send_custom_sms
-- ============================================================
CREATE OR REPLACE FUNCTION public.send_custom_sms(
  p_phone_number TEXT,
  p_message      TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_service_key TEXT;
BEGIN
  v_service_key := current_setting('app.settings.service_role_key', true);

  IF v_service_key IS NULL OR v_service_key = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'app.settings.service_role_key not configured');
  END IF;

  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF COALESCE(btrim(p_phone_number), '') = '' THEN
    RAISE EXCEPTION 'Phone number is required';
  END IF;

  IF COALESCE(btrim(p_message), '') = '' THEN
    RAISE EXCEPTION 'Message is required';
  END IF;

  PERFORM net.http_post(
    url     := 'https://wwhbdgwfodumognpkgrf.supabase.co/functions/v1/send-notification',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || v_service_key
    ),
    body    := jsonb_build_object(
      'mobile',  p_phone_number,
      'title',   'FacilityPro Alert',
      'body',    p_message,
      'channel', 'sms'
    )::TEXT
  );

  RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.send_custom_sms(TEXT, TEXT) TO authenticated;
