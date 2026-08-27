export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      asset_master: {
        Row: {
          asset_code: string
          asset_name: string
          buyer_id: string | null
          category: string | null
          created_at: string
          id: string
          installation_date: string | null
          is_active: boolean
          location_description: string | null
          manufacturer: string | null
          model_number: string | null
          purchase_cost: number | null
          serial_number: string | null
          site_id: string | null
          status: string | null
          unit_branch_id: string | null
          updated_at: string
          warranty_expiry: string | null
        }
        Insert: {
          asset_code: string
          asset_name: string
          buyer_id?: string | null
          category?: string | null
          created_at?: string
          id?: string
          installation_date?: string | null
          is_active?: boolean
          location_description?: string | null
          manufacturer?: string | null
          model_number?: string | null
          purchase_cost?: number | null
          serial_number?: string | null
          site_id?: string | null
          status?: string | null
          unit_branch_id?: string | null
          updated_at?: string
          warranty_expiry?: string | null
        }
        Update: {
          asset_code?: string
          asset_name?: string
          buyer_id?: string | null
          category?: string | null
          created_at?: string
          id?: string
          installation_date?: string | null
          is_active?: boolean
          location_description?: string | null
          manufacturer?: string | null
          model_number?: string | null
          purchase_cost?: number | null
          serial_number?: string | null
          site_id?: string | null
          status?: string | null
          unit_branch_id?: string | null
          updated_at?: string
          warranty_expiry?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "asset_master_buyer_id_fkey"
            columns: ["buyer_id"]
            isOneToOne: false
            referencedRelation: "buyer_details"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "asset_master_site_id_fkey"
            columns: ["site_id"]
            isOneToOne: false
            referencedRelation: "site_details"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "asset_master_unit_branch_id_fkey"
            columns: ["unit_branch_id"]
            isOneToOne: false
            referencedRelation: "unit_branch_details"
            referencedColumns: ["id"]
          },
        ]
      }
      attendance_logs: {
        Row: {
          check_in_latitude: number | null
          check_in_location_id: string | null
          check_in_longitude: number | null
          check_in_selfie_url: string | null
          check_in_time: string | null
          check_out_latitude: number | null
          check_out_location_id: string | null
          check_out_longitude: number | null
          check_out_time: string | null
          created_at: string | null
          employee_id: string
          id: string
          is_auto_punch_out: boolean | null
          log_date: string
          notes: string | null
          overtime_hours: number | null
          status: string | null
          total_hours: number | null
          updated_at: string | null
        }
        Insert: {
          check_in_latitude?: number | null
          check_in_location_id?: string | null
          check_in_longitude?: number | null
          check_in_selfie_url?: string | null
          check_in_time?: string | null
          check_out_latitude?: number | null
          check_out_location_id?: string | null
          check_out_longitude?: number | null
          check_out_time?: string | null
          created_at?: string | null
          employee_id: string
          id?: string
          is_auto_punch_out?: boolean | null
          log_date: string
          notes?: string | null
          overtime_hours?: number | null
          status?: string | null
          total_hours?: number | null
          updated_at?: string | null
        }
        Update: {
          check_in_latitude?: number | null
          check_in_location_id?: string | null
          check_in_longitude?: number | null
          check_in_selfie_url?: string | null
          check_in_time?: string | null
          check_out_latitude?: number | null
          check_out_location_id?: string | null
          check_out_longitude?: number | null
          check_out_time?: string | null
          created_at?: string | null
          employee_id?: string
          id?: string
          is_auto_punch_out?: boolean | null
          log_date?: string
          notes?: string | null
          overtime_hours?: number | null
          status?: string | null
          total_hours?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "attendance_logs_check_in_location_id_fkey"
            columns: ["check_in_location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attendance_logs_check_out_location_id_fkey"
            columns: ["check_out_location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attendance_logs_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      buildings: {
        Row: {
          building_code: string
          building_name: string
          created_at: string | null
          id: string
          is_active: boolean | null
          society_id: string
          total_flats: number | null
          total_floors: number | null
        }
        Insert: {
          building_code: string
          building_name: string
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          society_id: string
          total_flats?: number | null
          total_floors?: number | null
        }
        Update: {
          building_code?: string
          building_name?: string
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          society_id?: string
          total_flats?: number | null
          total_floors?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "buildings_society_id_fkey"
            columns: ["society_id"]
            isOneToOne: false
            referencedRelation: "societies"
            referencedColumns: ["id"]
          },
        ]
      }
      buyer_details: {
        Row: {
          billing_address: string | null
          buyer_code: string | null
          company_name: string
          contact_person: string | null
          created_at: string
          credit_period_days: number | null
          email: string | null
          gst_number: string | null
          id: string
          is_active: boolean
          pan_number: string | null
          phone: string | null
          shipping_address: string | null
          updated_at: string
          user_id: string | null
        }
        Insert: {
          billing_address?: string | null
          buyer_code?: string | null
          company_name: string
          contact_person?: string | null
          created_at?: string
          credit_period_days?: number | null
          email?: string | null
          gst_number?: string | null
          id?: string
          is_active?: boolean
          pan_number?: string | null
          phone?: string | null
          shipping_address?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          billing_address?: string | null
          buyer_code?: string | null
          company_name?: string
          contact_person?: string | null
          created_at?: string
          credit_period_days?: number | null
          email?: string | null
          gst_number?: string | null
          id?: string
          is_active?: boolean
          pan_number?: string | null
          phone?: string | null
          shipping_address?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "buyer_details_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      checklist_responses: {
        Row: {
          checklist_id: string
          created_at: string | null
          employee_id: string
          id: string
          is_complete: boolean | null
          latitude: number | null
          location_id: string | null
          longitude: number | null
          overridden_at: string | null
          overridden_by: string | null
          override_reason: string | null
          override_status: string
          response_date: string
          responses: Json
          submitted_at: string | null
        }
        Insert: {
          checklist_id: string
          created_at?: string | null
          employee_id: string
          id?: string
          is_complete?: boolean | null
          latitude?: number | null
          location_id?: string | null
          longitude?: number | null
          overridden_at?: string | null
          overridden_by?: string | null
          override_reason?: string | null
          override_status?: string
          response_date: string
          responses: Json
          submitted_at?: string | null
        }
        Update: {
          checklist_id?: string
          created_at?: string | null
          employee_id?: string
          id?: string
          is_complete?: boolean | null
          latitude?: number | null
          location_id?: string | null
          longitude?: number | null
          overridden_at?: string | null
          overridden_by?: string | null
          override_reason?: string | null
          override_status?: string
          response_date?: string
          responses?: Json
          submitted_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "checklist_responses_checklist_id_fkey"
            columns: ["checklist_id"]
            isOneToOne: false
            referencedRelation: "daily_checklists"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "checklist_responses_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "checklist_responses_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
        ]
      }
      company_locations: {
        Row: {
          address: string | null
          created_at: string | null
          created_by: string | null
          geo_fence_radius: number | null
          id: string
          is_active: boolean | null
          latitude: number | null
          location_code: string
          location_name: string
          location_type: string | null
          longitude: number | null
          society_id: string | null
          updated_at: string | null
        }
        Insert: {
          address?: string | null
          created_at?: string | null
          created_by?: string | null
          geo_fence_radius?: number | null
          id?: string
          is_active?: boolean | null
          latitude?: number | null
          location_code: string
          location_name: string
          location_type?: string | null
          longitude?: number | null
          society_id?: string | null
          updated_at?: string | null
        }
        Update: {
          address?: string | null
          created_at?: string | null
          created_by?: string | null
          geo_fence_radius?: number | null
          id?: string
          is_active?: boolean | null
          latitude?: number | null
          location_code?: string
          location_name?: string
          location_type?: string | null
          longitude?: number | null
          society_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_locations_society_id_fkey"
            columns: ["society_id"]
            isOneToOne: false
            referencedRelation: "societies"
            referencedColumns: ["id"]
          },
        ]
      }
      complaint_request_nature_master: {
        Row: {
          category_name: string | null
          created_at: string
          description: string | null
          id: string
          is_active: boolean
          nature_code: string | null
          nature_name: string
          priority_default: string | null
          sla_resolution_hours: number | null
          updated_at: string
        }
        Insert: {
          category_name?: string | null
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          nature_code?: string | null
          nature_name: string
          priority_default?: string | null
          sla_resolution_hours?: number | null
          updated_at?: string
        }
        Update: {
          category_name?: string | null
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          nature_code?: string | null
          nature_name?: string
          priority_default?: string | null
          sla_resolution_hours?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      daily_checklists: {
        Row: {
          checklist_code: string
          checklist_name: string
          created_at: string | null
          created_by: string | null
          department: string
          description: string | null
          frequency: string | null
          id: string
          is_active: boolean | null
          questions: Json
          updated_at: string | null
        }
        Insert: {
          checklist_code: string
          checklist_name: string
          created_at?: string | null
          created_by?: string | null
          department: string
          description?: string | null
          frequency?: string | null
          id?: string
          is_active?: boolean | null
          questions: Json
          updated_at?: string | null
        }
        Update: {
          checklist_code?: string
          checklist_name?: string
          created_at?: string | null
          created_by?: string | null
          department?: string
          description?: string | null
          frequency?: string | null
          id?: string
          is_active?: boolean | null
          questions?: Json
          updated_at?: string | null
        }
        Relationships: []
      }
      designations: {
        Row: {
          created_at: string | null
          created_by: string | null
          department: string | null
          description: string | null
          designation_code: string
          designation_name: string
          id: string
          is_active: boolean | null
          level: string | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          department?: string | null
          description?: string | null
          designation_code: string
          designation_name: string
          id?: string
          is_active?: boolean | null
          level?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          department?: string | null
          description?: string | null
          designation_code?: string
          designation_name?: string
          id?: string
          is_active?: boolean | null
          level?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      employee_behavior_tickets: {
        Row: {
          category: Database["public"]["Enums"]["behavior_category"]
          created_at: string | null
          description: string | null
          employee_id: string
          evidence_urls: Json | null
          id: string
          reported_by: string | null
          resolution: string | null
          severity: string
          status: string | null
          ticket_number: string | null
        }
        Insert: {
          category: Database["public"]["Enums"]["behavior_category"]
          created_at?: string | null
          description?: string | null
          employee_id: string
          evidence_urls?: Json | null
          id?: string
          reported_by?: string | null
          resolution?: string | null
          severity: string
          status?: string | null
          ticket_number?: string | null
        }
        Update: {
          category?: Database["public"]["Enums"]["behavior_category"]
          created_at?: string | null
          description?: string | null
          employee_id?: string
          evidence_urls?: Json | null
          id?: string
          reported_by?: string | null
          resolution?: string | null
          severity?: string
          status?: string | null
          ticket_number?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "employee_behavior_tickets_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "employee_behavior_tickets_reported_by_fkey"
            columns: ["reported_by"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      employee_documents: {
        Row: {
          created_at: string | null
          created_by: string | null
          document_code: string | null
          document_name: string
          document_number: string | null
          document_type: Database["public"]["Enums"]["document_type"]
          employee_id: string
          expiry_date: string | null
          expiry_notified_at: string | null
          file_name: string
          file_path: string
          file_size: number | null
          id: string
          issue_date: string | null
          mime_type: string | null
          notes: string | null
          rejection_reason: string | null
          status: Database["public"]["Enums"]["document_status"]
          updated_at: string | null
          updated_by: string | null
          verified_at: string | null
          verified_by: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          document_code?: string | null
          document_name: string
          document_number?: string | null
          document_type: Database["public"]["Enums"]["document_type"]
          employee_id: string
          expiry_date?: string | null
          expiry_notified_at?: string | null
          file_name: string
          file_path: string
          file_size?: number | null
          id?: string
          issue_date?: string | null
          mime_type?: string | null
          notes?: string | null
          rejection_reason?: string | null
          status?: Database["public"]["Enums"]["document_status"]
          updated_at?: string | null
          updated_by?: string | null
          verified_at?: string | null
          verified_by?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          document_code?: string | null
          document_name?: string
          document_number?: string | null
          document_type?: Database["public"]["Enums"]["document_type"]
          employee_id?: string
          expiry_date?: string | null
          expiry_notified_at?: string | null
          file_name?: string
          file_path?: string
          file_size?: number | null
          id?: string
          issue_date?: string | null
          mime_type?: string | null
          notes?: string | null
          rejection_reason?: string | null
          status?: Database["public"]["Enums"]["document_status"]
          updated_at?: string | null
          updated_by?: string | null
          verified_at?: string | null
          verified_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "employee_documents_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      employee_shift_assignments: {
        Row: {
          assigned_by: string | null
          created_at: string | null
          effective_from: string
          effective_to: string | null
          employee_id: string
          id: string
          is_active: boolean | null
          shift_id: string
        }
        Insert: {
          assigned_by?: string | null
          created_at?: string | null
          effective_from?: string
          effective_to?: string | null
          employee_id: string
          id?: string
          is_active?: boolean | null
          shift_id: string
        }
        Update: {
          assigned_by?: string | null
          created_at?: string | null
          effective_from?: string
          effective_to?: string | null
          employee_id?: string
          id?: string
          is_active?: boolean | null
          shift_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "employee_shift_assignments_assigned_by_fkey"
            columns: ["assigned_by"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "employee_shift_assignments_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "employee_shift_assignments_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "shifts"
            referencedColumns: ["id"]
          },
        ]
      }
      employees: {
        Row: {
          address: string | null
          auth_user_id: string | null
          city: string | null
          created_at: string | null
          created_by: string | null
          date_of_birth: string | null
          date_of_joining: string
          department: string | null
          designation_id: string | null
          email: string | null
          emergency_contact_name: string | null
          emergency_contact_phone: string | null
          employee_code: string
          first_name: string
          id: string
          is_active: boolean | null
          last_name: string
          phone: string | null
          photo_url: string | null
          pincode: string | null
          reporting_to: string | null
          state: string | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          address?: string | null
          auth_user_id?: string | null
          city?: string | null
          created_at?: string | null
          created_by?: string | null
          date_of_birth?: string | null
          date_of_joining: string
          department?: string | null
          designation_id?: string | null
          email?: string | null
          emergency_contact_name?: string | null
          emergency_contact_phone?: string | null
          employee_code: string
          first_name: string
          id?: string
          is_active?: boolean | null
          last_name: string
          phone?: string | null
          photo_url?: string | null
          pincode?: string | null
          reporting_to?: string | null
          state?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          address?: string | null
          auth_user_id?: string | null
          city?: string | null
          created_at?: string | null
          created_by?: string | null
          date_of_birth?: string | null
          date_of_joining?: string
          department?: string | null
          designation_id?: string | null
          email?: string | null
          emergency_contact_name?: string | null
          emergency_contact_phone?: string | null
          employee_code?: string
          first_name?: string
          id?: string
          is_active?: boolean | null
          last_name?: string
          phone?: string | null
          photo_url?: string | null
          pincode?: string | null
          reporting_to?: string | null
          state?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "employees_designation_id_fkey"
            columns: ["designation_id"]
            isOneToOne: false
            referencedRelation: "designations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "employees_reporting_to_fkey"
            columns: ["reporting_to"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      flats: {
        Row: {
          area_sqft: number | null
          building_id: string
          created_at: string | null
          flat_number: string
          flat_type: string | null
          floor_number: number | null
          id: string
          is_active: boolean | null
          is_occupied: boolean | null
          ownership_type: string | null
        }
        Insert: {
          area_sqft?: number | null
          building_id: string
          created_at?: string | null
          flat_number: string
          flat_type?: string | null
          floor_number?: number | null
          id?: string
          is_active?: boolean | null
          is_occupied?: boolean | null
          ownership_type?: string | null
        }
        Update: {
          area_sqft?: number | null
          building_id?: string
          created_at?: string | null
          flat_number?: string
          flat_type?: string | null
          floor_number?: number | null
          id?: string
          is_active?: boolean | null
          is_occupied?: boolean | null
          ownership_type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "flats_building_id_fkey"
            columns: ["building_id"]
            isOneToOne: false
            referencedRelation: "buildings"
            referencedColumns: ["id"]
          },
        ]
      }
      gps_tracking: {
        Row: {
          accuracy_meters: number | null
          battery_level: number | null
          employee_id: string
          heading_degrees: number | null
          id: string
          is_mock_location: boolean | null
          latitude: number
          longitude: number
          speed_kmh: number | null
          tracked_at: string
        }
        Insert: {
          accuracy_meters?: number | null
          battery_level?: number | null
          employee_id: string
          heading_degrees?: number | null
          id?: string
          is_mock_location?: boolean | null
          latitude: number
          longitude: number
          speed_kmh?: number | null
          tracked_at?: string
        }
        Update: {
          accuracy_meters?: number | null
          battery_level?: number | null
          employee_id?: string
          heading_degrees?: number | null
          id?: string
          is_mock_location?: boolean | null
          latitude?: number
          longitude?: number
          speed_kmh?: number | null
          tracked_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "gps_tracking_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "security_guards"
            referencedColumns: ["id"]
          },
        ]
      }
      guard_patrol_logs: {
        Row: {
          anomalies_found: string | null
          checkpoints_verified: number | null
          created_at: string | null
          guard_id: string
          id: string
          patrol_end_time: string | null
          patrol_route: Json | null
          patrol_start_time: string
          photos: Json | null
          total_checkpoints: number | null
        }
        Insert: {
          anomalies_found?: string | null
          checkpoints_verified?: number | null
          created_at?: string | null
          guard_id: string
          id?: string
          patrol_end_time?: string | null
          patrol_route?: Json | null
          patrol_start_time: string
          photos?: Json | null
          total_checkpoints?: number | null
        }
        Update: {
          anomalies_found?: string | null
          checkpoints_verified?: number | null
          created_at?: string | null
          guard_id?: string
          id?: string
          patrol_end_time?: string | null
          patrol_route?: Json | null
          patrol_start_time?: string
          photos?: Json | null
          total_checkpoints?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "guard_patrol_logs_guard_id_fkey"
            columns: ["guard_id"]
            isOneToOne: false
            referencedRelation: "security_guards"
            referencedColumns: ["id"]
          },
        ]
      }
      holidays: {
        Row: {
          created_at: string | null
          created_by: string | null
          description: string | null
          holiday_date: string
          holiday_name: string
          holiday_type: string | null
          id: string
          is_active: boolean | null
          payroll_impact: string | null
          updated_at: string | null
          year: number
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          holiday_date: string
          holiday_name: string
          holiday_type?: string | null
          id?: string
          is_active?: boolean | null
          payroll_impact?: string | null
          updated_at?: string | null
          year: number
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          holiday_date?: string
          holiday_name?: string
          holiday_type?: string | null
          id?: string
          is_active?: boolean | null
          payroll_impact?: string | null
          updated_at?: string | null
          year?: number
        }
        Relationships: []
      }
      indent_items: {
        Row: {
          approved_quantity: number | null
          created_at: string | null
          estimated_total: number | null
          estimated_unit_price: number | null
          id: string
          indent_id: string
          item_description: string | null
          notes: string | null
          override_approved_at: string | null
          override_approved_by: string | null
          override_reason: string | null
          product_id: string | null
          requested_quantity: number
          specifications: string | null
          unit_of_measure: string | null
          updated_at: string | null
        }
        Insert: {
          approved_quantity?: number | null
          created_at?: string | null
          estimated_total?: number | null
          estimated_unit_price?: number | null
          id?: string
          indent_id: string
          item_description?: string | null
          notes?: string | null
          override_approved_at?: string | null
          override_approved_by?: string | null
          override_reason?: string | null
          product_id?: string | null
          requested_quantity: number
          specifications?: string | null
          unit_of_measure?: string | null
          updated_at?: string | null
        }
        Update: {
          approved_quantity?: number | null
          created_at?: string | null
          estimated_total?: number | null
          estimated_unit_price?: number | null
          id?: string
          indent_id?: string
          item_description?: string | null
          notes?: string | null
          override_approved_at?: string | null
          override_approved_by?: string | null
          override_reason?: string | null
          product_id?: string | null
          requested_quantity?: number
          specifications?: string | null
          unit_of_measure?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "indent_items_indent_id_fkey"
            columns: ["indent_id"]
            isOneToOne: false
            referencedRelation: "indents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indent_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indent_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
        ]
      }
      indents: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          approver_notes: string | null
          created_at: string | null
          created_by: string | null
          department: string | null
          id: string
          indent_number: string | null
          linked_po_id: string | null
          location_id: string | null
          notes: string | null
          po_created_at: string | null
          priority: string | null
          purpose: string | null
          rejected_at: string | null
          rejected_by: string | null
          rejection_reason: string | null
          requester_id: string
          required_date: string | null
          service_request_id: string | null
          society_id: string | null
          status: Database["public"]["Enums"]["indent_status"]
          submitted_at: string | null
          submitted_by: string | null
          supplier_id: string | null
          title: string | null
          total_estimated_value: number | null
          total_items: number | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          approver_notes?: string | null
          created_at?: string | null
          created_by?: string | null
          department?: string | null
          id?: string
          indent_number?: string | null
          linked_po_id?: string | null
          location_id?: string | null
          notes?: string | null
          po_created_at?: string | null
          priority?: string | null
          purpose?: string | null
          rejected_at?: string | null
          rejected_by?: string | null
          rejection_reason?: string | null
          requester_id: string
          required_date?: string | null
          service_request_id?: string | null
          society_id?: string | null
          status?: Database["public"]["Enums"]["indent_status"]
          submitted_at?: string | null
          submitted_by?: string | null
          supplier_id?: string | null
          title?: string | null
          total_estimated_value?: number | null
          total_items?: number | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          approver_notes?: string | null
          created_at?: string | null
          created_by?: string | null
          department?: string | null
          id?: string
          indent_number?: string | null
          linked_po_id?: string | null
          location_id?: string | null
          notes?: string | null
          po_created_at?: string | null
          priority?: string | null
          purpose?: string | null
          rejected_at?: string | null
          rejected_by?: string | null
          rejection_reason?: string | null
          requester_id?: string
          required_date?: string | null
          service_request_id?: string | null
          society_id?: string | null
          status?: Database["public"]["Enums"]["indent_status"]
          submitted_at?: string | null
          submitted_by?: string | null
          supplier_id?: string | null
          title?: string | null
          total_estimated_value?: number | null
          total_items?: number | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "indents_linked_po_fk"
            columns: ["linked_po_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indents_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indents_requester_id_fkey"
            columns: ["requester_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indents_service_request_id_fkey"
            columns: ["service_request_id"]
            isOneToOne: false
            referencedRelation: "requests"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indents_society_id_fkey"
            columns: ["society_id"]
            isOneToOne: false
            referencedRelation: "societies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "indents_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      inventory: {
        Row: {
          created_at: string | null
          id: string
          last_stock_date: string | null
          location_id: string | null
          max_stock_level: number | null
          product_id: string
          quantity_on_hand: number
          reorder_level: number | null
          reserved_quantity: number | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          last_stock_date?: string | null
          location_id?: string | null
          max_stock_level?: number | null
          product_id: string
          quantity_on_hand?: number
          reorder_level?: number | null
          reserved_quantity?: number | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          last_stock_date?: string | null
          location_id?: string | null
          max_stock_level?: number | null
          product_id?: string
          quantity_on_hand?: number
          reorder_level?: number | null
          reserved_quantity?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inventory_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inventory_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
        ]
      }
      leave_applications: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          created_at: string | null
          employee_id: string
          from_date: string
          id: string
          leave_type_id: string
          number_of_days: number
          reason: string
          rejection_reason: string | null
          status: string | null
          to_date: string
          updated_at: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          created_at?: string | null
          employee_id: string
          from_date: string
          id?: string
          leave_type_id: string
          number_of_days: number
          reason: string
          rejection_reason?: string | null
          status?: string | null
          to_date: string
          updated_at?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          created_at?: string | null
          employee_id?: string
          from_date?: string
          id?: string
          leave_type_id?: string
          number_of_days?: number
          reason?: string
          rejection_reason?: string | null
          status?: string | null
          to_date?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "leave_applications_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "leave_applications_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "leave_applications_leave_type_id_fkey"
            columns: ["leave_type_id"]
            isOneToOne: false
            referencedRelation: "leave_types"
            referencedColumns: ["id"]
          },
        ]
      }
      leave_types: {
        Row: {
          can_carry_forward: boolean | null
          created_at: string | null
          description: string | null
          id: string
          is_active: boolean | null
          leave_name: string
          leave_type: Database["public"]["Enums"]["leave_type_enum"]
          max_carry_forward: number | null
          requires_approval: boolean | null
          updated_at: string | null
          yearly_quota: number
        }
        Insert: {
          can_carry_forward?: boolean | null
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          leave_name: string
          leave_type: Database["public"]["Enums"]["leave_type_enum"]
          max_carry_forward?: number | null
          requires_approval?: boolean | null
          updated_at?: string | null
          yearly_quota: number
        }
        Update: {
          can_carry_forward?: boolean | null
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          leave_name?: string
          leave_type?: Database["public"]["Enums"]["leave_type_enum"]
          max_carry_forward?: number | null
          requires_approval?: boolean | null
          updated_at?: string | null
          yearly_quota?: number
        }
        Relationships: []
      }
      material_receipts: {
        Row: {
          created_at: string | null
          created_by: string | null
          delivery_challan_number: string | null
          grn_number: string | null
          id: string
          notes: string | null
          purchase_order_id: string | null
          quality_checked_at: string | null
          quality_checked_by: string | null
          received_by: string | null
          received_date: string
          status: Database["public"]["Enums"]["grn_status"]
          supplier_id: string | null
          total_received_value: number | null
          updated_at: string | null
          updated_by: string | null
          vehicle_number: string | null
          warehouse_id: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          delivery_challan_number?: string | null
          grn_number?: string | null
          id?: string
          notes?: string | null
          purchase_order_id?: string | null
          quality_checked_at?: string | null
          quality_checked_by?: string | null
          received_by?: string | null
          received_date?: string
          status?: Database["public"]["Enums"]["grn_status"]
          supplier_id?: string | null
          total_received_value?: number | null
          updated_at?: string | null
          updated_by?: string | null
          vehicle_number?: string | null
          warehouse_id?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          delivery_challan_number?: string | null
          grn_number?: string | null
          id?: string
          notes?: string | null
          purchase_order_id?: string | null
          quality_checked_at?: string | null
          quality_checked_by?: string | null
          received_by?: string | null
          received_date?: string
          status?: Database["public"]["Enums"]["grn_status"]
          supplier_id?: string | null
          total_received_value?: number | null
          updated_at?: string | null
          updated_by?: string | null
          vehicle_number?: string | null
          warehouse_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "material_receipts_purchase_order_id_fkey"
            columns: ["purchase_order_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "material_receipts_quality_checked_by_fkey"
            columns: ["quality_checked_by"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "material_receipts_received_by_fkey"
            columns: ["received_by"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "material_receipts_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "material_receipts_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["warehouse_id"]
          },
          {
            foreignKeyName: "material_receipts_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "warehouses"
            referencedColumns: ["id"]
          },
        ]
      }
      panic_alerts: {
        Row: {
          acknowledged_at: string | null
          acknowledged_by: string | null
          acknowledged_notes: string | null
          alert_time: string | null
          alert_type: Database["public"]["Enums"]["alert_type"]
          created_at: string | null
          description: string | null
          guard_id: string
          id: string
          is_resolved: boolean | null
          latitude: number | null
          location_id: string | null
          longitude: number | null
          metadata: Json
          photo_url: string | null
          resolution_notes: string | null
          resolved_at: string | null
          resolved_by: string | null
          streaming_active: boolean
        }
        Insert: {
          acknowledged_at?: string | null
          acknowledged_by?: string | null
          acknowledged_notes?: string | null
          alert_time?: string | null
          alert_type: Database["public"]["Enums"]["alert_type"]
          created_at?: string | null
          description?: string | null
          guard_id: string
          id?: string
          is_resolved?: boolean | null
          latitude?: number | null
          location_id?: string | null
          longitude?: number | null
          metadata?: Json
          photo_url?: string | null
          resolution_notes?: string | null
          resolved_at?: string | null
          resolved_by?: string | null
          streaming_active?: boolean
        }
        Update: {
          acknowledged_at?: string | null
          acknowledged_by?: string | null
          acknowledged_notes?: string | null
          alert_time?: string | null
          alert_type?: Database["public"]["Enums"]["alert_type"]
          created_at?: string | null
          description?: string | null
          guard_id?: string
          id?: string
          is_resolved?: boolean | null
          latitude?: number | null
          location_id?: string | null
          longitude?: number | null
          metadata?: Json
          photo_url?: string | null
          resolution_notes?: string | null
          resolved_at?: string | null
          resolved_by?: string | null
          streaming_active?: boolean
        }
        Relationships: [
          {
            foreignKeyName: "panic_alerts_guard_id_fkey"
            columns: ["guard_id"]
            isOneToOne: false
            referencedRelation: "security_guards"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "panic_alerts_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "panic_alerts_resolved_by_fkey"
            columns: ["resolved_by"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      payments: {
        Row: {
          amount: number
          created_at: string | null
          currency: string | null
          evidence_url: string | null
          external_id: string | null
          failure_reason: string | null
          gateway_log: Json | null
          id: string
          notes: string | null
          payee_id: string | null
          payee_type: string | null
          payer_id: string | null
          payer_type: string | null
          payment_date: string
          payment_method_id: string | null
          payment_number: string | null
          payment_type: string
          processed_by: string | null
          reference_id: string | null
          reference_type: string
          status: string | null
          updated_at: string | null
        }
        Insert: {
          amount: number
          created_at?: string | null
          currency?: string | null
          evidence_url?: string | null
          external_id?: string | null
          failure_reason?: string | null
          gateway_log?: Json | null
          id?: string
          notes?: string | null
          payee_id?: string | null
          payee_type?: string | null
          payer_id?: string | null
          payer_type?: string | null
          payment_date?: string
          payment_method_id?: string | null
          payment_number?: string | null
          payment_type: string
          processed_by?: string | null
          reference_id?: string | null
          reference_type: string
          status?: string | null
          updated_at?: string | null
        }
        Update: {
          amount?: number
          created_at?: string | null
          currency?: string | null
          evidence_url?: string | null
          external_id?: string | null
          failure_reason?: string | null
          gateway_log?: Json | null
          id?: string
          notes?: string | null
          payee_id?: string | null
          payee_type?: string | null
          payer_id?: string | null
          payer_type?: string | null
          payment_date?: string
          payment_method_id?: string | null
          payment_number?: string | null
          payment_type?: string
          processed_by?: string | null
          reference_id?: string | null
          reference_type?: string
          status?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      payroll_cycles: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          computed_at: string | null
          computed_by: string | null
          created_at: string | null
          created_by: string | null
          cycle_code: string
          disbursed_at: string | null
          disbursed_by: string | null
          id: string
          notes: string | null
          period_end: string
          period_month: number
          period_start: string
          period_year: number
          status: Database["public"]["Enums"]["payroll_cycle_status"]
          total_deductions: number | null
          total_employees: number | null
          total_gross: number | null
          total_net: number | null
          total_working_days: number
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          computed_at?: string | null
          computed_by?: string | null
          created_at?: string | null
          created_by?: string | null
          cycle_code: string
          disbursed_at?: string | null
          disbursed_by?: string | null
          id?: string
          notes?: string | null
          period_end: string
          period_month: number
          period_start: string
          period_year: number
          status?: Database["public"]["Enums"]["payroll_cycle_status"]
          total_deductions?: number | null
          total_employees?: number | null
          total_gross?: number | null
          total_net?: number | null
          total_working_days: number
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          computed_at?: string | null
          computed_by?: string | null
          created_at?: string | null
          created_by?: string | null
          cycle_code?: string
          disbursed_at?: string | null
          disbursed_by?: string | null
          id?: string
          notes?: string | null
          period_end?: string
          period_month?: number
          period_start?: string
          period_year?: number
          status?: Database["public"]["Enums"]["payroll_cycle_status"]
          total_deductions?: number | null
          total_employees?: number | null
          total_gross?: number | null
          total_net?: number | null
          total_working_days?: number
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      payslips: {
        Row: {
          absent_days: number
          advance_recovery: number
          bank_account_number: string | null
          bank_ifsc: string | null
          basic_salary: number
          bonus: number
          created_at: string | null
          created_by: string | null
          employee_id: string
          employer_esic: number
          employer_pf: number
          esic_deduction: number
          gross_salary: number
          hra: number
          id: string
          leave_days: number
          loan_recovery: number
          medical_allowance: number
          net_payable: number
          notes: string | null
          other_deductions: number
          other_earnings: number
          overtime_amount: number
          overtime_hours: number
          paid_at: string | null
          payment_mode: string | null
          payment_reference: string | null
          payroll_cycle_id: string
          payslip_number: string | null
          pf_deduction: number
          present_days: number
          pro_rated_basic: number
          professional_tax: number
          special_allowance: number
          status: Database["public"]["Enums"]["payslip_status"]
          tds: number
          total_deductions: number
          travel_allowance: number
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          absent_days?: number
          advance_recovery?: number
          bank_account_number?: string | null
          bank_ifsc?: string | null
          basic_salary?: number
          bonus?: number
          created_at?: string | null
          created_by?: string | null
          employee_id: string
          employer_esic?: number
          employer_pf?: number
          esic_deduction?: number
          gross_salary?: number
          hra?: number
          id?: string
          leave_days?: number
          loan_recovery?: number
          medical_allowance?: number
          net_payable?: number
          notes?: string | null
          other_deductions?: number
          other_earnings?: number
          overtime_amount?: number
          overtime_hours?: number
          paid_at?: string | null
          payment_mode?: string | null
          payment_reference?: string | null
          payroll_cycle_id: string
          payslip_number?: string | null
          pf_deduction?: number
          present_days?: number
          pro_rated_basic?: number
          professional_tax?: number
          special_allowance?: number
          status?: Database["public"]["Enums"]["payslip_status"]
          tds?: number
          total_deductions?: number
          travel_allowance?: number
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          absent_days?: number
          advance_recovery?: number
          bank_account_number?: string | null
          bank_ifsc?: string | null
          basic_salary?: number
          bonus?: number
          created_at?: string | null
          created_by?: string | null
          employee_id?: string
          employer_esic?: number
          employer_pf?: number
          esic_deduction?: number
          gross_salary?: number
          hra?: number
          id?: string
          leave_days?: number
          loan_recovery?: number
          medical_allowance?: number
          net_payable?: number
          notes?: string | null
          other_deductions?: number
          other_earnings?: number
          overtime_amount?: number
          overtime_hours?: number
          paid_at?: string | null
          payment_mode?: string | null
          payment_reference?: string | null
          payroll_cycle_id?: string
          payslip_number?: string | null
          pf_deduction?: number
          present_days?: number
          pro_rated_basic?: number
          professional_tax?: number
          special_allowance?: number
          status?: Database["public"]["Enums"]["payslip_status"]
          tds?: number
          total_deductions?: number
          travel_allowance?: number
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "payslips_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "payslips_payroll_cycle_id_fkey"
            columns: ["payroll_cycle_id"]
            isOneToOne: false
            referencedRelation: "payroll_cycles"
            referencedColumns: ["id"]
          },
        ]
      }
      product_categories: {
        Row: {
          category_code: string | null
          category_name: string
          created_at: string | null
          created_by: string | null
          description: string | null
          id: string
          is_active: boolean | null
          parent_category_id: string | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          category_code?: string | null
          category_name: string
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          parent_category_id?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          category_code?: string | null
          category_name?: string
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          parent_category_id?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "product_categories_parent_category_id_fkey"
            columns: ["parent_category_id"]
            isOneToOne: false
            referencedRelation: "product_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      products: {
        Row: {
          base_rate: number | null
          category_id: string | null
          created_at: string | null
          created_by: string | null
          current_stock: number | null
          description: string | null
          hsn_code: string | null
          id: string
          is_active: boolean | null
          min_stock_level: number | null
          product_code: string | null
          product_name: string
          specifications: Json | null
          status: string | null
          subcategory_id: string | null
          unit_of_measurement: string | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          base_rate?: number | null
          category_id?: string | null
          created_at?: string | null
          created_by?: string | null
          current_stock?: number | null
          description?: string | null
          hsn_code?: string | null
          id?: string
          is_active?: boolean | null
          min_stock_level?: number | null
          product_code?: string | null
          product_name: string
          specifications?: Json | null
          status?: string | null
          subcategory_id?: string | null
          unit_of_measurement?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          base_rate?: number | null
          category_id?: string | null
          created_at?: string | null
          created_by?: string | null
          current_stock?: number | null
          description?: string | null
          hsn_code?: string | null
          id?: string
          is_active?: boolean | null
          min_stock_level?: number | null
          product_code?: string | null
          product_name?: string
          specifications?: Json | null
          status?: string | null
          subcategory_id?: string | null
          unit_of_measurement?: string | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "products_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "product_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      purchase_bills: {
        Row: {
          bill_date: string
          bill_number: string | null
          budget_id: string | null
          created_at: string | null
          created_by: string | null
          discount_amount: number | null
          due_amount: number | null
          due_date: string | null
          external_id: string | null
          failure_reason: string | null
          gateway_log: Json | null
          id: string
          is_reconciled: boolean | null
          last_payment_date: string | null
          match_status: string | null
          material_receipt_id: string | null
          notes: string | null
          paid_amount: number | null
          payment_status: string | null
          purchase_order_id: string | null
          reconciled_at: string | null
          reconciled_by: string | null
          service_purchase_order_id: string | null
          status: string | null
          subtotal: number | null
          supplier_id: string | null
          supplier_invoice_number: string | null
          tax_amount: number | null
          total_amount: number
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          bill_date?: string
          bill_number?: string | null
          budget_id?: string | null
          created_at?: string | null
          created_by?: string | null
          discount_amount?: number | null
          due_amount?: number | null
          due_date?: string | null
          external_id?: string | null
          failure_reason?: string | null
          gateway_log?: Json | null
          id?: string
          is_reconciled?: boolean | null
          last_payment_date?: string | null
          match_status?: string | null
          material_receipt_id?: string | null
          notes?: string | null
          paid_amount?: number | null
          payment_status?: string | null
          purchase_order_id?: string | null
          reconciled_at?: string | null
          reconciled_by?: string | null
          service_purchase_order_id?: string | null
          status?: string | null
          subtotal?: number | null
          supplier_id?: string | null
          supplier_invoice_number?: string | null
          tax_amount?: number | null
          total_amount?: number
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          bill_date?: string
          bill_number?: string | null
          budget_id?: string | null
          created_at?: string | null
          created_by?: string | null
          discount_amount?: number | null
          due_amount?: number | null
          due_date?: string | null
          external_id?: string | null
          failure_reason?: string | null
          gateway_log?: Json | null
          id?: string
          is_reconciled?: boolean | null
          last_payment_date?: string | null
          match_status?: string | null
          material_receipt_id?: string | null
          notes?: string | null
          paid_amount?: number | null
          payment_status?: string | null
          purchase_order_id?: string | null
          reconciled_at?: string | null
          reconciled_by?: string | null
          service_purchase_order_id?: string | null
          status?: string | null
          subtotal?: number | null
          supplier_id?: string | null
          supplier_invoice_number?: string | null
          tax_amount?: number | null
          total_amount?: number
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "purchase_bills_material_receipt_id_fkey"
            columns: ["material_receipt_id"]
            isOneToOne: false
            referencedRelation: "material_receipts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_bills_purchase_order_id_fkey"
            columns: ["purchase_order_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_bills_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      purchase_order_items: {
        Row: {
          created_at: string | null
          discount_amount: number | null
          discount_percent: number | null
          id: string
          indent_item_id: string | null
          item_description: string | null
          line_total: number
          notes: string | null
          ordered_quantity: number
          product_id: string | null
          purchase_order_id: string
          received_quantity: number | null
          specifications: string | null
          tax_amount: number | null
          tax_rate: number | null
          unit_of_measure: string | null
          unit_price: number
          unmatched_amount: number | null
          unmatched_qty: number | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          discount_amount?: number | null
          discount_percent?: number | null
          id?: string
          indent_item_id?: string | null
          item_description?: string | null
          line_total: number
          notes?: string | null
          ordered_quantity: number
          product_id?: string | null
          purchase_order_id: string
          received_quantity?: number | null
          specifications?: string | null
          tax_amount?: number | null
          tax_rate?: number | null
          unit_of_measure?: string | null
          unit_price: number
          unmatched_amount?: number | null
          unmatched_qty?: number | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          discount_amount?: number | null
          discount_percent?: number | null
          id?: string
          indent_item_id?: string | null
          item_description?: string | null
          line_total?: number
          notes?: string | null
          ordered_quantity?: number
          product_id?: string | null
          purchase_order_id?: string
          received_quantity?: number | null
          specifications?: string | null
          tax_amount?: number | null
          tax_rate?: number | null
          unit_of_measure?: string | null
          unit_price?: number
          unmatched_amount?: number | null
          unmatched_qty?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "purchase_order_items_indent_item_id_fkey"
            columns: ["indent_item_id"]
            isOneToOne: false
            referencedRelation: "indent_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "purchase_order_items_purchase_order_id_fkey"
            columns: ["purchase_order_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
        ]
      }
      purchase_orders: {
        Row: {
          billing_address: string | null
          created_at: string | null
          created_by: string | null
          discount_amount: number | null
          dispatch_notes: string | null
          dispatched_at: string | null
          expected_delivery_date: string | null
          grand_total: number | null
          id: string
          indent_id: string | null
          md_action: string | null
          md_approved_at: string | null
          md_approved_by: string | null
          notes: string | null
          payment_terms: string | null
          po_date: string
          po_number: string | null
          sent_to_vendor_at: string | null
          shipping_address: string | null
          shipping_cost: number | null
          status: Database["public"]["Enums"]["po_status"]
          subtotal: number | null
          supplier_id: string | null
          tax_amount: number | null
          terms_and_conditions: string | null
          updated_at: string | null
          updated_by: string | null
          vehicle_details: string | null
          vendor_acknowledged_at: string | null
        }
        Insert: {
          billing_address?: string | null
          created_at?: string | null
          created_by?: string | null
          discount_amount?: number | null
          dispatch_notes?: string | null
          dispatched_at?: string | null
          expected_delivery_date?: string | null
          grand_total?: number | null
          id?: string
          indent_id?: string | null
          md_action?: string | null
          md_approved_at?: string | null
          md_approved_by?: string | null
          notes?: string | null
          payment_terms?: string | null
          po_date?: string
          po_number?: string | null
          sent_to_vendor_at?: string | null
          shipping_address?: string | null
          shipping_cost?: number | null
          status?: Database["public"]["Enums"]["po_status"]
          subtotal?: number | null
          supplier_id?: string | null
          tax_amount?: number | null
          terms_and_conditions?: string | null
          updated_at?: string | null
          updated_by?: string | null
          vehicle_details?: string | null
          vendor_acknowledged_at?: string | null
        }
        Update: {
          billing_address?: string | null
          created_at?: string | null
          created_by?: string | null
          discount_amount?: number | null
          dispatch_notes?: string | null
          dispatched_at?: string | null
          expected_delivery_date?: string | null
          grand_total?: number | null
          id?: string
          indent_id?: string | null
          md_action?: string | null
          md_approved_at?: string | null
          md_approved_by?: string | null
          notes?: string | null
          payment_terms?: string | null
          po_date?: string
          po_number?: string | null
          sent_to_vendor_at?: string | null
          shipping_address?: string | null
          shipping_cost?: number | null
          status?: Database["public"]["Enums"]["po_status"]
          subtotal?: number | null
          supplier_id?: string | null
          tax_amount?: number | null
          terms_and_conditions?: string | null
          updated_at?: string | null
          updated_by?: string | null
          vehicle_details?: string | null
          vendor_acknowledged_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "purchase_orders_indent_id_fkey"
            columns: ["indent_id"]
            isOneToOne: false
            referencedRelation: "indents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_orders_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      reconciliations: {
        Row: {
          adjusted_amount: number | null
          adjustment_reason: string | null
          bill_amount: number | null
          bill_grn_variance: number | null
          bill_po_variance: number | null
          created_at: string | null
          created_by: string | null
          discrepancy_notes: string | null
          discrepancy_type: string | null
          grn_amount: number | null
          id: string
          material_receipt_id: string | null
          notes: string | null
          po_amount: number | null
          po_grn_variance: number | null
          purchase_bill_id: string | null
          purchase_order_id: string | null
          reconciliation_number: string | null
          resolution_action: string | null
          resolution_notes: string | null
          resolved_at: string | null
          resolved_by: string | null
          status: Database["public"]["Enums"]["reconciliation_status"]
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          adjusted_amount?: number | null
          adjustment_reason?: string | null
          bill_amount?: number | null
          bill_grn_variance?: number | null
          bill_po_variance?: number | null
          created_at?: string | null
          created_by?: string | null
          discrepancy_notes?: string | null
          discrepancy_type?: string | null
          grn_amount?: number | null
          id?: string
          material_receipt_id?: string | null
          notes?: string | null
          po_amount?: number | null
          po_grn_variance?: number | null
          purchase_bill_id?: string | null
          purchase_order_id?: string | null
          reconciliation_number?: string | null
          resolution_action?: string | null
          resolution_notes?: string | null
          resolved_at?: string | null
          resolved_by?: string | null
          status?: Database["public"]["Enums"]["reconciliation_status"]
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          adjusted_amount?: number | null
          adjustment_reason?: string | null
          bill_amount?: number | null
          bill_grn_variance?: number | null
          bill_po_variance?: number | null
          created_at?: string | null
          created_by?: string | null
          discrepancy_notes?: string | null
          discrepancy_type?: string | null
          grn_amount?: number | null
          id?: string
          material_receipt_id?: string | null
          notes?: string | null
          po_amount?: number | null
          po_grn_variance?: number | null
          purchase_bill_id?: string | null
          purchase_order_id?: string | null
          reconciliation_number?: string | null
          resolution_action?: string | null
          resolution_notes?: string | null
          resolved_at?: string | null
          resolved_by?: string | null
          status?: Database["public"]["Enums"]["reconciliation_status"]
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "reconciliations_material_receipt_id_fkey"
            columns: ["material_receipt_id"]
            isOneToOne: false
            referencedRelation: "material_receipts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reconciliations_purchase_bill_id_fkey"
            columns: ["purchase_bill_id"]
            isOneToOne: false
            referencedRelation: "purchase_bills"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reconciliations_purchase_order_id_fkey"
            columns: ["purchase_order_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
        ]
      }
      reorder_rules: {
        Row: {
          auto_reorder: boolean | null
          created_at: string | null
          id: string
          is_active: boolean | null
          lead_time_days: number | null
          max_stock_level: number | null
          preferred_supplier_id: string | null
          product_id: string
          reorder_level: number
          reorder_quantity: number
          updated_at: string | null
          warehouse_id: string | null
        }
        Insert: {
          auto_reorder?: boolean | null
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          lead_time_days?: number | null
          max_stock_level?: number | null
          preferred_supplier_id?: string | null
          product_id: string
          reorder_level: number
          reorder_quantity: number
          updated_at?: string | null
          warehouse_id?: string | null
        }
        Update: {
          auto_reorder?: boolean | null
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          lead_time_days?: number | null
          max_stock_level?: number | null
          preferred_supplier_id?: string | null
          product_id?: string
          reorder_level?: number
          reorder_quantity?: number
          updated_at?: string | null
          warehouse_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "reorder_rules_preferred_supplier_id_fkey"
            columns: ["preferred_supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reorder_rules_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reorder_rules_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "reorder_rules_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["warehouse_id"]
          },
          {
            foreignKeyName: "reorder_rules_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "warehouses"
            referencedColumns: ["id"]
          },
        ]
      }
      request_items: {
        Row: {
          created_at: string | null
          id: string
          notes: string | null
          product_id: string | null
          quantity: number
          request_id: string
          unit: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          notes?: string | null
          product_id?: string | null
          quantity: number
          request_id: string
          unit?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          notes?: string | null
          product_id?: string | null
          quantity?: number
          request_id?: string
          unit?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "request_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "request_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "request_items_request_id_fkey"
            columns: ["request_id"]
            isOneToOne: false
            referencedRelation: "requests"
            referencedColumns: ["id"]
          },
        ]
      }
      requests: {
        Row: {
          buyer_id: string
          category_id: string | null
          created_at: string | null
          created_by: string | null
          description: string | null
          duration_months: number | null
          headcount: number | null
          id: string
          indent_id: string | null
          is_service_request: boolean
          location_id: string | null
          preferred_delivery_date: string | null
          rejected_at: string | null
          rejected_by: string | null
          rejection_reason: string | null
          request_number: string | null
          service_grade: string | null
          service_type: string | null
          shift: string | null
          site_location_id: string | null
          start_date: string | null
          status: Database["public"]["Enums"]["request_status"]
          supplier_id: string | null
          title: string
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          buyer_id: string
          category_id?: string | null
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          duration_months?: number | null
          headcount?: number | null
          id?: string
          indent_id?: string | null
          is_service_request?: boolean
          location_id?: string | null
          preferred_delivery_date?: string | null
          rejected_at?: string | null
          rejected_by?: string | null
          rejection_reason?: string | null
          request_number?: string | null
          service_grade?: string | null
          service_type?: string | null
          shift?: string | null
          site_location_id?: string | null
          start_date?: string | null
          status?: Database["public"]["Enums"]["request_status"]
          supplier_id?: string | null
          title: string
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          buyer_id?: string
          category_id?: string | null
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          duration_months?: number | null
          headcount?: number | null
          id?: string
          indent_id?: string | null
          is_service_request?: boolean
          location_id?: string | null
          preferred_delivery_date?: string | null
          rejected_at?: string | null
          rejected_by?: string | null
          rejection_reason?: string | null
          request_number?: string | null
          service_grade?: string | null
          service_type?: string | null
          shift?: string | null
          site_location_id?: string | null
          start_date?: string | null
          status?: Database["public"]["Enums"]["request_status"]
          supplier_id?: string | null
          title?: string
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "requests_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "product_categories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "requests_indent_id_fkey"
            columns: ["indent_id"]
            isOneToOne: false
            referencedRelation: "indents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "requests_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "requests_site_location_id_fkey"
            columns: ["site_location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "requests_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      residents: {
        Row: {
          alternate_phone: string | null
          auth_user_id: string | null
          created_at: string | null
          email: string | null
          emergency_contact_name: string | null
          emergency_contact_phone: string | null
          flat_id: string
          full_name: string
          id: string
          is_active: boolean | null
          is_primary_contact: boolean | null
          move_in_date: string | null
          move_out_date: string | null
          phone: string | null
          relation: string | null
          resident_code: string
        }
        Insert: {
          alternate_phone?: string | null
          auth_user_id?: string | null
          created_at?: string | null
          email?: string | null
          emergency_contact_name?: string | null
          emergency_contact_phone?: string | null
          flat_id: string
          full_name: string
          id?: string
          is_active?: boolean | null
          is_primary_contact?: boolean | null
          move_in_date?: string | null
          move_out_date?: string | null
          phone?: string | null
          relation?: string | null
          resident_code: string
        }
        Update: {
          alternate_phone?: string | null
          auth_user_id?: string | null
          created_at?: string | null
          email?: string | null
          emergency_contact_name?: string | null
          emergency_contact_phone?: string | null
          flat_id?: string
          full_name?: string
          id?: string
          is_active?: boolean | null
          is_primary_contact?: boolean | null
          move_in_date?: string | null
          move_out_date?: string | null
          phone?: string | null
          relation?: string | null
          resident_code?: string
        }
        Relationships: [
          {
            foreignKeyName: "residents_flat_id_fkey"
            columns: ["flat_id"]
            isOneToOne: false
            referencedRelation: "flats"
            referencedColumns: ["id"]
          },
        ]
      }
      roles: {
        Row: {
          created_at: string | null
          created_by: string | null
          description: string | null
          id: string
          is_active: boolean | null
          permissions: Json | null
          role_display_name: string
          role_name: Database["public"]["Enums"]["user_role"]
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          permissions?: Json | null
          role_display_name: string
          role_name: Database["public"]["Enums"]["user_role"]
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          permissions?: Json | null
          role_display_name?: string
          role_name?: Database["public"]["Enums"]["user_role"]
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      rtv_tickets: {
        Row: {
          accepted_at: string | null
          created_at: string | null
          credit_issued_at: string | null
          credit_note_amount: number | null
          credit_note_number: string | null
          dispatched_at: string | null
          estimated_value: number | null
          id: string
          notes: string | null
          photo_urls: Json | null
          po_id: string | null
          product_id: string
          quantity: number
          raised_by: string | null
          receipt_id: string | null
          return_reason: string
          rtv_number: string
          status: string | null
          supplier_id: string
          unit_of_measurement: string | null
          updated_at: string | null
        }
        Insert: {
          accepted_at?: string | null
          created_at?: string | null
          credit_issued_at?: string | null
          credit_note_amount?: number | null
          credit_note_number?: string | null
          dispatched_at?: string | null
          estimated_value?: number | null
          id?: string
          notes?: string | null
          photo_urls?: Json | null
          po_id?: string | null
          product_id: string
          quantity: number
          raised_by?: string | null
          receipt_id?: string | null
          return_reason: string
          rtv_number?: string
          status?: string | null
          supplier_id: string
          unit_of_measurement?: string | null
          updated_at?: string | null
        }
        Update: {
          accepted_at?: string | null
          created_at?: string | null
          credit_issued_at?: string | null
          credit_note_amount?: number | null
          credit_note_number?: string | null
          dispatched_at?: string | null
          estimated_value?: number | null
          id?: string
          notes?: string | null
          photo_urls?: Json | null
          po_id?: string | null
          product_id?: string
          quantity?: number
          raised_by?: string | null
          receipt_id?: string | null
          return_reason?: string
          rtv_number?: string
          status?: string | null
          supplier_id?: string
          unit_of_measurement?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "rtv_tickets_po_id_fkey"
            columns: ["po_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "rtv_tickets_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "rtv_tickets_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "rtv_tickets_receipt_id_fkey"
            columns: ["receipt_id"]
            isOneToOne: false
            referencedRelation: "material_receipts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "rtv_tickets_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      salary_components: {
        Row: {
          abbr: string
          created_at: string | null
          created_by: string | null
          default_amount: number | null
          depends_on_payment_days: boolean | null
          description: string | null
          formula: string | null
          id: string
          is_active: boolean | null
          is_tax_applicable: boolean | null
          name: string
          sort_order: number | null
          type: string
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          abbr: string
          created_at?: string | null
          created_by?: string | null
          default_amount?: number | null
          depends_on_payment_days?: boolean | null
          description?: string | null
          formula?: string | null
          id?: string
          is_active?: boolean | null
          is_tax_applicable?: boolean | null
          name: string
          sort_order?: number | null
          type: string
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          abbr?: string
          created_at?: string | null
          created_by?: string | null
          default_amount?: number | null
          depends_on_payment_days?: boolean | null
          description?: string | null
          formula?: string | null
          id?: string
          is_active?: boolean | null
          is_tax_applicable?: boolean | null
          name?: string
          sort_order?: number | null
          type?: string
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      sale_bills: {
        Row: {
          billing_period_end: string | null
          billing_period_start: string | null
          buyer_account_id: string | null
          client_id: string
          contract_id: string | null
          created_at: string | null
          created_by: string | null
          discount_amount: number | null
          due_amount: number | null
          due_date: string | null
          external_id: string | null
          failure_reason: string | null
          gateway_log: Json | null
          id: string
          invoice_date: string
          invoice_number: string | null
          last_payment_date: string | null
          notes: string | null
          paid_amount: number | null
          paid_at: string | null
          payment_method: string | null
          payment_reference: string | null
          payment_status: string
          request_id: string | null
          status: string
          subtotal: number | null
          tax_amount: number | null
          total_amount: number | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          billing_period_end?: string | null
          billing_period_start?: string | null
          buyer_account_id?: string | null
          client_id: string
          contract_id?: string | null
          created_at?: string | null
          created_by?: string | null
          discount_amount?: number | null
          due_amount?: number | null
          due_date?: string | null
          external_id?: string | null
          failure_reason?: string | null
          gateway_log?: Json | null
          id?: string
          invoice_date: string
          invoice_number?: string | null
          last_payment_date?: string | null
          notes?: string | null
          paid_amount?: number | null
          paid_at?: string | null
          payment_method?: string | null
          payment_reference?: string | null
          payment_status?: string
          request_id?: string | null
          status?: string
          subtotal?: number | null
          tax_amount?: number | null
          total_amount?: number | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          billing_period_end?: string | null
          billing_period_start?: string | null
          buyer_account_id?: string | null
          client_id?: string
          contract_id?: string | null
          created_at?: string | null
          created_by?: string | null
          discount_amount?: number | null
          due_amount?: number | null
          due_date?: string | null
          external_id?: string | null
          failure_reason?: string | null
          gateway_log?: Json | null
          id?: string
          invoice_date?: string
          invoice_number?: string | null
          last_payment_date?: string | null
          notes?: string | null
          paid_amount?: number | null
          paid_at?: string | null
          payment_method?: string | null
          payment_reference?: string | null
          payment_status?: string
          request_id?: string | null
          status?: string
          subtotal?: number | null
          tax_amount?: number | null
          total_amount?: number | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sale_bills_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "societies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sale_bills_request_id_fkey"
            columns: ["request_id"]
            isOneToOne: false
            referencedRelation: "requests"
            referencedColumns: ["id"]
          },
        ]
      }
      sale_product_rates: {
        Row: {
          created_at: string
          currency: string | null
          effective_from: string
          effective_to: string | null
          gst_percentage: number | null
          id: string
          is_active: boolean
          margin_percentage: number | null
          product_id: string
          rate: number
          remarks: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          currency?: string | null
          effective_from?: string
          effective_to?: string | null
          gst_percentage?: number | null
          id?: string
          is_active?: boolean
          margin_percentage?: number | null
          product_id: string
          rate: number
          remarks?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          currency?: string | null
          effective_from?: string
          effective_to?: string | null
          gst_percentage?: number | null
          id?: string
          is_active?: boolean
          margin_percentage?: number | null
          product_id?: string
          rate?: number
          remarks?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "sale_product_rates_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sale_product_rates_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
        ]
      }
      security_guards: {
        Row: {
          assigned_location_id: string | null
          created_at: string | null
          employee_id: string
          grade: Database["public"]["Enums"]["guard_grade"]
          guard_code: string
          id: string
          is_active: boolean | null
          is_armed: boolean | null
          license_expiry: string | null
          license_number: string | null
          shift_timing: string | null
          updated_at: string | null
        }
        Insert: {
          assigned_location_id?: string | null
          created_at?: string | null
          employee_id: string
          grade: Database["public"]["Enums"]["guard_grade"]
          guard_code: string
          id?: string
          is_active?: boolean | null
          is_armed?: boolean | null
          license_expiry?: string | null
          license_number?: string | null
          shift_timing?: string | null
          updated_at?: string | null
        }
        Update: {
          assigned_location_id?: string | null
          created_at?: string | null
          employee_id?: string
          grade?: Database["public"]["Enums"]["guard_grade"]
          guard_code?: string
          id?: string
          is_active?: boolean | null
          is_armed?: boolean | null
          license_expiry?: string | null
          license_number?: string | null
          shift_timing?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "security_guards_assigned_location_id_fkey"
            columns: ["assigned_location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "security_guards_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      service_categories_master: {
        Row: {
          category_code: string | null
          category_name: string
          created_at: string
          description: string | null
          display_order: number | null
          icon_url: string | null
          id: string
          is_active: boolean
          updated_at: string
        }
        Insert: {
          category_code?: string | null
          category_name: string
          created_at?: string
          description?: string | null
          display_order?: number | null
          icon_url?: string | null
          id?: string
          is_active?: boolean
          updated_at?: string
        }
        Update: {
          category_code?: string | null
          category_name?: string
          created_at?: string
          description?: string | null
          display_order?: number | null
          icon_url?: string | null
          id?: string
          is_active?: boolean
          updated_at?: string
        }
        Relationships: []
      }
      service_rates: {
        Row: {
          created_at: string | null
          effective_from: string
          effective_to: string | null
          id: string
          is_active: boolean | null
          rate: number
          service_type: string
          supplier_id: string
        }
        Insert: {
          created_at?: string | null
          effective_from: string
          effective_to?: string | null
          id?: string
          is_active?: boolean | null
          rate: number
          service_type: string
          supplier_id: string
        }
        Update: {
          created_at?: string | null
          effective_from?: string
          effective_to?: string | null
          id?: string
          is_active?: boolean | null
          rate?: number
          service_type?: string
          supplier_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "service_rates_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      service_requests: {
        Row: {
          after_photo_url: string | null
          asset_id: string | null
          assigned_at: string | null
          assigned_to: string | null
          auto_renew_terms: Json | null
          before_photo_url: string | null
          completed_at: string | null
          completion_notes: string | null
          completion_signature_url: string | null
          created_at: string | null
          created_by: string | null
          description: string
          end_date: string | null
          estimated_duration_minutes: number | null
          frozen_rates: Json | null
          id: string
          location_id: string | null
          maintenance_schedule_id: string | null
          monthly_amount: number | null
          notice_days: number | null
          priority: Database["public"]["Enums"]["service_priority"] | null
          request_number: string
          requester_id: string | null
          requester_phone: string | null
          resolution_notes: string | null
          scheduled_date: string | null
          scheduled_time: string | null
          service_id: string | null
          society_id: string | null
          start_date: string | null
          started_at: string | null
          status: Database["public"]["Enums"]["service_request_status"] | null
          title: string | null
          type: string
          updated_at: string | null
        }
        Insert: {
          after_photo_url?: string | null
          asset_id?: string | null
          assigned_at?: string | null
          assigned_to?: string | null
          auto_renew_terms?: Json | null
          before_photo_url?: string | null
          completed_at?: string | null
          completion_notes?: string | null
          completion_signature_url?: string | null
          created_at?: string | null
          created_by?: string | null
          description: string
          end_date?: string | null
          estimated_duration_minutes?: number | null
          frozen_rates?: Json | null
          id?: string
          location_id?: string | null
          maintenance_schedule_id?: string | null
          monthly_amount?: number | null
          notice_days?: number | null
          priority?: Database["public"]["Enums"]["service_priority"] | null
          request_number: string
          requester_id?: string | null
          requester_phone?: string | null
          resolution_notes?: string | null
          scheduled_date?: string | null
          scheduled_time?: string | null
          service_id?: string | null
          society_id?: string | null
          start_date?: string | null
          started_at?: string | null
          status?: Database["public"]["Enums"]["service_request_status"] | null
          title?: string | null
          type?: string
          updated_at?: string | null
        }
        Update: {
          after_photo_url?: string | null
          asset_id?: string | null
          assigned_at?: string | null
          assigned_to?: string | null
          auto_renew_terms?: Json | null
          before_photo_url?: string | null
          completed_at?: string | null
          completion_notes?: string | null
          completion_signature_url?: string | null
          created_at?: string | null
          created_by?: string | null
          description?: string
          end_date?: string | null
          estimated_duration_minutes?: number | null
          frozen_rates?: Json | null
          id?: string
          location_id?: string | null
          maintenance_schedule_id?: string | null
          monthly_amount?: number | null
          notice_days?: number | null
          priority?: Database["public"]["Enums"]["service_priority"] | null
          request_number?: string
          requester_id?: string | null
          requester_phone?: string | null
          resolution_notes?: string | null
          scheduled_date?: string | null
          scheduled_time?: string | null
          service_id?: string | null
          society_id?: string | null
          start_date?: string | null
          started_at?: string | null
          status?: Database["public"]["Enums"]["service_request_status"] | null
          title?: string | null
          type?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "service_requests_assigned_to_fkey"
            columns: ["assigned_to"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "service_requests_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "service_requests_service_id_fkey"
            columns: ["service_id"]
            isOneToOne: false
            referencedRelation: "services"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "service_requests_society_id_fkey"
            columns: ["society_id"]
            isOneToOne: false
            referencedRelation: "societies"
            referencedColumns: ["id"]
          },
        ]
      }
      service_tasks: {
        Row: {
          created_at: string | null
          description: string | null
          id: string
          is_active: boolean | null
          service_type: string
          task_name: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          service_type: string
          task_name: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          service_type?: string
          task_name?: string
        }
        Relationships: []
      }
      services: {
        Row: {
          created_at: string | null
          created_by: string | null
          description: string | null
          id: string
          is_active: boolean | null
          is_v1: boolean
          service_category: string | null
          service_code: string
          service_name: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          is_v1?: boolean
          service_category?: string | null
          service_code: string
          service_name: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          is_v1?: boolean
          service_category?: string | null
          service_code?: string
          service_name?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      shifts: {
        Row: {
          break_duration_minutes: number | null
          created_at: string | null
          description: string | null
          duration_hours: number | null
          end_time: string
          grace_time_minutes: number | null
          id: string
          is_active: boolean | null
          is_night_shift: boolean | null
          shift_code: string
          shift_name: string
          standard_hours: number | null
          start_time: string
        }
        Insert: {
          break_duration_minutes?: number | null
          created_at?: string | null
          description?: string | null
          duration_hours?: number | null
          end_time: string
          grace_time_minutes?: number | null
          id?: string
          is_active?: boolean | null
          is_night_shift?: boolean | null
          shift_code: string
          shift_name: string
          standard_hours?: number | null
          start_time: string
        }
        Update: {
          break_duration_minutes?: number | null
          created_at?: string | null
          description?: string | null
          duration_hours?: number | null
          end_time?: string
          grace_time_minutes?: number | null
          id?: string
          is_active?: boolean | null
          is_night_shift?: boolean | null
          shift_code?: string
          shift_name?: string
          standard_hours?: number | null
          start_time?: string
        }
        Relationships: []
      }
      shortage_notes: {
        Row: {
          created_at: string
          created_by: string | null
          grn_id: string | null
          id: string
          note_number: string
          po_id: string
          resolution: string | null
          status: string
          supplier_id: string
          total_shortage_value: number | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          grn_id?: string | null
          id?: string
          note_number: string
          po_id: string
          resolution?: string | null
          status?: string
          supplier_id: string
          total_shortage_value?: number | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          created_by?: string | null
          grn_id?: string | null
          id?: string
          note_number?: string
          po_id?: string
          resolution?: string | null
          status?: string
          supplier_id?: string
          total_shortage_value?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "shortage_notes_po_id_fkey"
            columns: ["po_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "shortage_notes_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      site_details: {
        Row: {
          address: string | null
          buyer_id: string
          city: string | null
          contact_person: string | null
          created_at: string
          id: string
          is_active: boolean
          latitude: number | null
          longitude: number | null
          phone: string | null
          pincode: string | null
          site_code: string | null
          site_name: string
          site_type: string | null
          state: string | null
          unit_branch_id: string
          updated_at: string
        }
        Insert: {
          address?: string | null
          buyer_id: string
          city?: string | null
          contact_person?: string | null
          created_at?: string
          id?: string
          is_active?: boolean
          latitude?: number | null
          longitude?: number | null
          phone?: string | null
          pincode?: string | null
          site_code?: string | null
          site_name: string
          site_type?: string | null
          state?: string | null
          unit_branch_id: string
          updated_at?: string
        }
        Update: {
          address?: string | null
          buyer_id?: string
          city?: string | null
          contact_person?: string | null
          created_at?: string
          id?: string
          is_active?: boolean
          latitude?: number | null
          longitude?: number | null
          phone?: string | null
          pincode?: string | null
          site_code?: string | null
          site_name?: string
          site_type?: string | null
          state?: string | null
          unit_branch_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "site_details_buyer_id_fkey"
            columns: ["buyer_id"]
            isOneToOne: false
            referencedRelation: "buyer_details"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "site_details_unit_branch_id_fkey"
            columns: ["unit_branch_id"]
            isOneToOne: false
            referencedRelation: "unit_branch_details"
            referencedColumns: ["id"]
          },
        ]
      }
      societies: {
        Row: {
          address: string | null
          city: string | null
          contact_email: string | null
          contact_person: string | null
          contact_phone: string | null
          created_at: string | null
          id: string
          is_active: boolean | null
          pincode: string | null
          society_code: string
          society_manager_id: string | null
          society_name: string
          state: string | null
          total_buildings: number | null
          total_flats: number | null
        }
        Insert: {
          address?: string | null
          city?: string | null
          contact_email?: string | null
          contact_person?: string | null
          contact_phone?: string | null
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          pincode?: string | null
          society_code: string
          society_manager_id?: string | null
          society_name: string
          state?: string | null
          total_buildings?: number | null
          total_flats?: number | null
        }
        Update: {
          address?: string | null
          city?: string | null
          contact_email?: string | null
          contact_person?: string | null
          contact_phone?: string | null
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          pincode?: string | null
          society_code?: string
          society_manager_id?: string | null
          society_name?: string
          state?: string | null
          total_buildings?: number | null
          total_flats?: number | null
        }
        Relationships: []
      }
      stock_batches: {
        Row: {
          batch_number: string
          created_at: string | null
          current_quantity: number
          expiry_date: string | null
          id: string
          initial_quantity: number
          manufacturing_date: string | null
          product_id: string
          status: string | null
          unit_cost: number | null
          updated_at: string | null
          warehouse_id: string
        }
        Insert: {
          batch_number: string
          created_at?: string | null
          current_quantity: number
          expiry_date?: string | null
          id?: string
          initial_quantity: number
          manufacturing_date?: string | null
          product_id: string
          status?: string | null
          unit_cost?: number | null
          updated_at?: string | null
          warehouse_id: string
        }
        Update: {
          batch_number?: string
          created_at?: string | null
          current_quantity?: number
          expiry_date?: string | null
          id?: string
          initial_quantity?: number
          manufacturing_date?: string | null
          product_id?: string
          status?: string | null
          unit_cost?: number | null
          updated_at?: string | null
          warehouse_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "stock_batches_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stock_batches_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "stock_batches_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["warehouse_id"]
          },
          {
            foreignKeyName: "stock_batches_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "warehouses"
            referencedColumns: ["id"]
          },
        ]
      }
      stock_transactions: {
        Row: {
          batch_number: string | null
          created_at: string | null
          created_by: string | null
          id: string
          location_id: string | null
          notes: string | null
          product_id: string
          quantity: number
          reference_id: string | null
          reference_type: string | null
          transaction_date: string
          transaction_number: string
          transaction_type: string
          unit_of_measurement: string
        }
        Insert: {
          batch_number?: string | null
          created_at?: string | null
          created_by?: string | null
          id?: string
          location_id?: string | null
          notes?: string | null
          product_id: string
          quantity: number
          reference_id?: string | null
          reference_type?: string | null
          transaction_date: string
          transaction_number: string
          transaction_type: string
          unit_of_measurement: string
        }
        Update: {
          batch_number?: string | null
          created_at?: string | null
          created_by?: string | null
          id?: string
          location_id?: string | null
          notes?: string | null
          product_id?: string
          quantity?: number
          reference_id?: string | null
          reference_type?: string | null
          transaction_date?: string
          transaction_number?: string
          transaction_type?: string
          unit_of_measurement?: string
        }
        Relationships: [
          {
            foreignKeyName: "stock_transactions_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stock_transactions_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stock_transactions_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
        ]
      }
      supplier_products: {
        Row: {
          created_at: string | null
          id: string
          product_id: string | null
          supplier_id: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          product_id?: string | null
          supplier_id?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          product_id?: string | null
          supplier_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "supplier_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "supplier_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "supplier_products_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      suppliers: {
        Row: {
          address: string | null
          alternate_phone: string | null
          availability: string | null
          bank_account_number: string | null
          bank_name: string | null
          city: string | null
          contact_person: string | null
          country: string | null
          created_at: string | null
          created_by: string | null
          credit_limit: number | null
          email: string | null
          gst_number: string | null
          id: string
          ifsc_code: string | null
          is_active: boolean | null
          is_verified: boolean | null
          pan_number: string | null
          payment_terms: number | null
          phone: string | null
          pincode: string | null
          rates: string | null
          rating: number | null
          state: string | null
          status: string | null
          supplier_code: string | null
          supplier_name: string
          supplier_type: string | null
          tier: number | null
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          address?: string | null
          alternate_phone?: string | null
          availability?: string | null
          bank_account_number?: string | null
          bank_name?: string | null
          city?: string | null
          contact_person?: string | null
          country?: string | null
          created_at?: string | null
          created_by?: string | null
          credit_limit?: number | null
          email?: string | null
          gst_number?: string | null
          id?: string
          ifsc_code?: string | null
          is_active?: boolean | null
          is_verified?: boolean | null
          pan_number?: string | null
          payment_terms?: number | null
          phone?: string | null
          pincode?: string | null
          rates?: string | null
          rating?: number | null
          state?: string | null
          status?: string | null
          supplier_code?: string | null
          supplier_name: string
          supplier_type?: string | null
          tier?: number | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          address?: string | null
          alternate_phone?: string | null
          availability?: string | null
          bank_account_number?: string | null
          bank_name?: string | null
          city?: string | null
          contact_person?: string | null
          country?: string | null
          created_at?: string | null
          created_by?: string | null
          credit_limit?: number | null
          email?: string | null
          gst_number?: string | null
          id?: string
          ifsc_code?: string | null
          is_active?: boolean | null
          is_verified?: boolean | null
          pan_number?: string | null
          payment_terms?: number | null
          phone?: string | null
          pincode?: string | null
          rates?: string | null
          rating?: number | null
          state?: string | null
          status?: string | null
          supplier_code?: string | null
          supplier_name?: string
          supplier_type?: string | null
          tier?: number | null
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      suppliers_wise_product_rates: {
        Row: {
          created_at: string
          currency: string | null
          effective_from: string
          effective_to: string | null
          gst_percentage: number | null
          id: string
          is_active: boolean
          rate: number
          remarks: string | null
          supplier_wise_product_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          currency?: string | null
          effective_from?: string
          effective_to?: string | null
          gst_percentage?: number | null
          id?: string
          is_active?: boolean
          rate: number
          remarks?: string | null
          supplier_wise_product_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          currency?: string | null
          effective_from?: string
          effective_to?: string | null
          gst_percentage?: number | null
          id?: string
          is_active?: boolean
          rate?: number
          remarks?: string | null
          supplier_wise_product_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "suppliers_wise_product_rates_supplier_wise_product_id_fkey"
            columns: ["supplier_wise_product_id"]
            isOneToOne: false
            referencedRelation: "suppliers_wise_products"
            referencedColumns: ["id"]
          },
        ]
      }
      suppliers_wise_products: {
        Row: {
          created_at: string
          id: string
          is_active: boolean
          product_id: string
          remarks: string | null
          supplier_id: string
          supplier_product_code: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          is_active?: boolean
          product_id: string
          remarks?: string | null
          supplier_id: string
          supplier_product_code?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          is_active?: boolean
          product_id?: string
          remarks?: string | null
          supplier_id?: string
          supplier_product_code?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "suppliers_wise_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "suppliers_wise_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "stock_levels"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "suppliers_wise_products_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      technician_profiles: {
        Row: {
          certifications: string[] | null
          created_at: string | null
          created_by: string | null
          employee_id: string
          id: string
          is_active: boolean | null
          skills: string[] | null
          updated_at: string | null
        }
        Insert: {
          certifications?: string[] | null
          created_at?: string | null
          created_by?: string | null
          employee_id: string
          id?: string
          is_active?: boolean | null
          skills?: string[] | null
          updated_at?: string | null
        }
        Update: {
          certifications?: string[] | null
          created_at?: string | null
          created_by?: string | null
          employee_id?: string
          id?: string
          is_active?: boolean | null
          skills?: string[] | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "technician_profiles_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: true
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
        ]
      }
      unit_branch_details: {
        Row: {
          address: string | null
          buyer_id: string
          city: string | null
          contact_person: string | null
          created_at: string
          email: string | null
          gst_number: string | null
          id: string
          is_active: boolean
          phone: string | null
          pincode: string | null
          state: string | null
          unit_branch_code: string | null
          unit_branch_name: string
          updated_at: string
        }
        Insert: {
          address?: string | null
          buyer_id: string
          city?: string | null
          contact_person?: string | null
          created_at?: string
          email?: string | null
          gst_number?: string | null
          id?: string
          is_active?: boolean
          phone?: string | null
          pincode?: string | null
          state?: string | null
          unit_branch_code?: string | null
          unit_branch_name: string
          updated_at?: string
        }
        Update: {
          address?: string | null
          buyer_id?: string
          city?: string | null
          contact_person?: string | null
          created_at?: string
          email?: string | null
          gst_number?: string | null
          id?: string
          is_active?: boolean
          phone?: string | null
          pincode?: string | null
          state?: string | null
          unit_branch_code?: string | null
          unit_branch_name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "unit_branch_details_buyer_id_fkey"
            columns: ["buyer_id"]
            isOneToOne: false
            referencedRelation: "buyer_details"
            referencedColumns: ["id"]
          },
        ]
      }
      users: {
        Row: {
          created_at: string | null
          email: string
          employee_id: string | null
          full_name: string
          id: string
          is_active: boolean | null
          last_login: string | null
          must_change_password: boolean
          phone: string | null
          preferences: Json | null
          role_id: string
          supplier_id: string | null
          updated_at: string | null
          username: string
        }
        Insert: {
          created_at?: string | null
          email: string
          employee_id?: string | null
          full_name: string
          id: string
          is_active?: boolean | null
          last_login?: string | null
          must_change_password?: boolean
          phone?: string | null
          preferences?: Json | null
          role_id: string
          supplier_id?: string | null
          updated_at?: string | null
          username: string
        }
        Update: {
          created_at?: string | null
          email?: string
          employee_id?: string | null
          full_name?: string
          id?: string
          is_active?: boolean | null
          last_login?: string | null
          must_change_password?: boolean
          phone?: string | null
          preferences?: Json | null
          role_id?: string
          supplier_id?: string | null
          updated_at?: string | null
          username?: string
        }
        Relationships: [
          {
            foreignKeyName: "users_employee_id_fkey"
            columns: ["employee_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "users_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "users_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      visitors: {
        Row: {
          approval_deadline_at: string | null
          approval_status: string
          approved_by_resident: boolean | null
          bypass_reason: string | null
          created_at: string | null
          decision_at: string | null
          entry_guard_id: string | null
          entry_location_id: string | null
          entry_time: string | null
          exit_guard_id: string | null
          exit_time: string | null
          flat_id: string | null
          id: string
          is_frequent_visitor: boolean | null
          notification_sent_at: string | null
          phone: string | null
          photo_url: string | null
          pii_redacted_at: string | null
          purpose: string | null
          rejection_reason: string | null
          resident_id: string | null
          vehicle_number: string | null
          visitor_name: string
          visitor_pass_number: string | null
          visitor_type: string | null
        }
        Insert: {
          approval_deadline_at?: string | null
          approval_status?: string
          approved_by_resident?: boolean | null
          bypass_reason?: string | null
          created_at?: string | null
          decision_at?: string | null
          entry_guard_id?: string | null
          entry_location_id?: string | null
          entry_time?: string | null
          exit_guard_id?: string | null
          exit_time?: string | null
          flat_id?: string | null
          id?: string
          is_frequent_visitor?: boolean | null
          notification_sent_at?: string | null
          phone?: string | null
          photo_url?: string | null
          pii_redacted_at?: string | null
          purpose?: string | null
          rejection_reason?: string | null
          resident_id?: string | null
          vehicle_number?: string | null
          visitor_name: string
          visitor_pass_number?: string | null
          visitor_type?: string | null
        }
        Update: {
          approval_deadline_at?: string | null
          approval_status?: string
          approved_by_resident?: boolean | null
          bypass_reason?: string | null
          created_at?: string | null
          decision_at?: string | null
          entry_guard_id?: string | null
          entry_location_id?: string | null
          entry_time?: string | null
          exit_guard_id?: string | null
          exit_time?: string | null
          flat_id?: string | null
          id?: string
          is_frequent_visitor?: boolean | null
          notification_sent_at?: string | null
          phone?: string | null
          photo_url?: string | null
          pii_redacted_at?: string | null
          purpose?: string | null
          rejection_reason?: string | null
          resident_id?: string | null
          vehicle_number?: string | null
          visitor_name?: string
          visitor_pass_number?: string | null
          visitor_type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "visitors_entry_guard_id_fkey"
            columns: ["entry_guard_id"]
            isOneToOne: false
            referencedRelation: "security_guards"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "visitors_entry_location_id_fkey"
            columns: ["entry_location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "visitors_exit_guard_id_fkey"
            columns: ["exit_guard_id"]
            isOneToOne: false
            referencedRelation: "security_guards"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "visitors_flat_id_fkey"
            columns: ["flat_id"]
            isOneToOne: false
            referencedRelation: "flats"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "visitors_resident_id_fkey"
            columns: ["resident_id"]
            isOneToOne: false
            referencedRelation: "residents"
            referencedColumns: ["id"]
          },
        ]
      }
      warehouses: {
        Row: {
          created_at: string | null
          created_by: string | null
          id: string
          is_active: boolean | null
          location_id: string | null
          manager_id: string | null
          phone: string | null
          society_id: string | null
          updated_at: string | null
          warehouse_code: string
          warehouse_name: string
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          id?: string
          is_active?: boolean | null
          location_id?: string | null
          manager_id?: string | null
          phone?: string | null
          society_id?: string | null
          updated_at?: string | null
          warehouse_code: string
          warehouse_name: string
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          id?: string
          is_active?: boolean | null
          location_id?: string | null
          manager_id?: string | null
          phone?: string | null
          society_id?: string | null
          updated_at?: string | null
          warehouse_code?: string
          warehouse_name?: string
        }
        Relationships: [
          {
            foreignKeyName: "warehouses_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "company_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "warehouses_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "employees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "warehouses_society_id_fkey"
            columns: ["society_id"]
            isOneToOne: false
            referencedRelation: "societies"
            referencedColumns: ["id"]
          },
        ]
      }
      work_master: {
        Row: {
          created_at: string | null
          description: string | null
          estimated_duration_minutes: number | null
          id: string
          is_active: boolean | null
          priority: string | null
          work_name: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          estimated_duration_minutes?: number | null
          id?: string
          is_active?: boolean | null
          priority?: string | null
          work_name: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          estimated_duration_minutes?: number | null
          id?: string
          is_active?: boolean | null
          priority?: string | null
          work_name?: string
        }
        Relationships: []
      }
    }
    Views: {
      stock_levels: {
        Row: {
          needs_reorder: boolean | null
          product_code: string | null
          product_id: string | null
          product_name: string | null
          reorder_level: number | null
          total_quantity: number | null
          warehouse_id: string | null
          warehouse_name: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      acknowledge_mobile_panic_alert: {
        Args: { p_alert_id: string; p_notes?: string }
        Returns: Json
      }
      acknowledge_panic_alert: {
        Args: { p_acknowledged_by: string; p_alert_id: string }
        Returns: boolean
      }
      acknowledge_site_incident: {
        Args: { p_incident_id: string; p_supervisor_id: string }
        Returns: undefined
      }
      approve_leave_request: {
        Args: { p_approver_id: string; p_leave_id: string }
        Returns: undefined
      }
      approve_md_item: {
        Args: { p_approver_id: string; p_item_id: string }
        Returns: undefined
      }
      approve_visitor: {
        Args: { p_user_id: string; p_visitor_id: string }
        Returns: Json
      }
      auto_exit_stale_visitors: { Args: never; Returns: undefined }
      auto_punch_out_idle_employees: { Args: never; Returns: undefined }
      bytea_to_text: { Args: { data: string }; Returns: string }
      calculate_employee_salary: {
        Args: {
          p_employee_id: string
          p_period_end: string
          p_period_start: string
          p_total_working_days: number
        }
        Returns: Json
      }
      check_all_ppe_items: { Args: { checklist: Json }; Returns: boolean }
      check_compliance: { Args: never; Returns: undefined }
      check_geofence: {
        Args: {
          p_lat: number
          p_lng: number
          p_radius_meters: number
          p_site_lat: number
          p_site_lng: number
        }
        Returns: boolean
      }
      checkout_visitor: {
        Args: { p_user_id: string; p_visitor_id: string }
        Returns: Json
      }
      complete_service_task: {
        Args: {
          p_after_photo_url: string
          p_completion_notes?: string
          p_request_id: string
          p_signature_url?: string
        }
        Returns: boolean
      }
      create_behavior_ticket: {
        Args: {
          p_category: string
          p_evidence_urls?: Json
          p_linked_employee_id?: string
          p_location_name?: string
          p_note: string
          p_severity: string
          p_subject_name: string
        }
        Returns: Json
      }
      create_material_ticket: {
        Args: {
          p_batch_number?: string
          p_category: string
          p_evidence_urls?: Json
          p_inspection_outcome?: string
          p_location_name?: string
          p_material_issue_type: string
          p_note: string
          p_ordered_quantity?: number
          p_received_quantity?: number
          p_return_quantity?: number
          p_severity?: string
          p_source_visitor_id?: string
          p_subject_name: string
        }
        Returns: Json
      }
      create_mobile_visitor:
        | {
            Args: {
              p_flat_id: string
              p_is_frequent_visitor?: boolean
              p_phone: string
              p_photo_url?: string
              p_purpose: string
              p_vehicle_number?: string
              p_visitor_name: string
            }
            Returns: Json
          }
        | {
            Args: {
              p_flat_id: string
              p_is_frequent_visitor?: boolean
              p_phone: string
              p_photo_url?: string
              p_purpose: string
              p_vehicle_number?: string
              p_visitor_name: string
              p_visitor_type?: string
            }
            Returns: Json
          }
      create_po_from_supplier_request: {
        Args: { p_request_id: string }
        Returns: Json
      }
      create_resident_invited_visitor: {
        Args: {
          p_phone?: string
          p_purpose?: string
          p_vehicle_number?: string
          p_visitor_name: string
          p_visitor_type?: string
        }
        Returns: Json
      }
      deny_visitor: {
        Args: { p_reason: string; p_user_id: string; p_visitor_id: string }
        Returns: Json
      }
      detect_expiring_items: {
        Args: { p_days_ahead?: number }
        Returns: {
          days_left: number
          item_id: string
          item_name: string
          item_type: string
          severity: string
        }[]
      }
      detect_geofence_breaches: { Args: never; Returns: undefined }
      detect_inactive_guards: {
        Args: { p_threshold_minutes?: number }
        Returns: {
          out_alert_created: boolean
          out_guard_id: string
        }[]
      }
      detect_incomplete_checklists:
        | {
            Args: never
            Returns: {
              out_alert_created: boolean
              out_employee_id: string
            }[]
          }
        | {
            Args: {
              p_completion_threshold?: number
              p_only_past_midpoint?: boolean
            }
            Returns: {
              alert_created: boolean
              completed_items: number
              completion_percentage: number
              error_message: string
              guard_id: string
              guard_name: string
              minutes_remaining: number
              shift_name: string
              total_items: number
            }[]
          }
      detect_stationary_guards: { Args: never; Returns: undefined }
      execute_reconciliation_match: {
        Args: { p_reconciliation_id: string; p_user_id: string }
        Returns: Json
      }
      expire_mobile_visitor_decisions: { Args: never; Returns: number }
      force_match_bill: {
        Args: { p_bill_id: string; p_evidence_url?: string; p_reason: string }
        Returns: boolean
      }
      generate_bill_number: { Args: never; Returns: string }
      generate_daily_compliance_snapshot: { Args: never; Returns: Json }
      generate_payroll_cycle: {
        Args: { p_cycle_id: string; p_user_id: string }
        Returns: Json
      }
      get_account_finance_summary: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          outstanding_receivables: number
          overdue_pmt_count: number
          pending_bills_count: number
          today_collections: number
        }[]
      }
      get_active_panic_alerts: {
        Args: never
        Returns: {
          guard_name: string
          id: string
          latitude: number
          longitude: number
          status: string
          triggered_at: string
        }[]
      }
      get_admin_dashboard_summary: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          active_users_count: number
          logins_today: number
          pending_onboarding: number
          system_alerts: number
        }[]
      }
      get_all_companies_health: {
        Args: never
        Returns: {
          active_user_count: number
          company_name: string
          health: string
          id: string
          last_activity_at: string
          location_count: number
        }[]
      }
      get_clocked_in_guards: {
        Args: never
        Returns: {
          employee_id: string
          first_name: string
          guard_code: string
          guard_id: string
          last_name: string
          location_id: string
          shift_id: string
        }[]
      }
      get_employee_id: { Args: never; Returns: string }
      get_employee_ids_in_managed_societies: { Args: never; Returns: string[] }
      get_expiring_chemicals: {
        Args: { p_days_ahead?: number }
        Returns: {
          batch_number: string
          days_left: number
          expiry_date: string
          id: string
          product_id: string
          product_name: string
          severity: string
          source: string
        }[]
      }
      get_guard_checklist_completion: {
        Args: { p_checklist_date: string; p_guard_id: string }
        Returns: {
          completed_items: number
          completion_percentage: number
          last_updated: string
          pending_items: Json
          total_items: number
        }[]
      }
      get_guard_checklist_items: {
        Args: never
        Returns: {
          checklist_id: string
          description: string
          evidence_url: string
          input_type: string
          master_item_id: string
          numeric_max_value: number
          numeric_min_value: number
          numeric_unit_label: string
          overridden_at: string
          overridden_by_name: string
          override_reason: string
          override_status: string
          required_evidence: boolean
          requires_supervisor_override: boolean
          response_value: string
          status: string
          submitted_at: string
          title: string
        }[]
      }
      get_guard_emergency_contacts: {
        Args: never
        Returns: {
          description: string
          id: string
          is_primary: boolean
          label: string
          phone: string
          role: string
        }[]
      }
      get_guard_id: { Args: never; Returns: string }
      get_guard_last_position: {
        Args: { p_guard_id: string }
        Returns: {
          latitude: number
          longitude: number
          minutes_ago: number
          tracked_at: string
        }[]
      }
      get_guard_location_history: {
        Args: { p_guard_id: string; p_hours_back?: number }
        Returns: {
          accuracy_meters: number
          is_within_fence: boolean
          latitude: number
          longitude: number
          recorded_at: string
        }[]
      }
      get_guard_movement_variance: {
        Args: { p_duration_minutes?: number; p_guard_id: string }
        Returns: number
      }
      get_guard_roster: {
        Args: never
        Returns: {
          guard_name: string
          id: string
          last_gps_ping: string
          shift_start: string
          status: string
        }[]
      }
      get_guard_visitors: {
        Args: { p_include_checked_out?: boolean }
        Returns: {
          approval_deadline_at: string
          approval_status: string
          approved_by_resident: boolean
          decision_at: string
          entry_location_name: string
          entry_time: string
          exit_time: string
          flat_id: string
          flat_label: string
          id: string
          is_frequent_visitor: boolean
          phone: string
          photo_url: string
          purpose: string
          rejection_reason: string
          resident_id: string
          resident_name: string
          vehicle_number: string
          visitor_name: string
          visitor_type: string
        }[]
      }
      get_hod_leave_requests: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          employee_name: string
          end_date: string
          id: string
          leave_type: string
          reason: string
          start_date: string
          status: string
        }[]
      }
      get_hod_summary: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          attendance_rate: number
          pending_leave_count: number
          team_size: number
        }[]
      }
      get_hod_team_members: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          attendance_status: string
          designation: string
          id: string
          name: string
        }[]
      }
      get_md_approval_queue: {
        Args: { p_user_id: string }
        Returns: {
          amount: number
          created_at: string
          department: string
          description: string
          id: string
          requested_by: string
          type: string
        }[]
      }
      get_md_executive_summary: {
        Args: { p_user_id: string }
        Returns: {
          active_incidents: number
          headcount: number
          monthly_revenue: number
          pending_approval_count: number
        }[]
      }
      get_mobile_oversight_tickets: {
        Args: never
        Returns: {
          batch_number: string
          category: string
          created_at: string
          evidence_urls: Json
          id: string
          inspection_outcome: string
          location_name: string
          material_issue_type: string
          note: string
          ordered_quantity: number
          parent_ticket_id: string
          received_quantity: number
          return_quantity: number
          severity: string
          shortage_quantity: number
          source_visitor_id: string
          status: string
          subject_name: string
          ticket_number: string
          ticket_type: string
        }[]
      }
      get_my_app_role: { Args: never; Returns: string }
      get_my_managed_societies: { Args: never; Returns: string[] }
      get_next_rtv_number: { Args: never; Returns: string }
      get_oversight_alert_feed: {
        Args: never
        Returns: {
          alert_type: string
          created_at: string
          guard_id: string
          guard_name: string
          id: string
          location_name: string
          note: string
          status: string
        }[]
      }
      get_oversight_attendance_log: {
        Args: never
        Returns: {
          check_in_at: string
          check_out_at: string
          employee_name: string
          geo_status: string
          id: string
          location_name: string
          role_label: string
          status: string
        }[]
      }
      get_oversight_live_guards: {
        Args: never
        Returns: {
          assigned_location_name: string
          checklist_completed: number
          checklist_total: number
          current_shift_label: string
          guard_code: string
          guard_name: string
          id: string
          last_seen_at: string
          latitude: number
          longitude: number
          status: string
          visitors_handled_today: number
        }[]
      }
      get_oversight_visitor_stats: {
        Args: never
        Returns: {
          delivery_vehicles: number
          gate_name: string
          id: string
          pending_approvals: number
          visitors_this_week: number
          visitors_today: number
        }[]
      }
      get_panic_alert_status: { Args: { p_alert_id: string }; Returns: string }
      get_pending_grns: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          grn_number: string
          id: string
          item_count: number
          po_number: string
          received_date: string
          status: string
          supplier_name: string
        }[]
      }
      get_pending_material_delivery_events: {
        Args: never
        Returns: {
          entry_time: string
          gate_name: string
          id: string
          photo_url: string
          purpose: string
          vehicle_number: string
          visitor_name: string
        }[]
      }
      get_qr_batch_statistics: {
        Args: { p_society_id: string }
        Returns: {
          latest_batch_date: string
          linked_qr_codes: number
          total_batches: number
          total_qr_codes: number
          unlinked_qr_codes: number
        }[]
      }
      get_resident_id: { Args: never; Returns: string }
      get_resident_pending_visitors: {
        Args: never
        Returns: {
          approval_deadline_at: string
          approval_status: string
          entry_time: string
          flat_id: string
          flat_label: string
          id: string
          is_frequent_visitor: boolean
          phone: string
          photo_url: string
          purpose: string
          rejection_reason: string
          vehicle_number: string
          visitor_name: string
        }[]
      }
      get_shift_checklist_items: {
        Args: { p_shift_id: string }
        Returns: {
          category: string
          item_id: string
          priority: number
          requires_photo: boolean
          requires_signature: boolean
          task_name: string
        }[]
      }
      get_shift_time_info: {
        Args: { p_shift_id: string }
        Returns: {
          end_time: string
          is_past_midpoint: boolean
          midpoint: string
          minutes_remaining: number
          shift_name: string
          start_time: string
        }[]
      }
      get_site_incidents: {
        Args: never
        Returns: {
          acknowledged: boolean
          id: string
          location: string
          opened_at: string
          severity: string
          type: string
        }[]
      }
      get_site_supervisor_summary: {
        Args: never
        Returns: {
          guards_on_duty: number
          open_incidents: number
        }[]
      }
      get_stock_alerts: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          current_quantity: number
          id: string
          item_name: string
          location_name: string
          min_threshold: number
          severity: string
          unit: string
        }[]
      }
      get_storekeeper_summary: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: {
          low_stock_count: number
          pending_grn_count: number
          total_items: number
        }[]
      }
      get_super_admin_platform_summary: {
        Args: never
        Returns: {
          active_incidents: number
          critical_alert_count: number
          total_active_users: number
          total_companies: number
        }[]
      }
      get_unlinked_qr_codes: {
        Args: { p_limit?: number; p_society_id: string }
        Returns: {
          batch_id: string
          created_at: string
          id: string
          sequence_number: number
        }[]
      }
      get_user_role: {
        Args: never
        Returns: Database["public"]["Enums"]["user_role"]
      }
      has_active_checklist_alert: {
        Args: { p_date: string; p_guard_id: string }
        Returns: boolean
      }
      has_active_inactivity_alert: {
        Args: { p_guard_id: string }
        Returns: boolean
      }
      has_role: { Args: { required_role: string }; Returns: boolean }
      http: {
        Args: { request: Database["public"]["CompositeTypes"]["http_request"] }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "http_request"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_delete:
        | {
            Args: { uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
        | {
            Args: { content: string; content_type: string; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
      http_get:
        | {
            Args: { uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
        | {
            Args: { data: Json; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
      http_head: {
        Args: { uri: string }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "*"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_header: {
        Args: { field: string; value: string }
        Returns: Database["public"]["CompositeTypes"]["http_header"]
        SetofOptions: {
          from: "*"
          to: "http_header"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_list_curlopt: {
        Args: never
        Returns: {
          curlopt: string
          value: string
        }[]
      }
      http_patch: {
        Args: { content: string; content_type: string; uri: string }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "*"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_post:
        | {
            Args: { content: string; content_type: string; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
        | {
            Args: { data: Json; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
      http_put: {
        Args: { content: string; content_type: string; uri: string }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "*"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_reset_curlopt: { Args: never; Returns: boolean }
      http_set_curlopt: {
        Args: { curlopt: string; value: string }
        Returns: boolean
      }
      is_admin: { Args: never; Returns: boolean }
      is_employee: { Args: never; Returns: boolean }
      is_financial_manager: { Args: never; Returns: boolean }
      is_guard: { Args: never; Returns: boolean }
      is_period_closed: { Args: { p_date: string }; Returns: boolean }
      is_resident: { Args: never; Returns: boolean }
      log_gate_entry:
        | {
            Args: {
              p_photo_url: string
              p_po_id: string
              p_signature_url?: string
              p_vehicle_number?: string
            }
            Returns: string
          }
        | {
            Args: {
              p_driver_name?: string
              p_photo_url: string
              p_po_id: string
              p_signature_url?: string
              p_vehicle_number?: string
            }
            Returns: string
          }
        | {
            Args: {
              p_gate_location?: string
              p_notes?: string
              p_photo_url: string
              p_po_id: string
              p_signature_url?: string
              p_vehicle_number?: string
            }
            Returns: string
          }
      log_material_arrival: {
        Args: {
          p_arrival_photo_url: string
          p_arrival_signature_url?: string
          p_gate_location?: string
          p_notes?: string
          p_po_id: string
          p_vehicle_number: string
        }
        Returns: string
      }
      map_leave_type_to_attendance_status: {
        Args: { p_leave_type: string }
        Returns: string
      }
      mobile_insert_notification: {
        Args: {
          p_action_url?: string
          p_body: string
          p_data?: Json
          p_delivery_state?: string
          p_fallback_state?: string
          p_priority?: string
          p_sms_fallback_at?: string
          p_title: string
          p_type: string
          p_user_id: string
        }
        Returns: string
      }
      proc_check_login_blocked: {
        Args: { p_ip: unknown }
        Returns: {
          blocked_until_time: string
          is_blocked: boolean
        }[]
      }
      proc_enqueue_old_photos: { Args: never; Returns: number }
      proc_handle_login_attempt: {
        Args: { p_ip: unknown; p_is_failure?: boolean }
        Returns: {
          blocked_until_time: string
          is_blocked: boolean
          remaining_attempts: number
        }[]
      }
      process_overdue_alerts: { Args: never; Returns: undefined }
      purge_expired_visitor_personal_data: { Args: never; Returns: number }
      record_guard_gps_tracking: {
        Args: {
          p_accuracy_meters?: number
          p_guard_id: string
          p_is_within_fence?: boolean
          p_latitude: number
          p_longitude: number
          p_shift_id?: string
        }
        Returns: string
      }
      reject_leave_request: {
        Args: { p_approver_id: string; p_leave_id: string }
        Returns: undefined
      }
      reject_md_item: {
        Args: { p_approver_id: string; p_item_id: string }
        Returns: undefined
      }
      reopen_guard_checklist: {
        Args: { p_checklist_id?: string; p_guard_id: string; p_reason: string }
        Returns: Json
      }
      resolve_mobile_panic_alert: {
        Args: { p_alert_id: string; p_notes?: string }
        Returns: Json
      }
      resolve_panic_alert: {
        Args: {
          p_alert_id: string
          p_resolution_notes?: string
          p_resolved_by: string
        }
        Returns: boolean
      }
      search_resident_destinations: {
        Args: { p_search?: string }
        Returns: {
          flat_id: string
          flat_label: string
          resident_id: string
          resident_name: string
          resident_phone: string
        }[]
      }
      search_residents: {
        Args: { p_query: string; p_society_id?: string }
        Returns: {
          flat_number: string
          full_name: string
          id: string
          is_owner: boolean
          masked_phone: string
          move_in_date: string
          profile_photo_url: string
        }[]
      }
      send_custom_sms: {
        Args: { p_message: string; p_phone_number: string }
        Returns: Json
      }
      send_panic_alert_sms: {
        Args: {
          p_alert_type: string
          p_guard_name: string
          p_guard_phone?: string
          p_latitude?: number
          p_longitude?: number
          p_manager_phone?: string
        }
        Returns: Json
      }
      send_push_notification_to_manager: {
        Args: {
          p_alert_type: string
          p_guard_name: string
          p_latitude?: number
          p_longitude?: number
        }
        Returns: Json
      }
      service_request_can_bridge_to_bill_generated: {
        Args: { p_request_id: string }
        Returns: boolean
      }
      set_resident_frequent_visitor: {
        Args: { p_is_frequent: boolean; p_visitor_id: string }
        Returns: Json
      }
      start_mobile_panic_alert: {
        Args: {
          p_alert_type?: string
          p_description?: string
          p_latitude?: number
          p_longitude?: number
          p_metadata?: Json
          p_photo_url?: string
        }
        Returns: Json
      }
      start_service_task: {
        Args: { p_before_photo_url?: string; p_request_id: string }
        Returns: boolean
      }
      submit_mobile_guard_checklist: {
        Args: {
          p_checklist_id: string
          p_is_complete?: boolean
          p_responses: Json
        }
        Returns: Json
      }
      supplier_transition_service_po_status: {
        Args: {
          p_grade_verified?: boolean
          p_headcount_expected?: number
          p_new_status: string
          p_notes?: string
          p_spo_id: string
        }
        Returns: Json
      }
      sync_leave_application_attendance: {
        Args: { p_leave_application_id: string }
        Returns: undefined
      }
      text_to_bytea: { Args: { data: string }; Returns: string }
      transition_po_status: {
        Args: {
          p_dispatch_notes?: string
          p_dispatched_at?: string
          p_new_status: string
          p_po_id: string
          p_user_id?: string
          p_vehicle_details?: string
        }
        Returns: Json
      }
      trigger_checklist_check: { Args: never; Returns: undefined }
      trigger_daily_mobile_checklist_reminders: {
        Args: never
        Returns: undefined
      }
      trigger_inactivity_check: { Args: never; Returns: undefined }
      trigger_mobile_notification_queue: { Args: never; Returns: undefined }
      trigger_panic_alert: {
        Args: {
          p_guard_id: string
          p_latitude: number
          p_longitude: number
          p_shift_id?: string
        }
        Returns: string
      }
      trigger_shift_end_checklist_reminder: { Args: never; Returns: undefined }
      update_oversight_ticket_status: {
        Args: {
          p_resolution_notes?: string
          p_status: string
          p_ticket_id: string
        }
        Returns: Json
      }
      update_panic_alert_location: {
        Args: {
          p_alert_id: string
          p_captured_at?: string
          p_latitude: number
          p_longitude: number
        }
        Returns: boolean
      }
      update_po_receipt_status: {
        Args: { p_po_id: string; p_user_id: string }
        Returns: Json
      }
      upsert_employee_salary_component: {
        Args: {
          p_amount: number
          p_component_id: string
          p_effective_from: string
          p_employee_id: string
          p_notes?: string
        }
        Returns: string
      }
      upsert_push_token: {
        Args: { p_device_type?: string; p_token: string; p_token_type?: string }
        Returns: string
      }
      urlencode:
        | { Args: { data: Json }; Returns: string }
        | {
            Args: { string: string }
            Returns: {
              error: true
            } & "Could not choose the best candidate function between: public.urlencode(string => bytea), public.urlencode(string => varchar). Try renaming the parameters or the function itself in the database so function overloading can be resolved"
          }
        | {
            Args: { string: string }
            Returns: {
              error: true
            } & "Could not choose the best candidate function between: public.urlencode(string => bytea), public.urlencode(string => varchar). Try renaming the parameters or the function itself in the database so function overloading can be resolved"
          }
      validate_bill_for_payout: {
        Args: { p_bill_id: string }
        Returns: {
          bill_total: number
          grn_total: number
          is_valid: boolean
          match_status: string
          message: string
          po_total: number
        }[]
      }
      validate_indent_rate: { Args: { p_indent_id: string }; Returns: boolean }
    }
    Enums: {
      alert_type:
        | "panic"
        | "inactivity"
        | "geo_fence_breach"
        | "checklist_incomplete"
        | "routine"
      asset_status:
        | "functional"
        | "under_maintenance"
        | "faulty"
        | "decommissioned"
      behavior_category:
        | "sleeping_on_duty"
        | "rudeness"
        | "absence"
        | "uniform_issue"
        | "unauthorized_entry"
        | "late_arrival"
        | "mobile_use"
        | "other"
      budget_status: "draft" | "active" | "exhausted" | "expired"
      candidate_status:
        | "screening"
        | "interviewing"
        | "background_check"
        | "offered"
        | "hired"
        | "rejected"
      document_status:
        | "pending_upload"
        | "pending_review"
        | "verified"
        | "expired"
        | "rejected"
      document_type:
        | "aadhar_card"
        | "pan_card"
        | "passport"
        | "driving_license"
        | "voter_id"
        | "bank_passbook"
        | "education_certificate"
        | "experience_certificate"
        | "offer_letter"
        | "relieving_letter"
        | "address_proof"
        | "police_verification"
        | "medical_certificate"
        | "other"
        | "psara_license"
        | "id_proof"
      financial_period_status: "open" | "closing" | "closed"
      financial_period_type: "monthly" | "quarterly" | "yearly"
      grn_item_quality_status: "accepted" | "rejected" | "partial"
      grn_status:
        | "draft"
        | "inspecting"
        | "accepted"
        | "partial_accepted"
        | "rejected"
      guard_grade: "A" | "B" | "C" | "D"
      indent_status:
        | "draft"
        | "pending_approval"
        | "approved"
        | "rejected"
        | "po_created"
        | "cancelled"
      job_session_status: "started" | "paused" | "completed" | "cancelled"
      leave_type_enum:
        | "sick_leave"
        | "casual_leave"
        | "paid_leave"
        | "unpaid_leave"
        | "emergency_leave"
      maintenance_frequency:
        | "daily"
        | "weekly"
        | "monthly"
        | "quarterly"
        | "half_yearly"
        | "yearly"
      material_condition:
        | "good"
        | "damaged"
        | "expired"
        | "leaking"
        | "defective"
      payment_gateway: "razorpay" | "stripe" | "paypal" | "manual"
      payroll_cycle_status:
        | "draft"
        | "processing"
        | "computed"
        | "approved"
        | "disbursed"
        | "cancelled"
      payslip_status:
        | "draft"
        | "computed"
        | "approved"
        | "processed"
        | "disputed"
      po_status:
        | "draft"
        | "sent_to_vendor"
        | "acknowledged"
        | "partial_received"
        | "received"
        | "cancelled"
        | "dispatched"
      reconciliation_status:
        | "pending"
        | "matched"
        | "discrepancy"
        | "resolved"
        | "disputed"
      request_status:
        | "pending"
        | "accepted"
        | "rejected"
        | "indent_generated"
        | "indent_forwarded"
        | "indent_accepted"
        | "indent_rejected"
        | "po_issued"
        | "po_received"
        | "po_dispatched"
        | "material_received"
        | "material_acknowledged"
        | "bill_generated"
        | "paid"
        | "feedback_pending"
        | "completed"
        | "cancelled"
      service_category:
        | "security_services"
        | "ac_services"
        | "plantation_services"
        | "printing_advertising"
        | "pest_control"
        | "housekeeping"
        | "pantry_services"
        | "general_maintenance"
      service_priority: "low" | "normal" | "high" | "urgent"
      service_request_status:
        | "open"
        | "assigned"
        | "in_progress"
        | "on_hold"
        | "completed"
        | "cancelled"
        | "closed"
      ticket_type: "quality_check" | "quantity_check" | "material_return"
      user_role:
        | "admin"
        | "company_md"
        | "company_hod"
        | "account"
        | "delivery_boy"
        | "buyer"
        | "supplier"
        | "vendor"
        | "security_guard"
        | "security_supervisor"
        | "society_manager"
        | "service_boy"
        | "super_admin"
        | "ac_technician"
        | "pest_control_technician"
        | "storekeeper"
        | "site_supervisor"
        | "resident"
        | "delivery_agent"
        | "field_technician"
    }
    CompositeTypes: {
      http_header: {
        field: string | null
        value: string | null
      }
      http_request: {
        method: unknown
        uri: string | null
        headers: Database["public"]["CompositeTypes"]["http_header"][] | null
        content_type: string | null
        content: string | null
      }
      http_response: {
        status: number | null
        content_type: string | null
        headers: Database["public"]["CompositeTypes"]["http_header"][] | null
        content: string | null
      }
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      alert_type: [
        "panic",
        "inactivity",
        "geo_fence_breach",
        "checklist_incomplete",
        "routine",
      ],
      asset_status: [
        "functional",
        "under_maintenance",
        "faulty",
        "decommissioned",
      ],
      behavior_category: [
        "sleeping_on_duty",
        "rudeness",
        "absence",
        "uniform_issue",
        "unauthorized_entry",
        "late_arrival",
        "mobile_use",
        "other",
      ],
      budget_status: ["draft", "active", "exhausted", "expired"],
      candidate_status: [
        "screening",
        "interviewing",
        "background_check",
        "offered",
        "hired",
        "rejected",
      ],
      document_status: [
        "pending_upload",
        "pending_review",
        "verified",
        "expired",
        "rejected",
      ],
      document_type: [
        "aadhar_card",
        "pan_card",
        "passport",
        "driving_license",
        "voter_id",
        "bank_passbook",
        "education_certificate",
        "experience_certificate",
        "offer_letter",
        "relieving_letter",
        "address_proof",
        "police_verification",
        "medical_certificate",
        "other",
        "psara_license",
        "id_proof",
      ],
      financial_period_status: ["open", "closing", "closed"],
      financial_period_type: ["monthly", "quarterly", "yearly"],
      grn_item_quality_status: ["accepted", "rejected", "partial"],
      grn_status: [
        "draft",
        "inspecting",
        "accepted",
        "partial_accepted",
        "rejected",
      ],
      guard_grade: ["A", "B", "C", "D"],
      indent_status: [
        "draft",
        "pending_approval",
        "approved",
        "rejected",
        "po_created",
        "cancelled",
      ],
      job_session_status: ["started", "paused", "completed", "cancelled"],
      leave_type_enum: [
        "sick_leave",
        "casual_leave",
        "paid_leave",
        "unpaid_leave",
        "emergency_leave",
      ],
      maintenance_frequency: [
        "daily",
        "weekly",
        "monthly",
        "quarterly",
        "half_yearly",
        "yearly",
      ],
      material_condition: [
        "good",
        "damaged",
        "expired",
        "leaking",
        "defective",
      ],
      payment_gateway: ["razorpay", "stripe", "paypal", "manual"],
      payroll_cycle_status: [
        "draft",
        "processing",
        "computed",
        "approved",
        "disbursed",
        "cancelled",
      ],
      payslip_status: [
        "draft",
        "computed",
        "approved",
        "processed",
        "disputed",
      ],
      po_status: [
        "draft",
        "sent_to_vendor",
        "acknowledged",
        "partial_received",
        "received",
        "cancelled",
        "dispatched",
      ],
      reconciliation_status: [
        "pending",
        "matched",
        "discrepancy",
        "resolved",
        "disputed",
      ],
      request_status: [
        "pending",
        "accepted",
        "rejected",
        "indent_generated",
        "indent_forwarded",
        "indent_accepted",
        "indent_rejected",
        "po_issued",
        "po_received",
        "po_dispatched",
        "material_received",
        "material_acknowledged",
        "bill_generated",
        "paid",
        "feedback_pending",
        "completed",
        "cancelled",
      ],
      service_category: [
        "security_services",
        "ac_services",
        "plantation_services",
        "printing_advertising",
        "pest_control",
        "housekeeping",
        "pantry_services",
        "general_maintenance",
      ],
      service_priority: ["low", "normal", "high", "urgent"],
      service_request_status: [
        "open",
        "assigned",
        "in_progress",
        "on_hold",
        "completed",
        "cancelled",
        "closed",
      ],
      ticket_type: ["quality_check", "quantity_check", "material_return"],
      user_role: [
        "admin",
        "company_md",
        "company_hod",
        "account",
        "delivery_boy",
        "buyer",
        "supplier",
        "vendor",
        "security_guard",
        "security_supervisor",
        "society_manager",
        "service_boy",
        "super_admin",
        "ac_technician",
        "pest_control_technician",
        "storekeeper",
        "site_supervisor",
        "resident",
        "delivery_agent",
        "field_technician",
      ],
    },
  },
} as const

