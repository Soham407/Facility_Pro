/**
 * Phase B TypeScript Interfaces
 * Asset Management, Service Execution, and Inventory Tracking
 */

import { Database } from './supabase';

// Helper generic types for safe schema access across database migrations
type SafeTableRow<K extends string, Fallback = Record<string, any>> = K extends keyof Database['public']['Tables']
  ? Database['public']['Tables'][K]['Row']
  : Fallback;

type SafeTableInsert<K extends string, Fallback = Record<string, any>> = K extends keyof Database['public']['Tables']
  ? Database['public']['Tables'][K]['Insert']
  : Fallback;

type SafeTableUpdate<K extends string, Fallback = Record<string, any>> = K extends keyof Database['public']['Tables']
  ? Database['public']['Tables'][K]['Update']
  : Fallback;

type SafeViewRow<K extends string, Fallback = Record<string, any>> = K extends keyof Database['public']['Views']
  ? Database['public']['Views'][K]['Row']
  : Fallback;

// ===== ENUMS =====
export type AssetStatus = Database['public']['Enums']['asset_status'];
export type ServicePriority = Database['public']['Enums']['service_priority'];
export type ServiceRequestStatus = Database['public']['Enums']['service_request_status'];
export type JobSessionStatus = Database['public']['Enums']['job_session_status'];
export type MaintenanceFrequency = Database['public']['Enums']['maintenance_frequency'];

// ===== TABLE ROW TYPES =====
export type AssetCategory = SafeTableRow<'asset_categories'>;
export type AssetCategoryInsert = SafeTableInsert<'asset_categories'>;
export type AssetCategoryUpdate = SafeTableUpdate<'asset_categories'>;

export type Asset = SafeTableRow<'assets', Database['public']['Tables']['asset_master']['Row']>;
export type AssetInsert = SafeTableInsert<'assets', Database['public']['Tables']['asset_master']['Insert']>;
export type AssetUpdate = SafeTableUpdate<'assets', Database['public']['Tables']['asset_master']['Update']>;

export type QrCode = SafeTableRow<'qr_codes'>;
export type QrCodeInsert = SafeTableInsert<'qr_codes'>;
export type QrCodeUpdate = SafeTableUpdate<'qr_codes'>;

export type QrScan = SafeTableRow<'qr_scans'>;
export type QrScanInsert = SafeTableInsert<'qr_scans'>;

export type Service = Database['public']['Tables']['services']['Row'];
export type ServiceInsert = Database['public']['Tables']['services']['Insert'];
export type ServiceUpdate = Database['public']['Tables']['services']['Update'];

export type ServiceRequest = Database['public']['Tables']['service_requests']['Row'] & {
  before_photo_url?: string | null;
  after_photo_url?: string | null;
  completion_signature_url?: string | null;
  completion_notes?: string | null;
  started_at?: string | null;
};
export type ServiceRequestInsert = Database['public']['Tables']['service_requests']['Insert'];
export type ServiceRequestUpdate = Database['public']['Tables']['service_requests']['Update'];

export type MaintenanceSchedule = SafeTableRow<'maintenance_schedules'>;
export type MaintenanceScheduleInsert = SafeTableInsert<'maintenance_schedules'>;
export type MaintenanceScheduleUpdate = SafeTableUpdate<'maintenance_schedules'>;

export type JobSession = SafeTableRow<'job_sessions'>;
export type JobSessionInsert = SafeTableInsert<'job_sessions'>;
export type JobSessionUpdate = SafeTableUpdate<'job_sessions'>;

export type JobPhoto = SafeTableRow<'job_photos'>;
export type JobPhotoInsert = SafeTableInsert<'job_photos'>;

export type Warehouse = Database['public']['Tables']['warehouses']['Row'];
export type WarehouseInsert = Database['public']['Tables']['warehouses']['Insert'];
export type WarehouseUpdate = Database['public']['Tables']['warehouses']['Update'];

export type StockBatch = Database['public']['Tables']['stock_batches']['Row'];
export type StockBatchInsert = Database['public']['Tables']['stock_batches']['Insert'];
export type StockBatchUpdate = Database['public']['Tables']['stock_batches']['Update'];

export type JobMaterialUsed = SafeTableRow<'job_materials_used'>;
export type JobMaterialUsedInsert = SafeTableInsert<'job_materials_used'>;

export type ReorderRule = SafeTableRow<'reorder_rules'>;
export type ReorderRuleInsert = SafeTableInsert<'reorder_rules'>;
export type ReorderRuleUpdate = SafeTableUpdate<'reorder_rules'>;

// ===== VIEW TYPES =====
export type AssetWithDetails = SafeViewRow<'assets_with_details'>;
export type ServiceRequestWithDetails = SafeViewRow<'service_requests_with_details'> & {
  before_photo_url?: string | null;
  after_photo_url?: string | null;
  completion_signature_url?: string | null;
  completion_notes?: string | null;
  started_at?: string | null;
};
export type DueMaintenanceSchedule = SafeViewRow<'due_maintenance_schedules'>;
export type StockLevel = Database['public']['Views']['stock_levels']['Row'];

