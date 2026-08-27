-- Move visitor-arrival notification from the client to a database trigger.
--
-- Before: hooks/useGuardVisitors.ts checkInVisitor() ran two independent steps
-- from the browser -- UPDATE visitors SET entry_time, then a separate
-- sendVisitorArrivalNotification() call. If the guard's browser died, lost
-- signal, or navigated away between them, the visitor was checked in and the
-- resident was never told. The catch block explicitly swallowed the failure
-- ("Non-blocking error").
--
-- After: the notification row is inserted in the same transaction as the
-- check-in, so it cannot be lost. The existing 'dispatch-mobile-notifications'
-- cron (every minute, see 20260402022000) drains delivery_state='push_queued'
-- via the dispatch-notification-queue edge function, which already handles
-- push tokens, retries and SMS fallback.

CREATE OR REPLACE FUNCTION public.notify_resident_on_visitor_arrival()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_auth_user_id UUID;
  v_flat_number  TEXT;
BEGIN
  SELECT r.auth_user_id INTO v_auth_user_id
  FROM public.residents r
  WHERE r.id = NEW.resident_id;

  -- No linked resident account: nothing to notify. Walk-in visitors and
  -- unregistered flats hit this path routinely, so it is not an error.
  IF v_auth_user_id IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT f.flat_number INTO v_flat_number
  FROM public.flats f
  WHERE f.id = NEW.flat_id;

  PERFORM public.mobile_insert_notification(
    p_user_id        := v_auth_user_id,
    p_title          := 'New Visitor at Gate',
    p_body           := format(
                          'Dear Resident, %s is at the gate for Flat %s.',
                          NEW.visitor_name,
                          COALESCE(v_flat_number, 'your flat')
                        ),
    p_type           := 'visitor_arrival',
    p_priority       := 'high',
    p_data           := jsonb_strip_nulls(jsonb_build_object(
                          'type',        'visitor_arrival',
                          'visitor_id',  NEW.id::TEXT,
                          'flat_number', v_flat_number,
                          'photo_url',   NEW.photo_url
                        )),
    p_delivery_state := 'push_queued'
  );

  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  -- Never block a gate check-in on notification bookkeeping.
  RAISE WARNING 'notify_resident_on_visitor_arrival failed for visitor %: %', NEW.id, SQLERRM;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_resident_on_visitor_arrival ON public.visitors;

CREATE TRIGGER trg_notify_resident_on_visitor_arrival
AFTER UPDATE OF entry_time ON public.visitors
FOR EACH ROW
WHEN (OLD.entry_time IS NULL AND NEW.entry_time IS NOT NULL)
EXECUTE FUNCTION public.notify_resident_on_visitor_arrival();

-- Visitors created already checked in (guard registers a walk-in at the gate)
-- never go through the NULL -> NOT NULL update above.
DROP TRIGGER IF EXISTS trg_notify_resident_on_visitor_insert ON public.visitors;

CREATE TRIGGER trg_notify_resident_on_visitor_insert
AFTER INSERT ON public.visitors
FOR EACH ROW
WHEN (NEW.entry_time IS NOT NULL)
EXECUTE FUNCTION public.notify_resident_on_visitor_arrival();
