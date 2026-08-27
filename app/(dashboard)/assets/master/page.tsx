"use client";

import { useState } from "react";
import { PageHeader } from "@/components/shared/PageHeader";
import { DataTable } from "@/components/shared/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Box, ShieldCheck, Wrench, MoreHorizontal, Pencil, Trash2, Tag, Calendar, DollarSign } from "lucide-react";
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
import { useAssetMaster, type AssetMasterItem } from "@/hooks/useAssetMaster";

interface AssetFormData {
  asset_code: string;
  asset_name: string;
  category: string;
  model_number: string;
  serial_number: string;
  manufacturer: string;
  installation_date: string;
  warranty_expiry: string;
  purchase_cost: number | "";
  location_description: string;
  status: string;
}

const EMPTY_FORM: AssetFormData = {
  asset_code: "",
  asset_name: "",
  category: "",
  model_number: "",
  serial_number: "",
  manufacturer: "",
  installation_date: "",
  warranty_expiry: "",
  purchase_cost: "",
  location_description: "",
  status: "operational",
};

export default function AssetMasterPage() {
  const { toast } = useToast();
  const {
    assets,
    isLoading,
    error,
    createAsset,
    updateAsset,
    deleteAsset,
    isCreating,
    isUpdating,
    isDeleting
  } = useAssetMaster();

  const [createDialogOpen, setCreateDialogOpen] = useState(false);
  const [editDialogOpen, setEditDialogOpen] = useState(false);
  const [confirmDialogOpen, setConfirmDialogOpen] = useState(false);
  const [selectedAsset, setSelectedAsset] = useState<AssetMasterItem | null>(null);
  const [formData, setFormData] = useState<AssetFormData>(EMPTY_FORM);

  const isSubmitting = isCreating || isUpdating || isDeleting;

  const validateForm = () => {
    if (!formData.asset_code.trim()) {
      toast({ title: "Asset Code is required", variant: "destructive" });
      return false;
    }
    if (!formData.asset_name.trim()) {
      toast({ title: "Asset Name is required", variant: "destructive" });
      return false;
    }
    return true;
  };

  const resetForm = () => {
    setFormData(EMPTY_FORM);
    setSelectedAsset(null);
  };

  const openCreateDialog = () => {
    resetForm();
    setCreateDialogOpen(true);
  };

  const openEditDialog = (asset: AssetMasterItem) => {
    setSelectedAsset(asset);
    setFormData({
      asset_code: asset.asset_code || "",
      asset_name: asset.asset_name || "",
      category: asset.category || "",
      model_number: asset.model_number || "",
      serial_number: asset.serial_number || "",
      manufacturer: asset.manufacturer || "",
      installation_date: asset.installation_date || "",
      warranty_expiry: asset.warranty_expiry || "",
      purchase_cost: asset.purchase_cost ?? "",
      location_description: asset.location_description || "",
      status: asset.status || "operational",
    });
    setEditDialogOpen(true);
  };

  const handleCreate = async () => {
    if (!validateForm()) return;
    const result = await createAsset({
      asset_code: formData.asset_code.trim(),
      asset_name: formData.asset_name.trim(),
      category: formData.category.trim() || null,
      model_number: formData.model_number.trim() || null,
      serial_number: formData.serial_number.trim() || null,
      manufacturer: formData.manufacturer.trim() || null,
      installation_date: formData.installation_date || null,
      warranty_expiry: formData.warranty_expiry || null,
      purchase_cost: formData.purchase_cost !== "" ? Number(formData.purchase_cost) : null,
      location_description: formData.location_description.trim() || null,
      status: formData.status || "operational",
    });
    
    if (result.success) {
      setCreateDialogOpen(false);
      resetForm();
    }
  };

  const handleUpdate = async () => {
    if (!selectedAsset || !validateForm()) return;
    const result = await updateAsset({
      id: selectedAsset.id,
      asset_code: formData.asset_code.trim(),
      asset_name: formData.asset_name.trim(),
      category: formData.category.trim() || null,
      model_number: formData.model_number.trim() || null,
      serial_number: formData.serial_number.trim() || null,
      manufacturer: formData.manufacturer.trim() || null,
      installation_date: formData.installation_date || null,
      warranty_expiry: formData.warranty_expiry || null,
      purchase_cost: formData.purchase_cost !== "" ? Number(formData.purchase_cost) : null,
      location_description: formData.location_description.trim() || null,
      status: formData.status || "operational",
    });

    if (result.success) {
      setEditDialogOpen(false);
      resetForm();
    }
  };

  const handleDelete = async () => {
    if (!selectedAsset) return;
    const result = await deleteAsset(selectedAsset.id);
    if (result.success) {
      setConfirmDialogOpen(false);
      setSelectedAsset(null);
    }
  };

  const columns: ColumnDef<AssetMasterItem>[] = [
    {
      accessorKey: "asset_name",
      header: "Asset Name & Code",
      cell: ({ row }) => (
        <div className="flex items-center gap-3">
          <div className="h-8 w-8 rounded-lg bg-primary/5 flex items-center justify-center">
            <Box className="h-4 w-4 text-primary" />
          </div>
          <div className="flex flex-col text-left">
            <span className="font-bold text-sm">{row.original.asset_name}</span>
            <span className="text-[10px] text-muted-foreground uppercase font-bold">
              {row.original.asset_code}
            </span>
          </div>
        </div>
      ),
    },
    {
      accessorKey: "category",
      header: "Category & Manufacturer",
      cell: ({ row }) => (
        <div className="text-xs">
          <div className="font-medium">{row.original.category || "General"}</div>
          <div className="text-muted-foreground">{row.original.manufacturer || "N/A"}</div>
        </div>
      ),
    },
    {
      accessorKey: "serial_number",
      header: "Model / Serial",
      cell: ({ row }) => (
        <div className="text-xs font-mono">
          <div>Model: {row.original.model_number || "N/A"}</div>
          <div>S/N: {row.original.serial_number || "N/A"}</div>
        </div>
      ),
    },
    {
      accessorKey: "purchase_cost",
      header: "Purchase Cost",
      cell: ({ row }) => (
        <span className="text-xs font-medium">
          {row.original.purchase_cost != null ? `₹${row.original.purchase_cost.toLocaleString()}` : "N/A"}
        </span>
      ),
    },
    {
      accessorKey: "status",
      header: "Status",
      cell: ({ row }) => {
        const s = row.original.status || "operational";
        return (
          <Badge
            variant={
              s === "operational" ? "default" : s === "maintenance" ? "secondary" : "destructive"
            }
          >
            {s.toUpperCase()}
          </Badge>
        );
      },
    },
    {
      id: "actions",
      cell: ({ row }) => {
        const asset = row.original;
        return (
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" className="h-8 w-8">
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => openEditDialog(asset)}>
                <Pencil className="mr-2 h-4 w-4" /> Edit
              </DropdownMenuItem>
              <DropdownMenuItem
                className="text-destructive"
                onClick={() => {
                  setSelectedAsset(asset);
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
        title="Asset Catalog"
        description="Catalog and manage physical assets, machinery, installation dates, and maintenance status."
        actions={
          <Button onClick={openCreateDialog}>
            <Plus className="mr-2 h-4 w-4" /> Add Asset
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
            <Box className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Total Assets</p>
            <h3 className="text-2xl font-bold">{assets.length}</h3>
          </div>
        </Card>
        <Card className="p-4 flex items-center gap-4">
          <div className="p-3 bg-emerald-500/10 rounded-lg text-emerald-500">
            <ShieldCheck className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Operational</p>
            <h3 className="text-2xl font-bold">
              {assets.filter((a) => a.status === "operational").length}
            </h3>
          </div>
        </Card>
        <Card className="p-4 flex items-center gap-4">
          <div className="p-3 bg-amber-500/10 rounded-lg text-amber-500">
            <Wrench className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Under Maintenance</p>
            <h3 className="text-2xl font-bold">
              {assets.filter((a) => a.status === "maintenance").length}
            </h3>
          </div>
        </Card>
      </div>

      <DataTable columns={columns} data={assets} isLoading={isLoading} searchKey="asset_name" />

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
            <DialogTitle>{editDialogOpen ? "Edit Asset Details" : "Create New Asset"}</DialogTitle>
            <DialogDescription>
              {editDialogOpen
                ? "Update asset details, status, and warranty info."
                : "Register a new asset item in your equipment catalog."}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="asset_name">Asset Name *</Label>
                <Input
                  id="asset_name"
                  placeholder="HVAC Chiller Unit A"
                  value={formData.asset_name}
                  onChange={(e) => setFormData({ ...formData, asset_name: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="asset_code">Asset Code *</Label>
                <Input
                  id="asset_code"
                  placeholder="AST-001"
                  value={formData.asset_code}
                  onChange={(e) => setFormData({ ...formData, asset_code: e.target.value })}
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="category">Category</Label>
                <Input
                  id="category"
                  placeholder="Electrical, HVAC, Plumbing"
                  value={formData.category}
                  onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="manufacturer">Manufacturer</Label>
                <Input
                  id="manufacturer"
                  placeholder="Carrier / Daikin"
                  value={formData.manufacturer}
                  onChange={(e) => setFormData({ ...formData, manufacturer: e.target.value })}
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="model_number">Model Number</Label>
                <Input
                  id="model_number"
                  placeholder="CH-5000X"
                  value={formData.model_number}
                  onChange={(e) => setFormData({ ...formData, model_number: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="serial_number">Serial Number</Label>
                <Input
                  id="serial_number"
                  placeholder="SN987654321"
                  value={formData.serial_number}
                  onChange={(e) => setFormData({ ...formData, serial_number: e.target.value })}
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="installation_date">Installation Date</Label>
                <Input
                  id="installation_date"
                  type="date"
                  value={formData.installation_date}
                  onChange={(e) => setFormData({ ...formData, installation_date: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="warranty_expiry">Warranty Expiry</Label>
                <Input
                  id="warranty_expiry"
                  type="date"
                  value={formData.warranty_expiry}
                  onChange={(e) => setFormData({ ...formData, warranty_expiry: e.target.value })}
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="purchase_cost">Purchase Cost (₹)</Label>
                <Input
                  id="purchase_cost"
                  type="number"
                  placeholder="150000"
                  value={formData.purchase_cost}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      purchase_cost: e.target.value !== "" ? Number(e.target.value) : "",
                    })
                  }
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="status">Status</Label>
                <select
                  id="status"
                  className="w-full h-10 px-3 rounded-md border border-input bg-background text-sm"
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                >
                  <option value="operational">Operational</option>
                  <option value="maintenance">Maintenance</option>
                  <option value="decommissioned">Decommissioned</option>
                </select>
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="location_description">Location Description</Label>
              <Input
                id="location_description"
                placeholder="Basement Mech Room B2, Tower 1"
                value={formData.location_description}
                onChange={(e) => setFormData({ ...formData, location_description: e.target.value })}
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
              {isSubmitting ? "Saving..." : editDialogOpen ? "Save Changes" : "Create Asset"}
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
              Are you sure you want to delete asset {selectedAsset?.asset_name}? This action cannot be undone.
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
