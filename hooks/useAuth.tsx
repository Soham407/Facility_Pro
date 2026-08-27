"use client";

import React, { useState, useEffect, createContext, useContext } from "react";
import type { User } from "@supabase/supabase-js";
import { useRouter } from "next/navigation";

import { mapAuthSessionProfile, type AuthUserRoleRow } from "@/src/lib/auth/authTransforms";
import { supabase } from "@/src/lib/supabaseClient";
import { type AppRole } from "@/src/lib/auth/roles";

interface AuthContextType {
  user: User | null;
  userId: string | null;
  role: AppRole | null;
  permissions: string[];
  isActive: boolean;
  isLoading: boolean;
  signIn: (email: string, password: string) => Promise<{ user: User | null; error: Error | null; roleName: string | null; mustChangePassword: boolean }>;
  updatePassword: (password: string) => Promise<{ error: string | null }>;
  getAuthUser: () => Promise<{ user: User | null; roleName: string | null; mustChangePassword: boolean }>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [role, setRole] = useState<AppRole | null>(null);
  const [permissions, setPermissions] = useState<string[]>([]);
  const [isActive, setIsActive] = useState(true);
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    supabase.auth.getUser().then(({ data: { user } }) => {
      if (user) {
        setUser(user);
        fetchUserRole(user.id);
      } else {
        resetState();
      }
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        setUser(session.user);
        fetchUserRole(session.user.id);
      } else {
        resetState();
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  const resetState = () => {
    setUser(null);
    setRole(null);
    setPermissions([]);
    setIsActive(true);
    setIsLoading(false);
  };

  const fetchUserRole = async (userId: string) => {
    try {
      const { data, error } = await supabase
        .from("users")
        .select("is_active, roles!inner(role_name, permissions)")
        .eq("id", userId)
        .single();

      if (error) throw error;

      const profile = mapAuthSessionProfile(data as AuthUserRoleRow);
      setRole(profile.role as AppRole | null);
      setPermissions(profile.permissions);
      setIsActive(profile.isActive);
    } catch (error) {
      console.error("Error fetching user role:", error);
      setRole(null);
      setPermissions([]);
      setIsActive(false);
    } finally {
      setIsLoading(false);
    }
  };

  const signOut = async () => {
    setUser(null);
    setRole(null);
    setPermissions([]);
    setIsActive(true);

    try {
      await supabase.auth.signOut();
    } catch (error) {
      console.error("Sign out error:", error);
    }

    router.refresh();
  };

  const getAuthUser = async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { user: null, roleName: null, mustChangePassword: false };

    const { data: userData } = await supabase
      .from("users")
      .select("roles(role_name), must_change_password")
      .eq("id", user.id)
      .single();

    const roleRecord = Array.isArray((userData as any)?.roles)
      ? (userData as any)?.roles[0]
      : (userData as any)?.roles;

    return { 
      user, 
      roleName: roleRecord?.role_name ?? null, 
      mustChangePassword: !!(userData as any)?.must_change_password 
    };
  };

  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error || !data.user) {
      return { user: null, error, roleName: null, mustChangePassword: false };
    }

    const authData = await getAuthUser();
    return { ...authData, error: null };
  };

  const updatePassword = async (newPassword: string) => {
    const res = await fetch("/api/users/change-password", {
      method: "POST",
      credentials: "include",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ new_password: newPassword }),
    });

    if (!res.ok) {
      const result = await res.json();
      return { error: result.error || "Failed to change password." };
    }
    return { error: null };
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        userId: user?.id ?? null,
        role,
        permissions,
        isActive,
        isLoading,
        signIn,
        updatePassword,
        getAuthUser,
        signOut,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}
