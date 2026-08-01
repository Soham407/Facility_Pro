import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/src/lib/supabase/admin";

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function createWaitlistClient() {
  return createAdminClient();
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { email, name, company } = body;

    if (!email || typeof email !== "string") {
      return NextResponse.json({ error: "A valid email is required." }, { status: 400 });
    }

    const normalizedEmail = email.toLowerCase().trim();

    if (!EMAIL_REGEX.test(normalizedEmail)) {
      return NextResponse.json({ error: "A valid email is required." }, { status: 400 });
    }

    const supabase = createWaitlistClient();

    const { error } = await supabase.from("waitlist").insert({
      email: normalizedEmail,
      name: typeof name === "string" ? name.trim() || null : null,
      company: typeof company === "string" ? company.trim() || null : null,
    });

    if (error) {
      if (error.code === "23505") {
        return NextResponse.json({ message: "You're already on the waitlist! We'll be in touch soon." });
      }

      console.error("[waitlist] insert error:", error);
      return NextResponse.json({ error: "Failed to join waitlist. Please try again." }, { status: 500 });
    }

    return NextResponse.json({ message: "You're on the waitlist! We'll notify you at launch. ??" });
  } catch (error) {
    console.error("[waitlist] unexpected error:", error);
    return NextResponse.json(
      {
        error: error instanceof Error ? error.message : "Failed to join waitlist. Please try again.",
      },
      { status: 500 }
    );
  }
}
