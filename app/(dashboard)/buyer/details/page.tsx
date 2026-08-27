"use client";

import { useState } from "react";
import { PageHeader } from "@/components/shared/PageHeader";
import { DataTable } from "@/components/shared/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Building2, Mail, Phone, MoreHorizontal, Pencil, Trash2, ShieldCheck, FileText } from "lucide-react";
import { ColumnDef } from "@tanstack/react-table";
import { Badge } from "@/components/ui/badge";
import { Card } from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Label } from "@/components/ui/label";
import { useToast } from "@/components/ui/use-toast";
import { useBuyerDetails, type BuyerDetail } from "@/hooks/useBuyerDetails";

interface BuyerFormData {
  buyer_code: string;
  company_name: string;
  contact_person: string;
  email: string;
  phone: string;
  billing_address: string;
  shipping_address: string;
  gst_number: string;
  pan_number: string;
  credit_period_days: number;
}

const EMPTY_FORM: BuyerFormData = {
  buyer_code: "",
  company_name: "",
  contact_person: "",
  email: "",
  phone: "",
  billing_address: "",
  shipping_address: "",
  gst_number: "",
  pan_number: "",
  credit_period_days: 30,
};

export default function BuyerDetailsPage() {
  const { toast } = useToast();
  const {
    buyers,
    isLoading,
    error,
    createBuyer,
    updateBuyer,
    deleteBuyer,
    isCreating,
    isUpdating,
    isDeleting
  } = useBuyerDetails();

  const [createDialogOpen, setCreateDialogOpen] = useState(false);
  const [editDialogOpen, setEditDialogOpen] = useState(false);
  const [confirmDialogOpen, setConfirmDialogOpen] = useState(false);
  const [selectedBuyer, setSelectedBuyer] = useState<BuyerDetail | null>(null);
  const [formData, setFormData] = useState<BuyerFormData>(EMPTY_FORM);

  const isSubmitting = isCreating || isUpdating || isDeleting;

  const validateForm = () => {
    if (!formData.company_name.trim()) {
      toast({ title: "Company name is required", variant: "destructive" });
      return false;
    }
    return true;
  };

  const resetForm = () => {
    setFormData(EMPTY_FORM);
    setSelectedBuyer(null);
  };

  const openCreateDialog = () => {
    resetForm();
    setCreateDialogOpen(true);
  };

  const openEditDialog = (buyer: BuyerDetail) => {
    setSelectedBuyer(buyer);
    setFormData({
      buyer_code: buyer.buyer_code || "",
      company_name: buyer.company_name || "",
      contact_person: buyer.contact_person || "",
      email: buyer.email || "",
      phone: buyer.phone || "",
      billing_address: buyer.billing_address || "",
      shipping_address: buyer.shipping_address || "",
      gst_number: buyer.gst_number || "",
      pan_number: buyer.pan_number || "",
      credit_period_days: buyer.credit_period_days ?? 30,
    });
    setEditDialogOpen(true);
  };

  const handleCreate = async () => {
    if (!validateForm()) return;
    const result = await createBuyer({
      buyer_code: formData.buyer_code.trim() || null,
      company_name: formData.company_name.trim(),
      contact_person: formData.contact_person.trim() || null,
      email: formData.email.trim() || null,
      phone: formData.phone.trim() || null,
      billing_address: formData.billing_address.trim() || null,
      shipping_address: formData.shipping_address.trim() || null,
      gst_number: formData.gst_number.trim() || null,
      pan_number: formData.pan_number.trim() || null,
      credit_period_days: Number(formData.credit_period_days) || 30,
    });
    
    if (result.success) {
      setCreateDialogOpen(false);
      resetForm();
    }
  };

  const handleUpdate = async () => {
    if (!selectedBuyer || !validateForm()) return;
    const result = await updateBuyer({
      id: selectedBuyer.id,
      buyer_code: formData.buyer_code.trim() || null,
      company_name: formData.company_name.trim(),
      contact_person: formData.contact_person.trim() || null,
      email: formData.email.trim() || null,
      phone: formData.phone.trim() || null,
      billing_address: formData.billing_address.trim() || null,
      shipping_address: formData.shipping_address.trim() || null,
      gst_number: formData.gst_number.trim() || null,
      pan_number: formData.pan_number.trim() || null,
      credit_period_days: Number(formData.credit_period_days) || 30,
    });

    if (result.success) {
      setEditDialogOpen(false);
      resetForm();
    }
  };

  const handleDelete = async () => {
    if (!selectedBuyer) return;
    const result = await deleteBuyer(selectedBuyer.id);
    if (result.success) {
      setConfirmDialogOpen(false);
      setSelectedBuyer(null);
    }
  };

  const columns: ColumnDef<BuyerDetail>[] = [
    {
      accessorKey: "company_name",
      header: "Company Name",
      cell: ({ row }) => (
        <div className="flex items-center gap-3">
          <div className="h-8 w-8 rounded-lg bg-primary/5 flex items-center justify-center">
            <Building2 className="h-4 w-4 text-primary" />
          </div>
          <div className="flex flex-col text-left">
            <span className="font-bold text-sm">{row.original.company_name}</span>
            <span className="text-[10px] text-muted-foreground uppercase font-bold">
              {row.original.buyer_code || "No Code"}
            </span>
          </div>
        </div>
      ),
    },
    {
      accessorKey: "contact_person",
      header: "Contact Person",
      cell: ({ row }) => (
        <div className="text-xs">
          <div className="font-medium">{row.original.contact_person || "N/A"}</div>
          <div className="text-muted-foreground">{row.original.email || "No email"}</div>
        </div>
      ),
    },
    {
      accessorKey: "phone",
      header: "Phone",
      cell: ({ row }) => <span className="text-xs">{row.original.phone || "N/A"}</span>,
    },
    {
      accessorKey: "gst_number",
      header: "GST / PAN",
      cell: ({ row }) => (
        <div className="text-xs font-mono">
          <div>GST: {row.original.gst_number || "N/A"}</div>
          <div>PAN: {row.original.pan_number || "N/A"}</div>
        </div>
      ),
    },
    {
      accessorKey: "credit_period_days",
      header: "Credit Period",
      cell: ({ row }) => <Badge variant="outline">{row.original.credit_period_days || 30} Days</Badge>,
    },
    {
      accessorKey: "is_active",
      header: "Status",
      cell: ({ row }) => (
        <Badge variant={row.original.is_active ? "default" : "secondary"}>
          {row.original.is_active ? "Active" : "Inactive"}
        </Badge>
      ),
    },
    {
      id: "actions",
      cell: ({ row }) => {
        const buyer = row.original;
        return (
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" className="h-8 w-8">
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => openEditDialog(buyer)}>
                <Pencil className="mr-2 h-4 w-4" /> Edit
              </DropdownMenuItem>
              <DropdownMenuItem
                className="text-destructive"
                onClick={() => {
                  setSelectedBuyer(buyer);
                  setConfirmDialogOpen(true);
                }}
              >
                <Trash2 className="mr-2 h-4 w-4" /> Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        );
      },
    },
  ];

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        title="Buyer Directory"
        description="Manage company profiles, billing addresses, and terms for buyer organizations."
        actions={
          <Button onClick={openCreateDialog}>
            <Plus className="mr-2 h-4 w-4" /> Add Buyer
          </Button>
        }
      />

      {error && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      <div className="grid gap-4 md:grid-cols-3">
        <Card className="p-4 flex items-center gap-4">
          <div className="p-3 bg-primary/10 rounded-lg text-primary">
            <Building2 className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Total Buyers</p>
            <h3 className="text-2xl font-bold">{buyers.length}</h3>
          </div>
        </Card>
        <Card className="p-4 flex items-center gap-4">
          <div className="p-3 bg-emerald-500/10 rounded-lg text-emerald-500">
            <ShieldCheck className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Active Buyers</p>
            <h3 className="text-2xl font-bold">{buyers.filter((b) => b.is_active).length}</h3>
          </div>
        </Card>
        <Card className="p-4 flex items-center gap-4">
          <div className="p-3 bg-blue-500/10 rounded-lg text-blue-500">
            <FileText className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Average Credit Term</p>
            <h3 className="text-2xl font-bold">
              {buyers.length > 0
                ? Math.round(
                    buyers.reduce((acc, curr) => acc + (curr.credit_period_days || 30), 0) / buyers.length
                  )
                : 30}{" "}
              Days
            </h3>
          </div>
        </Card>
      </div>

      <DataTable columns={columns} data={buyers} isLoading={isLoading} searchKey="company_name" />

      {/* Create / Edit Dialog */}
      <Dialog
        open={createDialogOpen || editDialogOpen}
        onOpenChange={(open) => {
          if (!open) {
            setCreateDialogOpen(false);
            setEditDialogOpen(false);
            resetForm();
          }
        }}
      >
        <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{editDialogOpen ? "Edit Buyer Detail" : "Create New Buyer"}</DialogTitle>
            <DialogDescription>
              {editDialogOpen
                ? "Update organization information and terms."
                : "Add a new buyer profile to your platform directory."}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="company_name">Company Name *</Label>
                <Input
                  id="company_name"
                  placeholder="Acme Corp Ltd"
                  value={formData.company_name}
                  onChange={(e) => setFormData({ ...formData, company_name: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="buyer_code">Buyer Code</Label>
                <Input
                  id="buyer_code"
                  placeholder="BUY-001"
                  value={formData.buyer_code}
                  onChange={(e) => setFormData({ ...formData, buyer_code: e.target.value })}
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="contact_person">Contact Person</Label>
                <Input
                  id="contact_person"
                  placeholder="John Doe"
                  value={formData.contact_person}
                  onChange={(e) => setFormData({ ...formData, contact_person: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="phone">Phone Number</Label>
                <Input
                  id="phone"
                  placeholder="+91 9876543210"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="email">Email Address</Label>
              <Input
                id="email"
                type="email"
                placeholder="contact@acme.com"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="gst_number">GST Number</Label>
                <Input
                  id="gst_number"
                  placeholder="27AAAAA0000A1Z5"
                  value={formData.gst_number}
                  onChange={(e) => setFormData({ ...formData, gst_number: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="pan_number">PAN Number</Label>
                <Input
                  id="pan_number"
                  placeholder="ABCDE1234F"
                  value={formData.pan_number}
                  onChange={(e) => setFormData({ ...formData, pan_number: e.target.value })}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="credit_period_days">Credit Period (Days)</Label>
              <Input
                id="credit_period_days"
                type="number"
                value={formData.credit_period_days}
                onChange={(e) => setFormData({ ...formData, credit_period_days: Number(e.target.value) })}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="billing_address">Billing Address</Label>
              <Input
                id="billing_address"
                placeholder="Street, City, State, Pincode"
                value={formData.billing_address}
                onChange={(e) => setFormData({ ...formData, billing_address: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="shipping_address">Shipping Address</Label>
              <Input
                id="shipping_address"
                placeholder="Warehouse or delivery location"
                value={formData.shipping_address}
                onChange={(e) => setFormData({ ...formData, shipping_address: e.target.value })}
              />
            </div>
          </div>

          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => {
                setCreateDialogOpen(false);
                setEditDialogOpen(false);
                resetForm();
              }}
            >
              Cancel
            </Button>
            <Button onClick={editDialogOpen ? handleUpdate : handleCreate} disabled={isSubmitting}>
              {isSubmitting ? "Saving..." : editDialogOpen ? "Save Changes" : "Create Buyer"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Confirm Delete Dialog */}
      <Dialog open={confirmDialogOpen} onOpenChange={setConfirmDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Confirm Delete</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete {selectedBuyer?.company_name}? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setConfirmDialogOpen(false)}>
              Cancel
            </Button>
            <Button variant="destructive" onClick={handleDelete} disabled={isSubmitting}>
              {isSubmitting ? "Deleting..." : "Delete"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
