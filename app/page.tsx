import Image from "next/image";
import Link from "next/link";
import {
  ArrowRight,
  BriefcaseBusiness,
  Building2,
  ClipboardCheck,
  Shield,
  Siren,
  Users,
  Warehouse,
} from "lucide-react";

import { BrandLogo } from "@/components/branding/BrandLogo";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  BRAND_LEGAL_NAME,
  BRAND_NAME,
  BRAND_PORTAL_LABEL,
  BRAND_TAGLINE,
} from "@/src/lib/brand";

const stakeholderRoles = [
  "Admin",
  "Company MD",
  "Company HOD",
  "Account",
  "Delivery Boy",
  "Buyer",
  "Supplier / Vendor",
  "Security Guard",
  "Security Supervisor",
  "Society Manager",
  "Service Boy",
];

const serviceVerticals = [
  {
    title: "Facility Management & Services",
    description:
      "Security, housekeeping, pantry support, office staffing, and grade-based deployment managed from one operational flow.",
    image: "/ServiceImages/Security_Guard.png",
  },
  {
    title: "Air Conditioner Services",
    description:
      "Technician assignment, inventory-linked spare issue, GPS-backed job tracking, and before/after proof for each service request.",
    image: "/ServiceImages/AC Maint.png",
  },
  {
    title: "Plantation Services",
    description:
      "Planned site upkeep, recurring work allocation, and service execution tracking for indoor and outdoor green spaces.",
    image: "/ServiceImages/Housekeeping.png",
  },
  {
    title: "Printing & Advertising Services",
    description:
      "Service requests, vendor coordination, and delivery workflow support for client-facing printing and promotional work.",
    image: "/ServiceImages/Corporate Gifting.png",
  },
  {
    title: "Pest Control Services",
    description:
      "PPE-gated execution, technician attendance, chemical stock handling, and expiry-aware operational control.",
    image: "/ServiceImages/Pest Control.png",
  },
];

const masterModules = [
  {
    icon: Building2,
    title: "Company Master",
    points: [
      "Role Master",
      "Designation Master",
      "Employee Master",
      "User Master",
    ],
  },
  {
    icon: Warehouse,
    title: "Supply Module Master",
    points: [
      "Product Category and Subcategory",
      "Product Master",
      "Supplier Details",
      "Supplier-wise Product and Rate",
      "Sale Product Rate",
    ],
  },
  {
    icon: ClipboardCheck,
    title: "Services Module Master",
    points: [
      "Daily Checklist Master",
      "Vendor Wise Services Master",
      "Work Master",
      "Services Wise Work Master",
    ],
  },
  {
    icon: Users,
    title: "HRMS Module Master",
    points: [
      "Leave Type Master",
      "Holiday Master",
      "Company Event",
      "Company Location Master",
    ],
  },
];

const workflows = [
  {
    title: "Material Supply Workflow",
    steps: [
      "Buyer submits order request",
      "Admin accepts, rejects, or holds",
      "Indent and purchase order issued to supplier",
      "Store receipt, billing, payment, and feedback closure",
    ],
  },
  {
    title: "Service Deployment Workflow",
    steps: [
      "Buyer selects service category, grade, and headcount",
      "Admin verifies rates and forwards service indent",
      "Supplier dispatches personnel with delivery note",
      "Supervisor confirms deployment and finance closes the cycle",
    ],
  },
  {
    title: "Technical Service Workflow",
    steps: [
      "Resident or manager raises complaint",
      "Technician is assigned and checks in with GPS",
      "Before/after proof and parts or chemical usage are recorded",
      "Manager reviews and closes the job ticket",
    ],
  },
];

