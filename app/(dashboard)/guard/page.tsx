"use client";

import { useState, useEffect } from "react";
import { usePanicAlert } from "@/hooks/usePanicAlert";
import { useEmployeeProfile } from "@/hooks/useEmployeeProfile";
import { useAttendance } from "@/hooks/useAttendance";
import { useVisitors } from "@/hooks/useVisitors";
import { VisitorRegistrationDialog } from "@/components/society/VisitorRegistrationDialog";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  ShieldCheck,
  UserCheck,
  Search,
  Loader2,
  Home,
  Calendar,
  AlertTriangle,
  ClipboardList,
  Phone,
  UserPlus,
  ChevronRight,
  MapPin,
  Clock3,
  DoorOpen,
  LogIn,
  LogOut,
} from "lucide-react";
import Link from "next/link";
import { cn } from "@/lib/utils";

export default function GuardStationPage() {
  const [isRegistrationOpen, setIsRegistrationOpen] = useState(false);
  const [isCheckingOutVisitorId, setIsCheckingOutVisitorId] = useState<string | null>(null);
  const { isTriggering, isHolding, holdProgress, startHold, endHold, cancelHold, triggerPanic } = usePanicAlert();
  const {
    activeVisitors,
    checkOutVisitor,
    isLoading: isVisitorsLoading,
  } = useVisitors({ status: "active" });
  const {
    employeeId,
    guardId,
    isLoading: isProfileLoading,
    error: profileError,
  } = useEmployeeProfile();
  const {
    isWithinRange,
    distance,
    isLoading: isAttendanceLoading,
    error: attendanceError,
    currentPosition,
    gateLocation,
    isClockedIn,
    todayAttendance,
  } = useAttendance(employeeId ?? undefined, guardId);

  const hasCompletedShiftToday =
    !isClockedIn &&
    !!todayAttendance?.check_in_time &&
    !!todayAttendance?.check_out_time;
  const shiftStatus = isClockedIn
    ? "On Duty"
    : hasCompletedShiftToday
      ? "Shift Completed"
      : "Off Duty";
  const gateVisitors = activeVisitors.filter((visitor) => {
    if (!visitor.entry_time) {
      return false;
    }

    if (!gateLocation?.id) {
      return true;
    }

    return visitor.entry_location_id === gateLocation.id;
  });

  const formatShiftTime = (value?: string | null) =>
    value
      ? new Date(value).toLocaleTimeString("en-IN", {
          hour: "2-digit",
          minute: "2-digit",
          hour12: true,
        })
      : "--";

  return (
    <div className="p-4 max-w-2xl mx-auto space-y-6 pb-24">
      {/* Header */}
      <div className="flex items-center justify-between pb-2 border-b">
        <div>
          <h1 className="text-xl font-black text-foreground flex items-center gap-2">
            <ShieldCheck className="h-5 w-5 text-primary" />
            Guard Station
          </h1>
          <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-[0.2em]">
            Security Command • Visitor Control
          </p>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3">
        {/* SOS Panic Button */}
        <button
          className={cn(
            "relative col-span-2 flex items-center justify-center gap-3 rounded-2xl p-5 font-black text-white text-lg uppercase tracking-widest transition-all select-none",
            isHolding
              ? "bg-red-700 scale-95 shadow-inner"
              : "bg-critical shadow-lg shadow-critical/40 active:scale-95",
          )}
          onMouseDown={startHold}
          onMouseUp={() => { if (endHold()) triggerPanic({}); }}
          onMouseLeave={cancelHold}
          onTouchStart={startHold}
          onTouchEnd={() => { if (endHold()) triggerPanic({}); }}
          disabled={isTriggering}
        >
          {isTriggering ? (
            <Loader2 className="h-6 w-6 animate-spin" />
          ) : (
            <AlertTriangle className="h-6 w-6" />
          )}
          <span>
            {isTriggering
              ? "Sending Alert..."
              : isHolding
              ? `Hold... ${Math.round(holdProgress)}%`
              : "SOS — Hold 3s to Trigger"}
          </span>
          {isHolding && (
            <div
              className="absolute bottom-0 left-0 h-1 bg-white/60 rounded-b-2xl transition-all duration-100"
              style={{ width: `${holdProgress}%` }}
            />
          )}
        </button>

        {/* Checklist */}
        <Link href="/society/checklists" className="block">
          <Card className="border-none shadow-card ring-1 ring-border hover:shadow-md transition-all h-full">
            <CardContent className="p-4 flex items-center gap-3">
              <div className="h-10 w-10 rounded-xl bg-info/10 flex items-center justify-center">
                <ClipboardList className="h-5 w-5 text-info" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-bold truncate">Daily Checklist</p>
                <p className="text-[10px] text-muted-foreground font-medium uppercase tracking-wide">
                  Facility Rounds
                </p>
              </div>
              <ChevronRight className="h-4 w-4 text-muted-foreground flex-shrink-0" />
            </CardContent>
          </Card>
        </Link>

        {/* Emergency Contacts */}
        <Link href="/society/emergency" className="block">
          <Card className="border-none shadow-card ring-1 ring-border hover:shadow-md transition-all h-full">
            <CardContent className="p-4 flex items-center gap-3">
              <div className="h-10 w-10 rounded-xl bg-warning/10 flex items-center justify-center">
                <Phone className="h-5 w-5 text-warning" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-bold truncate">Emergency</p>
                <p className="text-[10px] text-muted-foreground font-medium uppercase tracking-wide">
                  Quick Dial
                </p>
              </div>
              <ChevronRight className="h-4 w-4 text-muted-foreground flex-shrink-0" />
            </CardContent>
          </Card>
        </Link>
      </div>

      <Card className="border-none shadow-card ring-1 ring-border overflow-hidden">
        <CardHeader className="border-b bg-muted/5">
          <CardTitle className="text-sm font-black uppercase tracking-widest flex items-center gap-2">
            <Clock3 className="h-4 w-4 text-primary" />
            Shift Console
          </CardTitle>
          <CardDescription>
            Live attendance status for this guard account. Clock-in, clock-out, selfie capture, and GPS enforcement run in the full shift console.
          </CardDescription>
        </CardHeader>
        <CardContent className="p-4 space-y-4">
          {isProfileLoading || isAttendanceLoading ? (
            <div className="flex items-center justify-center py-6">
              <Loader2 className="h-5 w-5 animate-spin text-primary" />
            </div>
          ) : profileError ? (
            <div className="rounded-xl border border-destructive/20 bg-destructive/5 p-3 text-sm font-medium text-destructive">
              {profileError}
            </div>
          ) : (
            <>
              <div className="grid grid-cols-2 gap-3">
                <div className="rounded-xl border bg-muted/20 p-3">
                  <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Shift Status
                  </p>
                  <div className="mt-2 flex items-center gap-2">
                    <Badge
                      variant="outline"
                      className={cn(
                        "text-[10px] font-bold uppercase",
                        isClockedIn
                          ? "border-success/20 bg-success/10 text-success"
                          : hasCompletedShiftToday
                            ? "border-primary/20 bg-primary/10 text-primary"
                            : "border-muted-foreground/20"
                      )}
                    >
                      {shiftStatus}
                    </Badge>
                  </div>
                </div>
                <div className="rounded-xl border bg-muted/20 p-3">
                  <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Geo-Fence
                  </p>
                  <div className="mt-2 flex items-start gap-2">
                    <MapPin className="mt-0.5 h-4 w-4 text-primary" />
                    <div className="space-y-1">
                      <p className="text-sm font-bold">
                        {!currentPosition
                          ? "Waiting for GPS"
                          : isWithinRange
                            ? `Within Range (${distance ?? 0}m)`
                            : `Outside Range (${distance ?? "?"}m)`}
                      </p>
                      <p className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
                        {gateLocation?.location_name || "Main gate not configured"}
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="rounded-xl border bg-muted/20 p-3">
                  <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Check In
                  </p>
                  <p className="mt-2 text-sm font-bold">
                    {formatShiftTime(todayAttendance?.check_in_time)}
                  </p>
                </div>
                <div className="rounded-xl border bg-muted/20 p-3">
                  <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Check Out
                  </p>
                  <p className="mt-2 text-sm font-bold">
                    {formatShiftTime(todayAttendance?.check_out_time)}
                  </p>
                </div>
              </div>

              {(attendanceError || (!currentPosition && employeeId)) && (
                <div className="rounded-xl border border-warning/20 bg-warning/5 p-3 text-sm font-medium text-warning">
                  {attendanceError || "Clock-in requires a live GPS fix before the attendance console will accept the shift start."}
                </div>
              )}

              <Link href="/dashboard" className="block">
                <Button className="w-full gap-2 font-bold uppercase tracking-widest text-xs">
                  {isClockedIn ? (
                    <LogOut className="h-4 w-4" />
                  ) : (
                    <LogIn className="h-4 w-4" />
                  )}
                  {isClockedIn
                    ? "Open Shift Console to Clock Out"
                    : hasCompletedShiftToday
                      ? "Open Shift Console"
                      : "Open Shift Console to Clock In"}
                </Button>
              </Link>
            </>
          )}
        </CardContent>
      </Card>

      {/* Visitor Entry */}
      <div className="space-y-3">
        <h2 className="text-xs font-black uppercase tracking-widest text-muted-foreground">
          Visitor Entry
        </h2>
          <Button
            className="w-full gap-2 font-bold uppercase tracking-widest text-sm h-12 shadow-glow"
            onClick={() => setIsRegistrationOpen(true)}
        >
          <UserPlus className="h-5 w-5" />
          Register New Visitor
        </Button>
      </div>

      <Card className="border-none shadow-card ring-1 ring-border overflow-hidden">
        <CardHeader className="border-b bg-muted/5">
          <CardTitle className="text-sm font-black uppercase tracking-widest flex items-center gap-2">
            <DoorOpen className="h-4 w-4 text-primary" />
            Active Visitors
          </CardTitle>
          <CardDescription>
            Record departures from the guard station without leaving the gate console.
          </CardDescription>
        </CardHeader>
        <CardContent className="p-4">
          {isVisitorsLoading ? (
            <div className="flex items-center justify-center py-6">
              <Loader2 className="h-5 w-5 animate-spin text-primary" />
            </div>
          ) : gateVisitors.length === 0 ? (
            <div className="rounded-xl border border-dashed bg-muted/20 p-4 text-center">
              <p className="text-sm font-semibold">No active visitors at this gate</p>
              <p className="mt-1 text-xs text-muted-foreground">
                Checked-in visitors will appear here until exit is logged.
              </p>
            </div>
          ) : (
            <div className="space-y-3">
              {gateVisitors.slice(0, 5).map((visitor) => (
                <div
                  key={visitor.id}
                  className="flex items-center gap-3 rounded-xl border bg-muted/20 p-3"
                >
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2">
                      <p className="truncate text-sm font-bold">{visitor.visitor_name}</p>
                      <Badge
                        variant="outline"
                        className="border-success/20 bg-success/10 text-[10px] font-bold uppercase text-success"
                      >
                        Inside
                      </Badge>
                    </div>
                    <p className="mt-1 text-xs font-medium text-muted-foreground">
                      {visitor.flat?.building?.building_name || "Building not set"} - {visitor.flat?.flat_number || "Flat not set"}
                    </p>
                    <p className="mt-1 text-[11px] text-muted-foreground">
                      Entered at {formatShiftTime(visitor.entry_time)}
                    </p>
                  </div>
                  <Button
                    size="sm"
                    variant="outline"
                    className="gap-2 font-bold uppercase tracking-wide"
                    disabled={isCheckingOutVisitorId === visitor.id}
                    onClick={async () => {
                      setIsCheckingOutVisitorId(visitor.id);
                      try {
                        await checkOutVisitor(visitor.id);
                      } finally {
                        setIsCheckingOutVisitorId(null);
                      }
                    }}
                    aria-label={`Log Exit for ${visitor.visitor_name}`}
                  >
                    {isCheckingOutVisitorId === visitor.id ? (
                      <Loader2 className="h-4 w-4 animate-spin" />
                    ) : (
                      <LogOut className="h-4 w-4" />
                    )}
                    Log Exit
                  </Button>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>


      <VisitorRegistrationDialog
        open={isRegistrationOpen}
        onOpenChange={setIsRegistrationOpen}
      />
    </div>
  );
}
