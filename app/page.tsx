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
    title: "Facility Management",
    description:
      "Security, housekeeping, pantry support, office staffing, and grade-based deployment.",
    image: "/ServiceImages/Security_Guard.png",
  },
  {
    title: "Air Conditioner Services",
    description:
      "Technician assignment, inventory-linked spare issue, GPS-backed job tracking.",
    image: "/ServiceImages/AC Maint.png",
  },
  {
    title: "Plantation Services",
    description:
      "Planned site upkeep, recurring work allocation, and service execution tracking.",
    image: "/ServiceImages/Housekeeping.png",
  },
  {
    title: "Printing & Advertising",
    description:
      "Service requests, vendor coordination, and delivery workflow support.",
    image: "/ServiceImages/Corporate Gifting.png",
  },
  {
    title: "Pest Control",
    description:
      "PPE-gated execution, technician attendance, chemical stock handling.",
    image: "/ServiceImages/Pest Control.png",
  },
];

const masterModules = [
  {
    icon: Building2,
    title: "Company Setup",
    points: [
      "Role & Designation",
      "Employee Tracking",
      "User Accounts",
    ],
  },
  {
    icon: Warehouse,
    title: "Supply Chain",
    points: [
      "Product Catalog",
      "Supplier Rates",
      "Sales Pricing",
    ],
  },
  {
    icon: ClipboardCheck,
    title: "Service Operations",
    points: [
      "Daily Checklists",
      "Vendor Dispatch",
      "Work Allocation",
    ],
  },
  {
    icon: Users,
    title: "HR & Attendance",
    points: [
      "Leave & Holidays",
      "Company Events",
      "Location Tracking",
    ],
  },
];

const workflows = [
  {
    title: "Material Supply",
    steps: [
      "Buyer submits order request",
      "Admin reviews and approves",
      "Purchase order issued to supplier",
      "Store receipt and payment closure",
    ],
  },
  {
    title: "Service Deployment",
    steps: [
      "Buyer selects headcount and grade",
      "Admin forwards service indent",
      "Supplier dispatches personnel",
      "Supervisor confirms deployment",
    ],
  },
  {
    title: "Technical Support",
    steps: [
      "Resident raises complaint",
      "Technician checks in with GPS",
      "Before/after proof recorded",
      "Manager closes job ticket",
    ],
  },
];