const controlSystems = [
  {
    icon: Siren,
    title: "Security Guard Monitoring",
    body: "Panic response, inactivity alerts, daily checklists, and emergency contacts are treated as first-class operational controls.",
  },
  {
    icon: Shield,
    title: "Visitor Management",
    body: "Visitor entry, resident verification, frequent visitor handling, and society-facing notifications stay visible to guards and managers.",
  },
  {
    icon: BriefcaseBusiness,
    title: "Behavior Ticketing",
    body: "Managers can raise employee behavior tickets with evidence, time stamp, incident notes, and severity level.",
  },
];

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-[linear-gradient(180deg,#f8fafc_0%,#eef4f8_100%)]">
      <nav className="sticky top-0 z-50 border-b border-border/60 bg-white/92 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <div className="w-14 shrink-0 rounded-2xl bg-secondary p-2.5 ring-1 ring-border/70">
              <BrandLogo className="w-full" priority />
            </div>
            <div className="min-w-0">
              <p className="truncate text-[10px] font-semibold uppercase tracking-[0.24em] text-primary/60">
                {BRAND_LEGAL_NAME}
              </p>
              <p className="mt-1 truncate text-lg font-semibold text-primary">
                {BRAND_NAME}
              </p>
            </div>
          </div>
          <Link href="/login">
            <Button className="rounded-full px-5">
              Sign In
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </Link>
        </div>
      </nav>

      <section className="px-4 pb-20 pt-16 sm:px-6 lg:px-8 lg:pt-20">
        <div className="mx-auto grid max-w-7xl gap-10 lg:grid-cols-[1.05fr_0.95fr] lg:items-center">
          <div>
            <Badge className="bg-primary/10 text-primary hover:bg-primary/10">
              Facility Management & Services Platform
            </Badge>
            <h1 className="mt-5 max-w-4xl text-4xl font-semibold leading-tight text-primary sm:text-5xl lg:text-6xl">
              PRD-aligned operations for company, buyer, supplier, and field teams.
            </h1>
            <p className="mt-5 max-w-3xl text-lg leading-relaxed text-muted-foreground sm:text-xl">
              {BRAND_TAGLINE}. The platform is centered on master data, procurement,
              staffing, security operations, visitor control, and technical service
              execution described in the product requirements document.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link href="/login">
                <Button size="lg" className="rounded-full px-7">
                  Open Portal
                </Button>
              </Link>
              <a href="#scope">
                <Button variant="outline" size="lg" className="rounded-full px-7">
                  Review Scope
                </Button>
              </a>
            </div>
            <div className="mt-10 flex flex-wrap gap-2">
              {stakeholderRoles.map((role) => (
                <Badge
                  key={role}
                  variant="secondary"
                  className="rounded-full px-3 py-1 text-xs"
                >
                  {role}
                </Badge>
              ))}
            </div>
          </div>

          <div className="overflow-hidden rounded-[2rem] border border-primary/10 bg-white shadow-[0_30px_80px_-40px_rgba(10,63,99,0.35)]">
            <div className="border-b border-border/70 bg-primary px-6 py-5 text-white">
              <p className="text-[11px] font-semibold uppercase tracking-[0.28em] text-white/70">
                {BRAND_PORTAL_LABEL}
              </p>
              <h2 className="mt-2 text-2xl font-semibold">
                Operational layers defined by the PRD
              </h2>
            </div>
            <div className="grid gap-4 p-6 sm:grid-cols-2">
              {masterModules.map(({ icon: Icon, title, points }) => (
                <div key={title} className="rounded-2xl border border-border/70 bg-secondary/40 p-5">
                  <div className="flex h-11 w-11 items-center justify-center rounded-full bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <h3 className="mt-4 text-lg font-semibold text-primary">{title}</h3>
                  <ul className="mt-3 space-y-2 text-sm text-muted-foreground">
                    {points.map((point) => (
                      <li key={point}>{point}</li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section id="scope" className="border-y border-border/60 bg-white/80 px-4 py-20 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-7xl">
          <div className="max-w-3xl">
            <Badge variant="secondary">Service Catalogue</Badge>
            <h2 className="mt-4 text-3xl font-semibold text-primary sm:text-4xl">
              Only the service verticals defined in the PRD.
            </h2>
            <p className="mt-4 text-lg leading-relaxed text-muted-foreground">
              The website now presents the platform through the five declared service
              lines instead of unrelated offerings.
            </p>
          </div>

          <div className="mt-12 grid gap-6 md:grid-cols-2 xl:grid-cols-5">
            {serviceVerticals.map((service) => (
              <article
                key={service.title}
                className="overflow-hidden rounded-[1.6rem] border border-border/70 bg-white shadow-sm"
              >
                <div className="relative aspect-[4/3]">
                  <Image
                    src={service.image}
                    alt={service.title}
                    fill
                    unoptimized
                    sizes="(min-width: 1280px) 18rem, (min-width: 768px) 42vw, 100vw"
                    className="object-cover"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-primary/70 via-primary/15 to-transparent" />
                </div>
                <div className="p-5">
                  <h3 className="text-lg font-semibold text-primary">{service.title}</h3>
                  <p className="mt-3 text-sm leading-relaxed text-muted-foreground">
                    {service.description}
                  </p>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="px-4 py-20 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-7xl">
          <div className="max-w-3xl">
            <Badge variant="secondary">Core Workflows</Badge>
            <h2 className="mt-4 text-3xl font-semibold text-primary sm:text-4xl">
              Request-to-closure flows that match the PRD.
            </h2>
          </div>

          <div className="mt-12 grid gap-6 lg:grid-cols-3">
            {workflows.map((workflow, index) => (
              <div
                key={workflow.title}
                className="rounded-[1.6rem] border border-border/70 bg-white p-6 shadow-sm"
              >
                <div className="flex h-11 w-11 items-center justify-center rounded-full bg-primary text-sm font-semibold text-primary-foreground">
                  0{index + 1}
                </div>
                <h3 className="mt-5 text-xl font-semibold text-primary">{workflow.title}</h3>
                <ul className="mt-4 space-y-3 text-sm leading-relaxed text-muted-foreground">
                  {workflow.steps.map((step) => (
                    <li key={step}>{step}</li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="bg-primary px-4 py-20 text-white sm:px-6 lg:px-8">
        <div className="mx-auto max-w-7xl">
          <div className="max-w-3xl">
            <Badge className="bg-white/10 text-white hover:bg-white/10">
              Security, Society, and Compliance
            </Badge>
            <h2 className="mt-4 text-3xl font-semibold sm:text-4xl">
              Guard monitoring, visitor control, and incident accountability stay in scope.
            </h2>
          </div>

          <div className="mt-12 grid gap-6 md:grid-cols-3">
            {controlSystems.map(({ icon: Icon, title, body }) => (
              <div key={title} className="rounded-[1.6rem] border border-white/10 bg-white/8 p-6 backdrop-blur-sm">
                <div className="flex h-11 w-11 items-center justify-center rounded-full bg-white/12">
                  <Icon className="h-5 w-5" />
                </div>
                <h3 className="mt-5 text-xl font-semibold">{title}</h3>
                <p className="mt-3 text-sm leading-relaxed text-white/72">{body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="px-4 py-20 sm:px-6 lg:px-8">
        <div className="mx-auto flex max-w-5xl flex-col items-start justify-between gap-8 rounded-[2rem] border border-border/70 bg-white p-8 shadow-sm lg:flex-row lg:items-center">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.24em] text-primary/60">
              Scope Positioning
            </p>
            <h2 className="mt-3 text-3xl font-semibold text-primary">
              A tighter product surface shaped around the PRD.
            </h2>
            <p className="mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
              The public site and the in-product navigation are now intended to expose
              the operational modules named in the PRD and hide unrelated system areas.
            </p>
          </div>
          <Link href="/login">
            <Button size="lg" className="rounded-full px-7">
              Enter {BRAND_NAME}
            </Button>
          </Link>
        </div>
      </section>
    </div>
  );
}
