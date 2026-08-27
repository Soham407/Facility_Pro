-- PHASE 1: Database-as-Truth Migration
-- 1. Check constraints on state transitions
-- 2. Triggers for notification queue
-- 3. Strict RLS Policies

-----------------------------------------
-- 1. State Transition Constraints
-----------------------------------------
-- Prevent jumping from 'pending' directly to 'accepted' without required checks.
-- We do this by creating a trigger that verifies state transitions.

CREATE OR REPLACE FUNCTION public.check_service_request_transition()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    -- Valid state transitions
    -- pending -> assigned -> in_progress -> completed -> approved/rejected
    
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        IF OLD.status = 'open' AND NEW.status NOT IN ('assigned', 'cancelled', 'closed') THEN
            RAISE EXCEPTION 'Invalid state transition from open to %', NEW.status;
        END IF;

        IF OLD.status = 'assigned' AND NEW.status NOT IN ('in_progress', 'cancelled') THEN
            RAISE EXCEPTION 'Invalid state transition from assigned to %', NEW.status;
        END IF;
        
        IF OLD.status = 'in_progress' AND NEW.status NOT IN ('completed', 'cancelled') THEN
            RAISE EXCEPTION 'Invalid state transition from in_progress to %', NEW.status;
        END IF;

        -- Require completion_notes before going to completed
        IF NEW.status = 'completed' AND (NEW.completion_notes IS NULL OR NEW.completion_notes = '') THEN
            RAISE EXCEPTION 'completion_notes are required to complete a service request';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_check_service_request_transition ON public.service_requests;
CREATE TRIGGER trg_check_service_request_transition
BEFORE UPDATE ON public.service_requests
FOR EACH ROW
EXECUTE FUNCTION public.check_service_request_transition();

-----------------------------------------
-- 2. Triggers for Notification Queue
-----------------------------------------
-- Automatically enqueue a notification when a service request is created or status changes

CREATE OR REPLACE FUNCTION public.enqueue_notification_on_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_event_type TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_event_type := 'created';
    ELSIF TG_OP = 'UPDATE' AND OLD.status IS DISTINCT FROM NEW.status THEN
        v_event_type := 'status_changed_' || NEW.status;
    ELSE
        RETURN NEW;
    END IF;

    INSERT INTO public.notification_queue (
        entity_type, 
        entity_id, 
        event_type, 
        payload
    ) VALUES (
        TG_TABLE_NAME,
        NEW.id,
        v_event_type,
        row_to_json(NEW)::jsonb
    );

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_enqueue_service_request_notifications ON public.service_requests;
CREATE TRIGGER trg_enqueue_service_request_notifications
AFTER INSERT OR UPDATE ON public.service_requests
FOR EACH ROW
EXECUTE FUNCTION public.enqueue_notification_on_change();

-- Also apply to indents
DROP TRIGGER IF EXISTS trg_enqueue_indent_notifications ON public.indents;
CREATE TRIGGER trg_enqueue_indent_notifications
AFTER INSERT OR UPDATE ON public.indents
FOR EACH ROW
EXECUTE FUNCTION public.enqueue_notification_on_change();


-----------------------------------------
-- 3. Strict Row Level Security (RLS)
-----------------------------------------
-- Ensure all tables have RLS enabled and only accessible via authenticated roles

-- Service Requests
ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can view service requests" ON public.service_requests;
CREATE POLICY "View own or managed service requests"
ON public.service_requests FOR SELECT
USING (
    auth.uid() = requester_id 
    OR 
    (SELECT role_name::text FROM public.roles WHERE id = (SELECT role_id FROM public.users WHERE id = auth.uid())) IN ('admin', 'super_admin', 'facility_manager')
);

DROP POLICY IF EXISTS "Insert service requests" ON public.service_requests;
CREATE POLICY "Authenticated users can create service requests"
ON public.service_requests FOR INSERT
WITH CHECK (auth.uid() = requester_id);

-- Apply similar policies to Indents
ALTER TABLE public.indents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "View indents" ON public.indents;
CREATE POLICY "View indents by role"
ON public.indents FOR SELECT
USING (
    auth.uid() = submitted_by 
    OR 
    (SELECT role_name::text FROM public.roles WHERE id = (SELECT role_id FROM public.users WHERE id = auth.uid())) IN ('admin', 'super_admin', 'inventory_manager')
);

-- Deny unauthenticated access across the board implicitly by enabling RLS
