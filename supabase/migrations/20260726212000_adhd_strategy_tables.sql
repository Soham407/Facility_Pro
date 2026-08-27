-- Create feature_telemetry table for Phase 0 Graceful Degradation
CREATE TABLE IF NOT EXISTS public.feature_telemetry (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    feature_id TEXT NOT NULL,
    event_type TEXT NOT NULL,
    url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS and allow inserts for telemetry
ALTER TABLE public.feature_telemetry ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public inserts for telemetry" 
ON public.feature_telemetry 
FOR INSERT 
WITH CHECK (true);

-- Create notification_queue table for Phase 1 Hub & Spoke
CREATE TABLE IF NOT EXISTS public.notification_queue (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    entity_type TEXT NOT NULL, -- e.g. 'service_request', 'indent'
    entity_id UUID NOT NULL,
    event_type TEXT NOT NULL, -- e.g. 'status_changed'
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
    created_at TIMESTAMPTZ DEFAULT NOW(),
    processed_at TIMESTAMPTZ,
    error_message TEXT
);

-- Enable RLS for notification queue
ALTER TABLE public.notification_queue ENABLE ROW LEVEL SECURITY;

-- Only service role can read/process the queue
CREATE POLICY "Service role full access on notification_queue"
ON public.notification_queue
TO service_role
USING (true)
WITH CHECK (true);
