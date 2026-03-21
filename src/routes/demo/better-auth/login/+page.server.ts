// src/routes/demo/better-auth/login/+page.server.ts
import { fail, redirect } from "@sveltejs/kit";
import type { Actions, PageServerLoad } from "./$types";
import { auth } from "$lib/server/auth";
import { APIError } from "better-auth/api";
import { db } from "$lib/server/db";
import { eq } from "drizzle-orm";
import { user, company } from "$lib/server/db/schema";

export const load: PageServerLoad = async ({ locals }) => {
  if (locals.user) {
    return redirect(302, "/demo/better-auth");
  }
  return {};
};

export const actions: Actions = {
  signInEmail: async ({ request }) => {
    const formData = await request.formData();
    const email = formData.get("email")?.toString() ?? "";
    const password = formData.get("password")?.toString() ?? "";

    try {
      await auth.api.signInEmail({
        body: {
          email,
          password,
          callbackURL: "/auth/verification-success",
        },
      });
    } catch (error) {
      if (error instanceof APIError) {
        return fail(400, { message: error.message || "Sign in failed" });
      }
      console.error("Sign-in error:", error);
      return fail(500, { message: "Unexpected error during sign in" });
    }

    return redirect(302, "/demo/better-auth");
  },

  signUpEmail: async ({ request }) => {
    const formData = await request.formData();
    const email = formData.get("email")?.toString() ?? "";
    const password = formData.get("password")?.toString() ?? "";
    const name = formData.get("name")?.toString() ?? "";
    const companyId = formData.get("companyId")?.toString() ?? "";

    let createdUserId: string | undefined;

    try {
      const signUpResult = await auth.api.signUpEmail({
        body: {
          email,
          password,
          name,
          companyId: companyId ? parseInt(companyId) : undefined,
          callbackURL: "/auth/verification-success",
        },
      });

      // ── Correct access: always go through .user ───────────────────────
      createdUserId = signUpResult.user.id;

      // Safety check (should rarely hit, but good to have)
      if (!createdUserId) {
        console.error("Sign-up response missing user.id:", signUpResult);
        throw new Error("User created but no user ID was returned");
      }

      // Optional: log once during development (remove/comment later)
      // console.log("signUpResult:", JSON.stringify(signUpResult, null, 2));
    } catch (error) {
      if (error instanceof APIError) {
        return fail(400, { message: error.message || "Registration failed" });
      }
      console.error("Sign-up error:", error);
      return fail(500, { message: "Unexpected error during registration" });
    }

    // ───────────────────────────────────────────────────────────────
    // Create default company and link user to it
    // ───────────────────────────────────────────────────────────────
    try {
      await db.transaction(async (tx) => {
        const [newCompany] = await tx
          .insert(company)
          .values({
            name: name ? `${name}'s Company` : "My Company",
            code: `comp-${createdUserId!.slice(0, 8)}`,
            // optional defaults
            // email: email,
            // timezone: "Asia/Dhaka",
            // country: "Bangladesh",
          })
          .returning({ id: company.id });

        await tx
          .update(user)
          .set({ companyId: newCompany.id })
          .where(eq(user.id, createdUserId!));
      });
    } catch (txError) {
      console.error("Failed to create/link company:", txError);
      // Optional cleanup (uncomment if you want to delete orphan user)
      // await db.delete(user).where(eq(user.id, createdUserId!));
    }

    return redirect(302, "/demo/better-auth");
  },
};