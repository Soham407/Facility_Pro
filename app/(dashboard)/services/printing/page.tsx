"use client";

import { useMemo, useState } from "react";
import { formatCurrency } from "@/src/lib/utils/currency";
import { PageHeader } from "@/components/shared/PageHeader";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  CalendarDays,
  CheckCircle2,
  LayoutGrid,
  Megaphone,
  MapPin,
  Printer,
  RefreshCw,
  ShieldCheck,
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { usePrintingMaster, type AdSpace } from "@/hooks/usePrintingMaster";
import { useAdBookings, AD_BOOKING_STATUS_CONFIG, type AdBooking } from "@/hooks/useAdBookings";
import { IDPrintingModule } from "@/components/printing/IDPrintingModule";
import { AdBookingDialog } from "@/components/dialogs/AdBookingDialog";
import { cn } from "@/lib/utils";

function formatDateLabel(value: string) {
  return new Date(value).toLocaleDateString("en-IN", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  });
}

function getAdSpaceStatusMeta(status: string) {
  const normalized = status.toLowerCase();

  switch (normalized) {
    case "available":
      return {
        label: "Available",
        className: "bg-success/10 text-success border-success/20",
        description: "Open for booking",
      };
    case "occupied":
      return {
        label: "Occupied",
        className: "bg-info/10 text-info border-info/20",
        description: "Booked or in use",
      };
    case "maintenance":
      return {
        label: "Maintenance",
        className: "bg-warning/10 text-warning border-warning/20",
        description: "Temporarily blocked",
      };
    default:
      return {
        label: status || "Unknown",
        className: "bg-muted/50 text-muted-foreground border-border",
        description: "Custom status",
      };
  }
}

function summarizeBookings(bookings: AdBooking[]) {
  return {
    total: bookings.length,
    pending: bookings.filter((booking) => booking.status === "pending").length,
    active: bookings.filter((booking) => booking.status === "active").length,
    approved: bookings.filter((booking) => booking.status === "approved").length,
    revenue: bookings.reduce((sum, booking) => sum + booking.agreed_rate_paise, 0),
  };
}

function summarizeSpaces(adSpaces: AdSpace[]) {
  return {
    total: adSpaces.length,
    available: adSpaces.filter((space) => space.status.toLowerCase() === "available").length,
    occupied: adSpaces.filter((space) => space.status.toLowerCase() === "occupied").length,
    maintenance: adSpaces.filter((space) => space.status.toLowerCase() === "maintenance").length,
  };
}

