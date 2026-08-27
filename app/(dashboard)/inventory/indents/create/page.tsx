"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import { useProducts } from "@/hooks/useProducts";
import { useIndents, type CreateIndentInput } from "@/hooks/useIndents";
import { usePurchaseOrders, type CreatePOInput } from "@/hooks/usePurchaseOrders";
import { PageHeader } from "@/components/shared/PageHeader";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { Loader2 } from "lucide-react";
import { useSuppliers } from "@/hooks/useSuppliers";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
// @ts-ignore
import { useAuth } from "@/hooks/useAuth";
import { useEmployees } from "@/hooks/useEmployees";
import { useCompanyLocations } from "@/hooks/useCompanyLocations";

export default function CreateIndentPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const productId = searchParams.get("productId");

  const { user } = useAuth();
  const { employees } = useEmployees();
  const { products, isLoading: productsLoading } = useProducts();
  const { suppliers, isLoading: suppliersLoading } = useSuppliers();
  const { locations, isLoading: locationsLoading } = useCompanyLocations();
  const { createIndent, isLoading: isCreatingIndent } = useIndents();
  const { createPurchaseOrder, isLoading: isCreatingPO } = usePurchaseOrders();

  const [selectedProduct, setSelectedProduct] = useState<any>(null);
  const [quantity, setQuantity] = useState<number>(1);
  const [selectedSupplier, setSelectedSupplier] = useState<string>("");
  const [notes, setNotes] = useState<string>("");
  const [purpose, setPurpose] = useState<string>("");
  const [requiredDate, setRequiredDate] = useState<string>("");
  const [title, setTitle] = useState<string>("");
  const [selectedLocation, setSelectedLocation] = useState<string>("");

  useEffect(() => {
    if (productId && products.length > 0) {
      const product = products.find((p) => p.id === productId);
      if (product) {
        setSelectedProduct(product);
        setTitle(`Reorder: ${product.product_name}`);
        setPurpose(`Reorder for low stock of ${product.product_name}`);
      } else {
        toast.error("Product not found.");
        router.push("/inventory");
      }
    } else if (!productId) {
      toast.error("No product specified for indent creation.");
      router.push("/inventory");
    }
  }, [productId, products, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!selectedProduct || !quantity || !selectedSupplier || !requiredDate || !title || !selectedLocation) {
      toast.error("Please fill all required fields.");
      return;
    }

    const requester = employees.find(emp => emp.auth_user_id === user?.id);
    if (!requester) {
      toast.error("Requester employee not found. Cannot create indent.");
      return;
    }

    const newIndent: CreateIndentInput = {
      title,
      purpose,
      requester_id: requester.id,
      supplier_id: selectedSupplier,
      location_id: selectedLocation,
      required_date: requiredDate,
      priority: "normal",
      department: "Inventory",
    };

    const createdIndent = await createIndent(newIndent);

    if (createdIndent) {
      toast.success("Indent created successfully!");

      // Automatically create a draft PO
      const newPO: CreatePOInput = {
        indent_id: createdIndent.id,
        supplier_id: selectedSupplier,
        po_date: new Date().toISOString().split("T")[0],
        expected_delivery_date: requiredDate,
        payment_terms: "Net 30",
        notes: `Auto-generated from inventory reorder alert for ${selectedProduct.product_name}`,
      };

      const createdPO = await createPurchaseOrder(newPO);

      if (createdPO) {
        toast.success("Draft Purchase Order created and linked!");
        router.push("/inventory/purchase-orders"); // Redirect to PO list
      } else {
        toast.error("Failed to create Purchase Order. Please create it manually.");
        router.push("/inventory/requests"); // Redirect to the implemented request review list.
      }
    } else {
      toast.error("Failed to create indent.");
    }
  };

  if (productsLoading || suppliersLoading || locationsLoading || isCreatingIndent || isCreatingPO) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen">
        <Loader2 className="h-10 w-10 animate-spin text-primary" />
        <p className="mt-4 text-lg text-muted-foreground">Loading...</p>
      </div>
    );
  }

  return (
    <div className="flex-1 space-y-6 p-8">
      <PageHeader
        title="Create Indent from Alert"
        description="Generate a new indent and linked purchase order for a low-stock item."
      />

      <div className="max-w-2xl mx-auto bg-white p-8 rounded-lg shadow-md">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <Label htmlFor="productName">Product</Label>
            <Input
              id="productName"
              value={selectedProduct?.product_name || ""}
              readOnly
              className="mt-1"
            />
          </div>

          <div>
            <Label htmlFor="quantity">Requested Quantity</Label>
            <Input
              id="quantity"
              type="number"
              value={quantity}
              onChange={(e) => setQuantity(Number(e.target.value))}
              min="1"
              className="mt-1"
            />
          </div>

          <div>
            <Label htmlFor="supplier">Supplier</Label>
            <Select value={selectedSupplier} onValueChange={setSelectedSupplier}>
              <SelectTrigger id="supplier" className="mt-1">
                <SelectValue placeholder="Select a supplier" />
              </SelectTrigger>
              <SelectContent>
                {suppliers.map((supplier) => (
                  <SelectItem key={supplier.id} value={supplier.id}>
                    {supplier.supplier_name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div>
            <Label htmlFor="location">Location</Label>
            <Select value={selectedLocation} onValueChange={setSelectedLocation}>
              <SelectTrigger id="location" className="mt-1">
                <SelectValue placeholder="Select a location" />
              </SelectTrigger>
              <SelectContent>
                {locations.map((location) => (
                  <SelectItem key={location.id} value={location.id}>
                    {location.location_name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div>
            <Label htmlFor="title">Indent Title</Label>
            <Input
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="mt-1"
            />
          </div>

          <div>
            <Label htmlFor="purpose">Purpose</Label>
            <Textarea
              id="purpose"
              value={purpose}
              onChange={(e) => setPurpose(e.target.value)}
              className="mt-1"
            />
          </div>

          <div>
            <Label htmlFor="requiredDate">Required By Date</Label>
            <Input
              id="requiredDate"
              type="date"
              value={requiredDate}
              onChange={(e) => setRequiredDate(e.target.value)}
              className="mt-1"
            />
          </div>

          <Button type="submit" className="w-full" disabled={isCreatingIndent || isCreatingPO}>
            {(isCreatingIndent || isCreatingPO) && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Create Indent & PO
          </Button>
        </form>
      </div>
    </div>
  );
}
