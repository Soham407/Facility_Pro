"use client";

import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import {
  ASSET_STATUS_LABELS,
  ASSET_STATUS_COLORS,
  SERVICE_REQUEST_STATUS_LABELS,
  SERVICE_REQUEST_STATUS_COLORS,
  SERVICE_PRIORITY_LABELS,
  SERVICE_PRIORITY_COLORS,
  JOB_SESSION_STATUS_LABELS,
  JOB_SESSION_STATUS_COLORS,
} from "@/src/lib/constants";

interface StatusBadgeProps {
  status: string;
  className?: string;
}

export function AssetStatusBadge({ status, className }: StatusBadgeProps) {
  const label = ASSET_STATUS_LABELS[status] || status;
  const color = ASSET_STATUS_COLORS[status];

  return (
    <Badge
      className={cn(
        "font-bold text-[10px] uppercase border",
        !color && "bg-muted text-muted-foreground border-border",
        className
      )}
      style={color ? {
        backgroundColor: `${color}15`,
        color: color,
        borderColor: `${color}30`,
      } : undefined}
    >
      {label}
    </Badge>
  );
}

export function RequestStatusBadge({ status, className }: StatusBadgeProps) {
  const label = SERVICE_REQUEST_STATUS_LABELS[status] || status;
  const color = SERVICE_REQUEST_STATUS_COLORS[status];

  return (
    <Badge
      className={cn(
        "font-bold text-[10px] uppercase border",
        !color && "bg-muted text-muted-foreground border-border",
        className
      )}
      style={color ? {
        backgroundColor: `${color}15`,
        color: color,
        borderColor: `${color}30`,
      } : undefined}
    >
      {label}
    </Badge>
  );
}

export function PriorityBadge({ status, className }: StatusBadgeProps) {
  const label = SERVICE_PRIORITY_LABELS[status] || status;
  const color = SERVICE_PRIORITY_COLORS[status];

  return (
    <Badge
      className={cn(
        "font-bold text-[10px] uppercase border",
        !color && "bg-muted text-muted-foreground border-border",
        className
      )}
      style={color ? {
        backgroundColor: `${color}15`,
        color: color,
        borderColor: `${color}30`,
      } : undefined}
    >
      {label}
    </Badge>
  );
}

export function JobSessionStatusBadge({ status, className }: StatusBadgeProps) {
  const label = JOB_SESSION_STATUS_LABELS[status] || status;
  const color = JOB_SESSION_STATUS_COLORS[status];

  return (
    <Badge
      className={cn(
        "font-bold text-[10px] uppercase border",
        !color && "bg-muted text-muted-foreground border-border",
        className
      )}
      style={color ? {
        backgroundColor: `${color}15`,
        color: color,
        borderColor: `${color}30`,
      } : undefined}
    >
      {label}
    </Badge>
  );
}