export default function PrintingAdvertisingPage() {
  const { userId, role } = useAuth();
  const {
    adSpaces,
    isLoading: spacesLoading,
    error: spacesError,
    refresh: refreshAdSpaces,
    updateAdSpaceStatus,
  } = usePrintingMaster();
  const {
    bookings,
    isLoading: bookingsLoading,
    refresh: refreshBookings,
    approveBooking,
    cancelBooking,
  } = useAdBookings();

  const [selectedSpace, setSelectedSpace] = useState<AdSpace | null>(null);
  const [updatingSpaceId, setUpdatingSpaceId] = useState<string | null>(null);
  const [updatingBookingId, setUpdatingBookingId] = useState<string | null>(null);

  const canApproveBookings = role === "admin" || role === "super_admin";

  const bookingStats = useMemo(() => summarizeBookings(bookings), [bookings]);
  const spaceStats = useMemo(() => summarizeSpaces(adSpaces), [adSpaces]);
  const bookingsBySpace = useMemo(() => {
    return bookings.reduce<Record<string, number>>((acc, booking) => {
      acc[booking.ad_space_id] = (acc[booking.ad_space_id] || 0) + 1;
      return acc;
    }, {});
  }, [bookings]);

  const adSpaceById = useMemo(() => {
    return new Map(adSpaces.map((space) => [space.id, space]));
  }, [adSpaces]);

  const isLoading = spacesLoading || bookingsLoading;

  const refreshAll = async () => {
    await Promise.all([refreshAdSpaces(), refreshBookings()]);
  };

  const handleSpaceStatusChange = async (spaceId: string, status: AdSpace["status"]) => {
    setUpdatingSpaceId(spaceId);
    try {
      await updateAdSpaceStatus(spaceId, status);
    } finally {
      setUpdatingSpaceId(null);
    }
  };

  const handleApprove = async (bookingId: string) => {
    if (!userId) return;
    setUpdatingBookingId(bookingId);
    try {
      await approveBooking(bookingId, userId);
      await refreshAll();
    } finally {
      setUpdatingBookingId(null);
    }
  };

  const handleCancel = async (bookingId: string) => {
    setUpdatingBookingId(bookingId);
    try {
      await cancelBooking(bookingId);
      await refreshAll();
    } finally {
      setUpdatingBookingId(null);
    }
  };

  return (
    <div className="animate-fade-in space-y-8 pb-10">
      <PageHeader
        title="Printing & Advertising"
        description="Generate ID cards and visitor passes, then manage physical ad-space inventory and bookings."
        actions={
          <Button variant="outline" className="gap-2" onClick={refreshAll} disabled={isLoading}>
            <RefreshCw className={cn("h-4 w-4", isLoading && "animate-spin")} />
            Refresh
          </Button>
        }
      />

      {spacesError && (
        <div className="rounded-xl border border-critical/20 bg-critical/10 p-4 text-sm font-medium text-critical">
          {spacesError}
        </div>
      )}

      <div className="grid gap-4 md:grid-cols-4">
        <Card className="border-none shadow-card ring-1 ring-border p-4">
          <div className="flex items-center gap-4">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 text-primary">
              <LayoutGrid className="h-5 w-5" />
            </div>
            <div className="flex flex-col">
              <span className="text-2xl font-bold">{spaceStats.total}</span>
              <span className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Ad Spaces
              </span>
            </div>
          </div>
        </Card>
        <Card className="border-none shadow-card ring-1 ring-border p-4">
          <div className="flex items-center gap-4">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-success/10 text-success">
              <CheckCircle2 className="h-5 w-5" />
            </div>
            <div className="flex flex-col">
              <span className="text-2xl font-bold">{spaceStats.available}</span>
              <span className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Available
              </span>
            </div>
          </div>
        </Card>
        <Card className="border-none shadow-card ring-1 ring-border p-4">
          <div className="flex items-center gap-4">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-warning/10 text-warning">
              <Megaphone className="h-5 w-5" />
            </div>
            <div className="flex flex-col">
              <span className="text-2xl font-bold">{bookingStats.pending}</span>
              <span className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Pending Bookings
              </span>
            </div>
          </div>
        </Card>
        <Card className="border-none shadow-card ring-1 ring-border p-4">
          <div className="flex items-center gap-4">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-info/10 text-info">
              <ShieldCheck className="h-5 w-5" />
            </div>
            <div className="flex flex-col">
              <span className="text-2xl font-bold">{formatCurrency(bookingStats.revenue)}</span>
              <span className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Booking Value
              </span>
            </div>
          </div>
        </Card>
      </div>

      <Tabs defaultValue="printing" className="w-full">
        <TabsList className="bg-transparent border-b rounded-none w-full justify-start h-auto p-0 gap-8">
          <TabsTrigger
            value="printing"
            className="px-0 py-3 rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none font-bold text-xs uppercase tracking-widest"
          >
            ID Printing
          </TabsTrigger>
          <TabsTrigger
            value="ad-spaces"
            className="px-0 py-3 rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none font-bold text-xs uppercase tracking-widest"
          >
            Ad Spaces
          </TabsTrigger>
          <TabsTrigger
            value="bookings"
            className="px-0 py-3 rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none font-bold text-xs uppercase tracking-widest"
          >
            Bookings
          </TabsTrigger>
        </TabsList>

        <TabsContent value="printing" className="pt-6">
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
        </TabsContent>

        <TabsContent value="ad-spaces" className="pt-6">
          <div className="grid gap-4 lg:grid-cols-2">
            {spacesLoading ? (
              <Card className="col-span-full border-dashed">
                <CardContent className="flex items-center justify-center p-10 text-sm text-muted-foreground">
                  Loading ad spaces...
                </CardContent>
              </Card>
            ) : adSpaces.length > 0 ? (
              adSpaces.map((space) => {
                const statusMeta = getAdSpaceStatusMeta(space.status);
                const bookingCount = bookingsBySpace[space.id] || 0;

                return (
                  <Card key={space.id} className="border-none shadow-card ring-1 ring-border">
                    <CardHeader className="space-y-4">
                      <div className="flex items-start justify-between gap-4">
                        <div>
                          <CardTitle className="text-base">{space.space_name}</CardTitle>
                          <CardDescription className="mt-1 flex items-center gap-2">
                            <MapPin className="h-3.5 w-3.5" />
                            {space.location_description || "Location not specified"}
                          </CardDescription>
                        </div>
                        <Badge variant="outline" className={statusMeta.className}>
                          {statusMeta.label}
                        </Badge>
                      </div>
                      <div className="grid gap-3 sm:grid-cols-3">
                        <div className="rounded-xl bg-muted/30 p-3">
                          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                            Dimensions
                          </p>
                          <p className="mt-1 text-sm font-semibold">{space.dimensions || "Not set"}</p>
                        </div>
                        <div className="rounded-xl bg-muted/30 p-3">
                          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                            Base Rate
                          </p>
                          <p className="mt-1 text-sm font-semibold">{formatCurrency(space.base_rate_paise)}</p>
                        </div>
                        <div className="rounded-xl bg-muted/30 p-3">
                          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                            Bookings
                          </p>
                          <p className="mt-1 text-sm font-semibold">{bookingCount}</p>
                        </div>
                      </div>
                    </CardHeader>
                    <CardContent className="flex flex-wrap gap-2 pb-6">
                      <Button
                        className="gap-2"
                        onClick={() => setSelectedSpace(space)}
                      >
                        Book Space
                      </Button>
                      <Button
                        variant="outline"
                        className="gap-2"
                        onClick={() => handleSpaceStatusChange(space.id, "available")}
                        disabled={updatingSpaceId === space.id}
                      >
                        Set Available
                      </Button>
                      <Button
                        variant="outline"
                        className="gap-2"
                        onClick={() => handleSpaceStatusChange(space.id, "occupied")}
                        disabled={updatingSpaceId === space.id}
                      >
                        Set Occupied
                      </Button>
                      <Button
                        variant="outline"
                        className="gap-2"
                        onClick={() => handleSpaceStatusChange(space.id, "maintenance")}
                        disabled={updatingSpaceId === space.id}
                      >
                        Maintenance
                      </Button>
                    </CardContent>
                  </Card>
                );
              })
            ) : (
              <Card className="col-span-full border-dashed">
                <CardContent className="space-y-2 p-10 text-center">
                  <LayoutGrid className="mx-auto h-10 w-10 text-muted-foreground/40" />
                  <p className="font-semibold">No ad spaces found.</p>
                  <p className="text-sm text-muted-foreground">
                    Add rows to `printing_ad_spaces` to enable ad booking.
                  </p>
                </CardContent>
              </Card>
            )}
          </div>
        </TabsContent>

        <TabsContent value="bookings" className="pt-6">
          <Card className="border-none shadow-card ring-1 ring-border">
            <CardHeader className="border-b bg-muted/10">
              <CardTitle className="flex items-center gap-2 text-sm uppercase tracking-widest">
                <CalendarDays className="h-4 w-4" />
                Booking Register
              </CardTitle>
              <CardDescription>
                Track ad-space requests, approvals, active placements, and cancellations.
              </CardDescription>
            </CardHeader>
            <CardContent className="p-0">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Booking</TableHead>
                    <TableHead>Space</TableHead>
                    <TableHead>Client</TableHead>
                    <TableHead>Period</TableHead>
                    <TableHead>Rate</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {bookingsLoading ? (
                    <TableRow>
                      <TableCell colSpan={7} className="py-10 text-center text-muted-foreground">
                        Loading bookings...
                      </TableCell>
                    </TableRow>
                  ) : bookings.length > 0 ? (
                    bookings.map((booking) => {
                      const adSpace = adSpaceById.get(booking.ad_space_id);
                      const statusMeta = AD_BOOKING_STATUS_CONFIG[booking.status];

                      return (
                        <TableRow key={booking.id}>
                          <TableCell className="font-mono text-xs font-bold">
                            {booking.booking_number}
                          </TableCell>
                          <TableCell>
                            <div className="flex flex-col">
                              <span className="font-medium">{adSpace?.space_name || "Unknown space"}</span>
                              <span className="text-xs text-muted-foreground">
                                {adSpace?.dimensions || "No dimensions"}
                              </span>
                            </div>
                          </TableCell>
                          <TableCell>{booking.advertiser_name}</TableCell>
                          <TableCell className="text-sm text-muted-foreground">
                            {formatDateLabel(booking.start_date)} to {formatDateLabel(booking.end_date)}
                          </TableCell>
                          <TableCell className="font-semibold">
                            {formatCurrency(booking.agreed_rate_paise)}
                          </TableCell>
                          <TableCell>
                            <Badge variant="outline" className={statusMeta.className}>
                              {statusMeta.label}
                            </Badge>
                          </TableCell>
                          <TableCell className="text-right">
                            <div className="flex items-center justify-end gap-2">
                              {canApproveBookings && booking.status === "pending" && (
                                <Button
                                  size="sm"
                                  onClick={() => handleApprove(booking.id)}
                                  disabled={updatingBookingId === booking.id || !userId}
                                >
                                  Approve
                                </Button>
                              )}
                              {booking.status !== "cancelled" && booking.status !== "completed" && (
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={() => handleCancel(booking.id)}
                                  disabled={updatingBookingId === booking.id}
                                >
                                  Cancel
                                </Button>
                              )}
                            </div>
                          </TableCell>
                        </TableRow>
                      );
                    })
                  ) : (
                    <TableRow>
                      <TableCell colSpan={7} className="py-10 text-center text-muted-foreground">
                        No bookings found.
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      <AdBookingDialog
        open={Boolean(selectedSpace)}
        onOpenChange={(open) => {
          if (!open) setSelectedSpace(null);
        }}
        adSpaceId={selectedSpace?.id || ""}
        adSpaceName={selectedSpace?.space_name || "Ad space"}
        onSuccess={refreshAll}
      />
    </div>
  );
}
