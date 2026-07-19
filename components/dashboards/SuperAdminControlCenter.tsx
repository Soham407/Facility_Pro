import { useState } from "react";
import Link from "next/link";
import { ArrowRight, Settings2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export function SuperAdminControlCenter() {
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const items = [
    {
      href: "/settings/admins",
      title: "Admin Management",
      description: "Invite, suspend, promote, and reset admin-tier accounts.",
    },
    {
      href: "/settings/permissions",
      title: "Role & Permissions",
      description: "Assign the platform permission keys for this slice.",
    },
    {
      href: "/settings/audit-logs",
      title: "Audit Logs",
      description: "Inspect platform actions across accounts, roles, and settings.",
    },
    {
      href: "/settings/company",
      title: "System Configuration",
      description: "Tune inactivity, geo-fence, and checklist thresholds.",
    },
  ];

  return (
    <Card className="border-none shadow-card ring-1 ring-border xl:col-span-2">
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-sm font-bold uppercase tracking-widest">
            Platform Control Center
          </CardTitle>
          <CardDescription>
            Core platform administration surfaces for the super admin role.
          </CardDescription>
        </div>
        <Button
          type="button"
          variant="outline"
          size="sm"
          className="gap-2"
          aria-expanded={isSettingsOpen}
          onClick={() => setIsSettingsOpen((value) => !value)}
        >
          <Settings2 className="h-4 w-4" />
          Settings
        </Button>
      </CardHeader>
      <CardContent className="grid gap-4 md:grid-cols-2">
        {isSettingsOpen ? (
          items.map((item) => (
            <Link key={item.href} href={item.href}>
              <Card className="h-full border border-border/60 bg-muted/10 transition-all hover:border-primary/40 hover:bg-primary/5">
                <CardContent className="flex h-full flex-col justify-between gap-4 p-5">
                  <div>
                    <p className="text-sm font-bold">{item.title}</p>
                    <p className="mt-1 text-xs text-muted-foreground">{item.description}</p>
                  </div>
                  <div className="flex items-center text-xs font-semibold text-primary">
                    Open module <ArrowRight className="ml-1 h-3.5 w-3.5" />
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))
        ) : (
          <div className="md:col-span-2 rounded-xl border border-dashed border-border/70 bg-muted/20 p-5 text-sm text-muted-foreground">
            Open Settings to manage admin accounts, role permissions, audit logs, and system configuration.
          </div>
        )}
      </CardContent>
    </Card>
  );
}