// ===== UI-SPECIFIC INTERFACES =====

/** Asset with all joined data for display */
export interface AssetDisplay extends AssetWithDetails {
  maintenanceSchedules?: MaintenanceSchedule[];
  recentServiceRequests?: ServiceRequestWithDetails[];
}

/** Service request with job sessions for tracking */
export interface ServiceRequestDisplay extends ServiceRequestWithDetails {
  jobSessions?: JobSessionWithPhotos[];
  materialsUsed?: JobMaterialUsed[];
}

/** Job session with photos attached */
export interface JobSessionWithPhotos extends JobSession {
  photos: JobPhoto[];
  technicianName?: string;
  service_request?: ServiceRequest & {
    location?: {
      location_name: string;
    };
  };
}

/** Stock item with reorder info */
export interface StockItemDisplay extends StockLevel {
  reorderRule?: ReorderRule;
  recentBatches?: StockBatch[];
}

/** QR Code scan result */
export interface QrScanResult {
  qrId: string;
  asset?: AssetWithDetails;
  isValid: boolean;
  errorMessage?: string;
}

// ===== FORM INTERFACES =====

export interface CreateAssetForm {
  name: string;
  description?: string;
  categoryId: string;
  locationId: string;
  societyId?: string;
  serialNumber?: string;
  manufacturer?: string;
  modelNumber?: string;
  purchaseDate?: string;
  purchaseCost?: number;
  warrantyExpiry?: string;
  vendorId?: string;
  expectedLifeYears?: number;
  specifications?: Record<string, unknown>;
}

export interface CreateServiceRequestForm {
  title?: string;
  description: string;
  serviceId?: string;
  assetId?: string;
  locationId?: string;
  societyId?: string;
  priority: ServicePriority;
  scheduledDate?: string;
  scheduledTime?: string;
  requesterPhone?: string;
}

export interface StartJobSessionForm {
  serviceRequestId: string;
  technicianId: string;
  startLatitude?: number;
  startLongitude?: number;
}

export interface CompleteJobSessionForm {
  workPerformed: string;
  remarks?: string;
  endLatitude?: number;
  endLongitude?: number;
  afterPhotoUrl?: string;
}

export interface AddJobPhotoForm {
  jobSessionId: string;
  photoUrl: string;
  photoType: 'before' | 'during' | 'after';
  caption?: string;
  latitude?: number;
  longitude?: number;
}

export interface AddMaterialUsedForm {
  jobSessionId: string;
  productId: string;
  quantity: number;
  stockBatchId?: string;
  notes?: string;
}

// ===== FILTER INTERFACES =====

export interface AssetFilters {
  categoryId?: string;
  locationId?: string;
  societyId?: string;
  status?: AssetStatus;
  searchTerm?: string;
}

export interface ServiceRequestFilters {
  status?: ServiceRequestStatus | ServiceRequestStatus[];
  priority?: ServicePriority;
  assignedTo?: string;
  requesterId?: string;
  assetId?: string;
  serviceId?: string;
  locationId?: string;
  societyId?: string;
  dateFrom?: string;
  dateTo?: string;
  searchTerm?: string;
}

export interface InventoryFilters {
  warehouseId?: string;
  productId?: string;
  needsReorder?: boolean;
  searchTerm?: string;
}

export interface MaintenanceScheduleFilters {
  assetId?: string;
  locationId?: string;
  frequency?: string;
  dueSoon?: boolean;
  isActive?: boolean;
  searchTerm?: string;
}

/** Extended maintenance schedule with asset/location details from view */
export interface MaintenanceScheduleWithDetails extends DueMaintenanceSchedule {
  schedule_name?: string; // Alias for task_name
  description?: string;   // Alias for task_description
}

// ===== DASHBOARD STATS =====

export interface AssetDashboardStats {
  totalAssets: number;
  functionalAssets: number;
  underMaintenance: number;
  faultyAssets: number;
  decommissioned: number;
  upcomingMaintenance: number;
}

export interface ServiceDashboardStats {
  openRequests: number;
  inProgressRequests: number;
  completedToday: number;
  overdueRequests: number;
  avgResolutionTime: number; // in hours
  urgentRequests: number;
}

export interface InventoryDashboardStats {
  totalProducts: number;
  lowStockItems: number;
  outOfStockItems: number;
  totalWarehouses: number;
  pendingReorders: number;
}

// ===== RTV (RETURN TO VENDOR) INTERFACES =====

export type RTVTicket = Database['public']['Tables']['rtv_tickets']['Row'];
export type RTVTicketInsert = Database['public']['Tables']['rtv_tickets']['Insert'];
export type RTVTicketUpdate = Database['public']['Tables']['rtv_tickets']['Update'];

export interface RTVTicketDisplay extends RTVTicket {
  supplier?: {
    supplier_name: string;
  };
  product?: {
    product_name: string;
  };
  purchase_order?: {
    po_number: string;
  };
}

export interface RTVDashboardStats {
  pendingPickup: number;
  inTransit: number;
  creditPendingValue: number;
  monthlyReturnsCount: number;
}

