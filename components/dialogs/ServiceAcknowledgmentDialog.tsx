"use client";

import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Separator } from "@/components/ui/separator";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { CheckCircle2, Loader2, AlertTriangle, Users } from "lucide-react";
import { supabase as supabaseTyped } from "@/src/lib/supabaseClient";
import { useToast } from "@/components/ui/use-toast";
import { ServicePurchaseOrder } from "@/hooks/useServicePurchaseOrders";
import type { Resolver } from "react-hook-form";

const supabase = supabaseTyped;

const formSchema = z.object({
  headcount_received: z.coerce.number().min(0, "Must be 0 or more"),
  grade_verified: z.boolean().default(false),
  notes: z.string().optional(),
});

type FormValues = {
  headcount_received: number;
  grade_verified: boolean;
  notes?: string;
};

interface ServiceAcknowledgmentDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  spo: ServicePurchaseOrder;
  onConfirm: () => void;
}

export function ServiceAcknowledgmentDialog({
  open,
  onOpenChange,
  spo,
  onConfirm,
}: ServiceAcknowledgmentDialogProps) {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [expectedHeadcount, setExpectedHeadcount] = useState<number | null>(null);
  const [isLoadingItems, setIsLoadingItems] = useState(false);
  const { toast } = useToast();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema) as Resolver<FormValues>,
    defaultValues: {
      headcount_received: 0,
      grade_verified: false,
      notes: "",
    },
  });

  const headcountReceived = form.watch("headcount_received");
  const hasMismatch =
    expectedHeadcount !== null &&
    Number(headcountReceived) !== expectedHeadcount;

  // Fetch SPO items to calculate expected headcount
  useEffect(() => {
    if (!open || !spo?.id) return;

    setIsLoadingItems(true);
    setExpectedHeadcount(null);

    supabase
      .from("service_purchase_order_items")
      .select("quantity")
      .eq("spo_id", spo.id)
      .then(({ data, error }) => {
        if (!error && data && data.length > 0) {
          const total = data.reduce((sum, item) => sum + (item.quantity ?? 0), 0);
          setExpectedHeadcount(total);
          form.setValue("headcount_received", total);
        }
        setIsLoadingItems(false);
      });
  }, [open, spo?.id]);

  // Reset form when dialog closes
  useEffect(() => {
    if (!open) {
      form.reset();
      setExpectedHeadcount(null);
    }
  }, [open]);

  const handleSubmit = async (values: FormValues) => {
    if (hasMismatch && !values.notes?.trim()) {
      form.setError("notes", { message: "Notes are required when headcount mismatches" });
      return;
    }
    setIsSubmitting(true);
    try {
      const { data: acknowledgedDeployment, error: acknowledgmentCheckError } = await supabase
        .from("service_acknowledgments")
        .select("status")
        .eq("spo_id", spo.id)
        .eq("status", "acknowledged")
        .maybeSingle();

      if (acknowledgmentCheckError) {
        throw acknowledgmentCheckError;
      }

      if (!acknowledgedDeployment) {
        throw new Error("Deployment acknowledgment is required before confirming billing.");
      }

      // The acknowledge-deployment route keeps service_acknowledgments at status: 'acknowledged'
      // and follows up with update({ status: "deployment_confirmed" ... }) after validation.
      const response = await fetch("/api/service-orders/acknowledge-deployment", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          spoId: spo.id,
          headcountReceived: values.headcount_received,
          gradeVerified: values.grade_verified,
          notes: values.notes || null,
        }),
      });
      const result = await response.json().catch(() => null);
      if (!response.ok || !result?.success) {
        throw new Error(result?.error || "Failed to acknowledge deployment");
      }

      toast({ title: "Deployment confirmed", description: `SPO ${spo.spo_number} has been acknowledged.` });
      form.reset();
      onOpenChange(false);
      onConfirm();
    } catch (err: unknown) {
      console.error("Acknowledgment error:", err);
      toast({
        title: "Error",
        description: err instanceof Error ? err.message : "Failed to acknowledge deployment",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <CheckCircle2 className="h-5 w-5 text-primary" />
            Acknowledge Deployment
          </DialogTitle>
          <p className="text-xs text-muted-foreground">
            SPO: <span className="font-mono font-bold">{spo.spo_number}</span>
            {" · "}{spo.service_type}
          </p>
        </DialogHeader>

        <form onSubmit={form.handleSubmit(handleSubmit)}>
          <div className="space-y-4 py-2">
            {/* Expected headcount (read-only, from SPO items) */}
            <div className="flex items-center gap-3 p-3 rounded-xl border bg-muted/20">
              <Users className="h-4 w-4 text-muted-foreground shrink-0" />
              <div className="flex flex-col flex-1">
                <span className="text-xs font-bold uppercase text-muted-foreground">Expected Headcount (from SPO)</span>
                <span className="text-sm font-bold">
                  {isLoadingItems ? (
                    <span className="text-muted-foreground">Loading…</span>
                  ) : expectedHeadcount !== null ? (
                    expectedHeadcount
                  ) : (
                    <span className="text-muted-foreground">—</span>
                  )}
                </span>
              </div>
            </div>

            <div className="space-y-1.5">
              <Label className="text-xs font-bold uppercase">Headcount Received</Label>
              <Input
                type="number"
                min={0}
                placeholder="Number of personnel received"
                {...form.register("headcount_received")}
              />
              {form.formState.errors.headcount_received && (
                <p className="text-xs text-destructive">{form.formState.errors.headcount_received.message}</p>
              )}
            </div>

            {/* Mismatch warning */}
            {hasMismatch && (
              <Alert variant="destructive" className="py-2.5">
                <AlertTriangle className="h-4 w-4" />
                <AlertDescription className="text-xs">
                  Headcount mismatch: expected <strong>{expectedHeadcount}</strong>, receiving{" "}
                  <strong>{headcountReceived}</strong>. Please add a note explaining the discrepancy.
                </AlertDescription>
              </Alert>
            )}

            <Separator />

            <div className="flex items-center gap-3 p-3 rounded-xl border bg-muted/20">
              <Checkbox
                id="grade_verified"
                checked={form.watch("grade_verified")}
                onCheckedChange={(checked) => form.setValue("grade_verified", !!checked)}
              />
              <div className="flex flex-col">
                <Label htmlFor="grade_verified" className="text-sm font-bold cursor-pointer">
                  Grade / Role Verified
                </Label>
                <p className="text-xs text-muted-foreground">
                  All deployed personnel match the required qualification and role
                </p>
              </div>
            </div>

            <div className="space-y-1.5">
              <Label className="text-xs font-bold uppercase">Acknowledgment Notes</Label>
              <Textarea
                placeholder={hasMismatch ? "Required: explain the headcount discrepancy..." : "Any observations or remarks about this deployment..."}
                rows={3}
                {...form.register("notes")}
              />
              {form.formState.errors.notes && (
                <p className="text-xs text-destructive">{form.formState.errors.notes.message}</p>
              )}
            </div>
          </div>

          <DialogFooter className="pt-4">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" disabled={isSubmitting || isLoadingItems} className="gap-2">
              {isSubmitting ? <Loader2 className="h-4 w-4 animate-spin" /> : <CheckCircle2 className="h-4 w-4" />}
              Confirm Deployment
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
