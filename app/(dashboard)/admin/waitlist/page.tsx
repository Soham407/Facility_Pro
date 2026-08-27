"use client";

import React, { useState } from "react";
import { useWaitlist, WAITLIST_STATUSES, WAITLIST_STATUS_CONFIG, WaitlistStatus } from "@/hooks/useWaitlist";
import { DataTable } from "@/components/shared/DataTable";
import { ColumnDef } from "@tanstack/react-table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Clock, CheckCircle2, XCircle, MoreHorizontal, RefreshCw } from "lucide-react";
import { toast } from "sonner";

export default function WaitlistPage() {
  const { entries, stats, isLoading, refresh, updateWaitlistStatus, isUpdatingStatus } = useWaitlist();
  const [updatingId, setUpdatingId] = useState<string | null>(null);

  const handleStatusChange = async (id: string, status: WaitlistStatus) => {
    setUpdatingId(id);
    try {
      await updateWaitlistStatus({ id, status });
      toast.success(`Entry ${status === "approved" ? "approved" : status === "rejected" ? "rejected" : "set to pending"}`);
      refresh();
    } catch {
      toast.error("Failed to update status");
    } finally {
      setUpdatingId(null);
    }
  };

  const columns: ColumnDef<(typeof entries)[0]>[] = [
    {
      accessorKey: "name",
      header: "Name",
      cell: ({ row }) => (
        <span className="font-medium text-foreground">
          {row.original.name || "—"}
        </span>
      ),
    },
    {
      accessorKey: "email",
      header: "Email",
      cell: ({ row }) => (
        <span className="text-muted-foreground">{row.original.email}</span>
      ),
    },
    {
      accessorKey: "company",
      header: "Company",
      cell: ({ row }) => (
        <span className="text-muted-foreground">
          {row.original.company || "—"}
        </span>
      ),
    },
    {
      accessorKey: "created_at",
      header: "Submitted",
      cell: ({ row }) => (
        <span className="text-xs text-muted-foreground">
          {row.original.created_at
            ? new Date(row.original.created_at).toLocaleDateString("en-IN", {
                day: "numeric",
                month: "short",
                year: "numeric",
              })
            : "—"}
        </span>
      ),
    },
    {
      accessorKey: "status",
      header: "Status",
      cell: ({ row }) => {
        const status = row.original.status;
        const config = WAITLIST_STATUS_CONFIG[status];
        return (
          <Badge variant="outline" className={config.className}>
            {config.label}
          </Badge>
        );
      },
    },
    {
      id: "actions",
      header: "",
      cell: ({ row }) => {
        const entry = row.original;
        const isUpdating = updatingId === entry.id && isUpdatingStatus;
        return (
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="sm" className="h-8 w-8 p-0" disabled={isUpdating}>
                {isUpdating ? (
                  <RefreshCw className="h-4 w-4 animate-spin" />
                ) : (
                  <MoreHorizontal className="h-4 w-4" />
                )}
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              {WAITLIST_STATUSES.filter((s) => s !== entry.status).map((status) => (
                <DropdownMenuItem
                  key={status}
                  onClick={() => handleStatusChange(entry.id, status)}
                >
                  {status === "approved" && <CheckCircle2 className="mr-2 h-4 w-4 text-success" />}
                  {status === "rejected" && <XCircle className="mr-2 h-4 w-4 text-destructive" />}
                  {status === "pending" && <Clock className="mr-2 h-4 w-4 text-warning" />}
                  Mark as {WAITLIST_STATUS_CONFIG[status].label}
                </DropdownMenuItem>
              ))}
            </DropdownMenuContent>
          </DropdownMenu>
        );
      },
    },
  ];

  const statCards = [
    { label: "Total", value: stats.total, icon: Users, color: "text-primary" },
    { label: "Pending", value: stats.pending, icon: Clock, color: "text-warning" },
    { label: "Approved", value: stats.approved, icon: CheckCircle2, color: "text-success" },
    { label: "Rejected", value: stats.rejected, icon: XCircle, color: "text-destructive" },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Waitlist Management</h1>
          <p className="text-muted-foreground text-sm mt-1">
            Review and manage platform access requests
          </p>
        </div>
        <Button variant="outline" size="sm" onClick={refresh} className="gap-2">
          <RefreshCw className="h-4 w-4" />
          Refresh
        </Button>
      </div>

      <div className="grid gap-4 md:grid-cols-4">
        {statCards.map((card) => (
          <Card key={card.label}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                {card.label}
              </CardTitle>
              <card.icon className={`h-4 w-4 ${card.color}`} />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{card.value}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <DataTable
        columns={columns}
        data={entries}
        searchKey="email"
        isLoading={isLoading}
      />
    </div>
  );
}
