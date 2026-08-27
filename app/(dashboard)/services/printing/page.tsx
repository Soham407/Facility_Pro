"use client";

import { PageHeader } from "@/components/shared/PageHeader";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Printer } from "lucide-react";
import { IDPrintingModule } from "@/components/printing/IDPrintingModule";

export default function PrintingAdvertisingPage() {
  return (
    <div className="animate-fade-in space-y-8 pb-10">
      <PageHeader
        title="Printing Services"
        description="Generate ID cards and visitor passes."
      />

      <Card className="border-none shadow-card ring-1 ring-border">
        <CardHeader className="border-b bg-muted/10">
          <CardTitle className="flex items-center gap-2 text-sm uppercase tracking-widest">
            <Printer className="h-4 w-4" />
            Internal Printing Workflow
          </CardTitle>
          <CardDescription>
            Visitor passes, staff ID cards, and contractor credentials are generated here.
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <IDPrintingModule />
        </CardContent>
      </Card>
    </div>
  );
}