const controlSystems = [
  {
    icon: Siren,
    title: "Guard Monitoring",
    body: "Panic response, inactivity alerts, and daily checklists.",
  },
  {
    icon: Shield,
    title: "Visitor Log",
    body: "Entry verification, frequent visitors, and society notifications.",
  },
  {
    icon: BriefcaseBusiness,
    title: "Behavior Ticketing",
    body: "Incident recording with evidence, timestamps, and severity.",
  },
];

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-background">
      <nav className="sticky top-0 z-50 border-b bg-background">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-foreground p-2">
              <BrandLogo className="w-full h-full text-background" priority />
            </div>
            <div>
              <p className="text-[10px] font-mono uppercase tracking-widest text-muted-foreground">
                {BRAND_LEGAL_NAME}
              </p>
              <p className="text-lg font-medium tracking-tight">
                {BRAND_NAME}
              </p>
            </div>
          </div>
          <Link href="/login">
            <Button className="rounded-none px-6 uppercase text-xs tracking-wider">
              System Login
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </Link>
        </div>
      </nav>

      <section className="border-b">
        <div className="mx-auto max-w-7xl px-4 py-24 sm:px-6 lg:px-8">
          <div className="max-w-4xl">
            <h1 className="text-5xl font-medium tracking-tight text-foreground sm:text-6xl md:text-7xl">
              Facility Operations Control.
            </h1>
            <p className="mt-6 text-xl text-muted-foreground max-w-2xl font-mono">
              {BRAND_TAGLINE}. Master data, procurement,
              staffing, security operations, visitor control, and technical service
              execution.
            </p>
            <div className="mt-10 flex gap-4">
              <Link href="/login">
                <Button size="lg" className="rounded-none bg-primary text-primary-foreground hover:bg-primary/90 uppercase text-xs tracking-wider px-8">
                  Access Portal
                </Button>
              </Link>
            </div>
            <div className="mt-16 flex flex-wrap gap-2">
              {stakeholderRoles.map((role) => (
                <div
                  key={role}
                  className="border px-3 py-1 text-[10px] uppercase tracking-wider font-mono text-muted-foreground"
                >
                  {role}
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="border-b bg-secondary/30">
        <div className="mx-auto max-w-7xl px-4 py-20 sm:px-6 lg:px-8">
          <div className="grid gap-8 lg:grid-cols-4">
            <div className="lg:col-span-1">
              <p className="text-[10px] uppercase font-mono tracking-widest text-muted-foreground mb-4">
                01 / {BRAND_PORTAL_LABEL}
              </p>
              <h2 className="text-2xl font-medium">Core Modules</h2>
            </div>
            <div className="lg:col-span-3 grid gap-6 sm:grid-cols-2">
              {masterModules.map(({ icon: Icon, title, points }) => (
                <div key={title} className="border bg-background p-6">
                  <Icon className="h-6 w-6 text-primary mb-4" />
                  <h3 className="text-lg font-medium mb-4">{title}</h3>
                  <ul className="space-y-2 text-sm text-muted-foreground font-mono">
                    {points.map((point) => (
                      <li key={point} className="flex items-center before:content-['-'] before:mr-2">
                        {point}
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="border-b">
        <div className="mx-auto max-w-7xl px-4 py-20 sm:px-6 lg:px-8">
          <div className="grid gap-8 lg:grid-cols-4 mb-12">
            <div className="lg:col-span-1">
              <p className="text-[10px] uppercase font-mono tracking-widest text-muted-foreground mb-4">
                02 / Service Lines
              </p>
              <h2 className="text-2xl font-medium">Supported Verticals</h2>
            </div>
          </div>
          <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-5">
            {serviceVerticals.map((service) => (
              <article
                key={service.title}
                className="group border bg-background flex flex-col"
              >
                <div className="relative aspect-[4/3] border-b grayscale transition-all duration-300 group-hover:grayscale-0">
                  <Image
                    src={service.image}
                    alt={service.title}
                    fill
                    unoptimized
                    sizes="(min-width: 1280px) 18rem, (min-width: 768px) 42vw, 100vw"
                    className="object-cover"
                  />
                </div>
                <div className="p-5 flex-1 flex flex-col">
                  <h3 className="text-base font-medium mb-2">{service.title}</h3>
                  <p className="text-xs text-muted-foreground font-mono mt-auto">
                    {service.description}
                  </p>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="border-b bg-secondary/30">
        <div className="mx-auto max-w-7xl px-4 py-20 sm:px-6 lg:px-8">
          <div className="grid gap-8 lg:grid-cols-4 mb-12">
            <div className="lg:col-span-1">
              <p className="text-[10px] uppercase font-mono tracking-widest text-muted-foreground mb-4">
                03 / Operations
              </p>
              <h2 className="text-2xl font-medium">Standard Workflows</h2>
            </div>
          </div>
          <div className="grid gap-6 lg:grid-cols-3">
            {workflows.map((workflow, index) => (
              <div
                key={workflow.title}
                className="border bg-background p-6"
              >
                <div className="text-[10px] font-mono text-primary mb-6">
                  FLOW_0{index + 1}
                </div>
                <h3 className="text-lg font-medium mb-4">{workflow.title}</h3>
                <ol className="space-y-4 text-xs font-mono text-muted-foreground">
                  {workflow.steps.map((step, i) => (
                    <li key={step} className="flex">
                      <span className="w-6 text-foreground/40">{i + 1}.</span>
                      <span>{step}</span>
                    </li>
                  ))}
                </ol>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="border-b bg-foreground text-background">
        <div className="mx-auto max-w-7xl px-4 py-20 sm:px-6 lg:px-8">
          <div className="grid gap-8 lg:grid-cols-4 mb-12">
            <div className="lg:col-span-1">
              <p className="text-[10px] uppercase font-mono tracking-widest text-background/50 mb-4">
                04 / Compliance
              </p>
              <h2 className="text-2xl font-medium">Security & Society</h2>
            </div>
          </div>
          <div className="grid gap-6 md:grid-cols-3">
            {controlSystems.map(({ icon: Icon, title, body }) => (
              <div key={title} className="border border-background/20 p-6">
                <Icon className="h-6 w-6 mb-4 text-primary" />
                <h3 className="text-lg font-medium mb-2">{title}</h3>
                <p className="text-xs font-mono text-background/70">{body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="bg-background">
        <div className="mx-auto max-w-7xl px-4 py-24 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-medium mb-8">
            System Ready.
          </h2>
          <Link href="/login">
            <Button size="lg" className="rounded-none bg-primary text-primary-foreground hover:bg-primary/90 uppercase text-xs tracking-wider px-12 py-6">
              Initialize Session
            </Button>
          </Link>
        </div>
      </section>
    </div>
  );
}
