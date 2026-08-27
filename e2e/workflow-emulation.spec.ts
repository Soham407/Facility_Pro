import { expect, test } from "@playwright/test";
import { createClient } from "@supabase/supabase-js";
import { loadEnvConfig } from "@next/env";
import crypto from "node:crypto";
import { getRoleTestConfig } from "./role-matrix";
import { readFeatureFixtureState } from "./helpers/db";

loadEnvConfig(process.cwd());

const url = process.env.NEXT_PUBLIC_SUPABASE_URL || "http://127.0.0.1:54321";
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3aGJkZ3dmb2R1bW9nbnBrZ3JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAxMzYyOTgsImV4cCI6MjA4NTcxMjI5OH0.Iw5KYmIP_OHalA2tyHAiKSI6xQa-EE5urL_4aEygzg0";

async function getRoleClient(role: any) {
  const config = getRoleTestConfig(role);
  const client = createClient(url, anonKey);
  const { data, error } = await client.auth.signInWithPassword({
    email: config.email,
    password: config.password,
  });
  if (error) throw new Error(`Login failed for ${role}: ${error.message}`);
  return { client, user: data.user };
}

test.describe("Service Request Workflow Emulation (DB Truth)", () => {
  let requestId: string;

  test("End-to-End Service Request Lifecycle", async () => {
    const fixtureIds = readFeatureFixtureState().ids;
    
    // 1. Resident (Creation)
    const { client: residentClient, user: residentUser } = await getRoleClient("resident");
    
    requestId = crypto.randomUUID();
    console.log("[workflow-emulation] Creating request and service request as resident...");
    const { error: reqError } = await residentClient.from("requests").insert({
      id: requestId,
      title: "Test Request Workflow",
      buyer_id: residentUser.id
    });
    if (reqError) console.error("Request Insert Error:", reqError);
    expect(reqError).toBeNull();

    const { error: createError, data: createdData } = await residentClient.from("service_requests").insert({
      id: requestId,
      title: "Test Request Workflow",
      description: "Testing e2e workflow emulation",
      type: "service_request",
      priority: "normal",
      status: "open",
      requester_id: residentUser.id,
      society_id: fixtureIds.societyId,
      request_number: `SR-${Date.now()}`
    }).select();
    
    if (createError) console.error("Create Error:", createError);
    expect(createError).toBeNull();
    
    // 2. Helpdesk (Dispatch)
    console.log("[workflow-emulation] Dispatching as admin...");
    const { client: adminClient } = await getRoleClient("admin");
    const { error: dispatchError } = await adminClient.from("service_requests")
      .update({ status: "assigned", assigned_to: fixtureIds.acTechnicianEmployeeId })
      .eq("id", requestId);
      
    if (dispatchError) console.error("Dispatch Error:", dispatchError);
    expect(dispatchError).toBeNull();

    // 3. Technician (In Progress)
    console.log("[workflow-emulation] Starting work as technician...");
    const { client: techClient } = await getRoleClient("ac_technician");
    const { error: startError } = await techClient.from("service_requests")
      .update({ status: "in_progress" })
      .eq("id", requestId);
      
    if (startError) console.error("Start Error:", startError);
    expect(startError).toBeNull();

    // 4. Technician (Accept/Resolve)
    console.log("[workflow-emulation] Resolving as technician...");
    const { error: resolveError } = await techClient.from("service_requests")
      .update({ 
        status: "completed", 
        completion_notes: "Fixed the reported issue completely with new parts.",
        resolution_notes: "Fixed the reported issue completely with new parts.",
        before_photo_url: "https://example.com/before.jpg",
        after_photo_url: "https://example.com/after.jpg"
      })
      .eq("id", requestId);
      
    if (resolveError) console.error("Resolve Error:", resolveError);
    expect(resolveError).toBeNull();

    // 5. Resident (Feedback)
    console.log("[workflow-emulation] Submitting buyer feedback as resident...");
    const { error: feedbackError } = await residentClient.from("buyer_feedback").insert({
      request_id: requestId,
      service_request_id: requestId,
      overall_rating: 5,
      quality_rating: 5,
      delivery_rating: 5,
      professionalism_rating: 5,
      would_recommend: true,
      comments: "Great service",
      submitted_by: residentUser.id
    });
    if (feedbackError) console.error("Feedback Error:", feedbackError);
    expect(feedbackError).toBeNull();

    // 6. Quality Auditor / Manager (Verify)
    console.log("[workflow-emulation] Verifying as society manager...");
    const { client: managerClient } = await getRoleClient("society_manager");
    const { error: verifyError } = await managerClient.from("service_requests")
      .update({ status: "closed" })
      .eq("id", requestId);
      
    if (verifyError) console.error("Verify Error:", verifyError);
    expect(verifyError).toBeNull();
  });
});
