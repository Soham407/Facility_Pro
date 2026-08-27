"use client";

import { useState, useEffect } from "react";
import {
  Package,
  MapPin,
  Calendar,
  DollarSign,
  Building,
  User,
  Save,
  X,
  Loader2,
  AlertTriangle,
} from "lucide-react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useAssets } from "@/hooks/useAssets";
import { useAssetCategories } from "@/hooks/useAssetCategories";
import type { AssetWithDetails, CreateAssetForm, AssetStatus } from "@/src/types/operations";
import { ASSET_STATUS, ASSET_STATUS_LABELS } from "@/src/lib/constants";
import { useCompanyLocations } from "@/hooks/useCompanyLocations";
import { useSocieties } from "@/hooks/useSocieties";
import { useSuppliers } from "@/hooks/useSuppliers";
// removed supabase client since we use hooks now
import { toast } from "sonner";
import { InlineLoader } from "@/components/ui/async-boundary";

interface AssetFormProps {
  asset?: AssetWithDetails | null;
  onSuccess?: () => void;
  onCancel?: () => void;
}


export function AssetForm({ asset, onSuccess, onCancel }: AssetFormProps) {
  const { createAsset, updateAsset } = useAssets();
  const { categories, isLoading: isCategoriesLoading } = useAssetCategories();

  const [isSubmitting, setIsSubmitting] = useState(false);
  const { locations, isLoading: isLoadingLocations, error: locError } = useCompanyLocations();
  const { societies, isLoading: isLoadingSocieties, error: socError } = useSocieties();
  const { suppliers, isLoading: isLoadingSuppliers, error: supError } = useSuppliers();

  const isLoadingReferenceData = isLoadingLocations || isLoadingSocieties || isLoadingSuppliers;
  const referenceDataError = [locError, socError, supError].filter(Boolean).length > 0 
    ? "Failed to load reference data" 
    : null;

  // Form state
  const [formData, setFormData] = useState<CreateAssetForm>({
    name: asset?.name || "",
    description: asset?.description || "",
    categoryId: asset?.category_id || "",
    locationId: asset?.location_id || "",
    societyId: asset?.society_id || "",
    serialNumber: asset?.serial_number || "",
    manufacturer: asset?.manufacturer || "",
    modelNumber: asset?.model_number || "",
    purchaseDate: asset?.purchase_date?.split("T")[0] || "",
    purchaseCost: asset?.purchase_cost || undefined,
    warrantyExpiry: asset?.warranty_expiry?.split("T")[0] || "",
    vendorId: asset?.vendor_id || "",
    expectedLifeYears: asset?.expected_life_years || undefined,
  });

  const [status, setStatus] = useState<AssetStatus>(asset?.status || "functional");


  // Handle submit
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

try {
      if (asset) {
        // Update existing asset
        if (!asset.id) {
          toast.error("Invalid asset ID");
          setIsSubmitting(false);
          return;
        }
        const result = await updateAsset(asset.id, {
          // @ts-ignore
          name: formData.name,
          description: formData.description || null,
          category_id: formData.categoryId,
          location_id: formData.locationId,
          society_id: formData.societyId || null,
          serial_number: formData.serialNumber || null,
          manufacturer: formData.manufacturer || null,
          model_number: formData.modelNumber || null,
          purchase_date: formData.purchaseDate || null,
          purchase_cost: formData.purchaseCost || null,
          warranty_expiry: formData.warrantyExpiry || null,
          vendor_id: formData.vendorId || null,
          expected_life_years: formData.expectedLifeYears || null,
          status: status as typeof ASSET_STATUS[keyof typeof ASSET_STATUS],
        });

        if (result.success) {
          toast.success("Asset updated successfully");
          onSuccess?.();
        } else {
          toast.error(result.error || "Failed to update asset");
        }
      } else {
        // Create new asset
        const result = await createAsset({
          // @ts-ignore
          name: formData.name,
          description: formData.description || null,
          category_id: formData.categoryId,
          location_id: formData.locationId,
          society_id: formData.societyId || null,
          serial_number: formData.serialNumber || null,
          manufacturer: formData.manufacturer || null,
          model_number: formData.modelNumber || null,
          purchase_date: formData.purchaseDate || null,
          purchase_cost: formData.purchaseCost || null,
          warranty_expiry: formData.warrantyExpiry || null,
          vendor_id: formData.vendorId || null,
          expected_life_years: formData.expectedLifeYears || null,
          asset_code: "", // Will be generated by trigger
        });

        if (result.success) {
          toast.success("Asset created successfully");
          onSuccess?.();
        } else {
          toast.error(result.error || "Failed to create asset");
        }
      }
    } catch (err) {
      console.error("Form submission error:", err);
      const errorMessage = err instanceof Error ? err.message : "An unexpected error occurred";
      toast.error(`Submission failed: ${errorMessage}`);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Card className="border-none shadow-card ring-1 ring-border">
      <CardHeader className="pb-3 border-b">
        <div className="flex items-center justify-between">
          <CardTitle className="text-sm font-bold uppercase flex items-center gap-2">
            <Package className="h-4 w-4 text-primary" />
            {asset ? "Edit Asset" : "New Asset"}
          </CardTitle>
          {onCancel && (
            <Button variant="ghost" size="icon" onClick={onCancel}>
              <X className="h-4 w-4" />
            </Button>
          )}
        </div>
      </CardHeader>
<CardContent className="p-6">
        {/* Reference Data Error Banner */}
        {referenceDataError && (
          <div className="flex items-center gap-2 p-4 rounded-lg bg-destructive/10 text-destructive mb-6">
            <AlertTriangle className="h-4 w-4 shrink-0" />
            <p className="text-sm">{referenceDataError}</p>
          </div>
        )}
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Basic Info */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="md:col-span-2">
              <Label htmlFor="name">Asset Name *</Label>
              <Input
                id="name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="e.g., Main Lobby AC Unit"
                required
              />
            </div>

<div>
              <Label htmlFor="category">Category *</Label>
              <Select
                value={formData.categoryId}
                onValueChange={(val) => setFormData({ ...formData, categoryId: val })}
                required
                disabled={isCategoriesLoading}
              >
                <SelectTrigger>
                  {isCategoriesLoading ? (
                    <InlineLoader />
                  ) : (
                    <SelectValue placeholder="Select category" />
                  )}
                </SelectTrigger>
                <SelectContent>
                  {categories.map((cat) => (
                    <SelectItem key={cat.id} value={cat.id}>
                      {cat.category_name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div>
              <Label htmlFor="location">Location *</Label>
              <Select
                value={formData.locationId}
                onValueChange={(val) => setFormData({ ...formData, locationId: val })}
                required
                disabled={isLoadingReferenceData}
              >
                <SelectTrigger>
                  {isLoadingReferenceData ? (
                    <InlineLoader />
                  ) : (
                    <SelectValue placeholder="Select location" />
                  )}
                </SelectTrigger>
                <SelectContent>
                  {locations.map((loc) => (
                    <SelectItem key={loc.id} value={loc.id}>
                      {loc.location_name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div>
              <Label htmlFor="society">Society (Optional)</Label>
              <Select
                value={formData.societyId || "__none__"}
                onValueChange={(val) => setFormData({ ...formData, societyId: val === "__none__" ? undefined : val })}
                disabled={isLoadingReferenceData}
              >
                <SelectTrigger>
                  {isLoadingReferenceData ? (
                    <InlineLoader />
                  ) : (
                    <SelectValue placeholder="Select society" />
                  )}
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="__none__">None</SelectItem>
                  {societies.map((soc) => (
                    <SelectItem key={soc.id} value={soc.id}>
                      {soc.society_name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {asset && (
              <div>
                <Label htmlFor="status">Status</Label>
                <Select value={status} onValueChange={(val) => setStatus(val as AssetStatus)}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {Object.entries(ASSET_STATUS_LABELS).map(([key, label]) => (
                      <SelectItem key={key} value={key}>
                        {label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
          </div>

          {/* Description */}
          <div>
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              placeholder="Asset description and notes..."
              rows={3}
            />
          </div>

          {/* Technical Details */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <Label htmlFor="serialNumber">Serial Number</Label>
              <Input
                id="serialNumber"
                value={formData.serialNumber}
                onChange={(e) => setFormData({ ...formData, serialNumber: e.target.value })}
                placeholder="S/N"
              />
            </div>
            <div>
              <Label htmlFor="manufacturer">Manufacturer</Label>
              <Input
                id="manufacturer"
                value={formData.manufacturer}
                onChange={(e) => setFormData({ ...formData, manufacturer: e.target.value })}
                placeholder="Brand/Manufacturer"
              />
            </div>
            <div>
              <Label htmlFor="modelNumber">Model Number</Label>
              <Input
                id="modelNumber"
                value={formData.modelNumber}
                onChange={(e) => setFormData({ ...formData, modelNumber: e.target.value })}
                placeholder="Model"
              />
            </div>
          </div>

          {/* Purchase Info */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <Label htmlFor="purchaseDate">Purchase Date</Label>
              <Input
                id="purchaseDate"
                type="date"
                value={formData.purchaseDate}
                onChange={(e) => setFormData({ ...formData, purchaseDate: e.target.value })}
              />
            </div>
            <div>
              <Label htmlFor="purchaseCost">Purchase Cost (₹)</Label>
              <Input
                id="purchaseCost"
                type="number"
                value={formData.purchaseCost || ""}
                onChange={(e) => setFormData({ ...formData, purchaseCost: parseFloat(e.target.value) || undefined })}
                placeholder="0.00"
              />
            </div>
            <div>
              <Label htmlFor="warrantyExpiry">Warranty Expiry</Label>
              <Input
                id="warrantyExpiry"
                type="date"
                value={formData.warrantyExpiry}
                onChange={(e) => setFormData({ ...formData, warrantyExpiry: e.target.value })}
              />
            </div>
            <div>
              <Label htmlFor="expectedLife">Expected Life (Years)</Label>
              <Input
                id="expectedLife"
                type="number"
                value={formData.expectedLifeYears || ""}
                onChange={(e) => setFormData({ ...formData, expectedLifeYears: parseInt(e.target.value) || undefined })}
                placeholder="5"
              />
            </div>
          </div>

{/* Vendor */}
          <div>
            <Label htmlFor="vendor">Vendor/Supplier</Label>
            <Select
              value={formData.vendorId || "__none__"}
              onValueChange={(val) => setFormData({ ...formData, vendorId: val === "__none__" ? undefined : val })}
              disabled={isLoadingReferenceData}
            >
              <SelectTrigger>
                {isLoadingReferenceData ? (
                  <InlineLoader />
                ) : (
                  <SelectValue placeholder="Select vendor" />
                )}
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">None</SelectItem>
                {suppliers.map((sup) => (
                  <SelectItem key={sup.id} value={sup.id}>
                    {sup.supplier_name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Actions */}
          <div className="flex justify-end gap-3 pt-4 border-t">
            {onCancel && (
              <Button type="button" variant="outline" onClick={onCancel}>
                Cancel
              </Button>
            )}
            <Button type="submit" disabled={isSubmitting} className="gap-2">
              {isSubmitting ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Save className="h-4 w-4" />
              )}
              {asset ? "Update Asset" : "Create Asset"}
            </Button>
          </div>
        </form>
      </CardContent>
    </Card>
  );
}
