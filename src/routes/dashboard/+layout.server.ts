// src/routes/dashboard/+layout.server.ts
import { redirect } from "@sveltejs/kit";
import type { LayoutServerLoad } from "./$types";
import { db } from "$lib/server/db";
import { company } from "$lib/server/db/schema";
import { eq } from "drizzle-orm";



export const load: LayoutServerLoad = async (event) => {
    if (!event.locals.user) {
        return redirect(302, '/login');
    }

    let companyName = null;
    
    // Fetch company name if user has a companyId
    if (event.locals.user.companyId) {
        try {
            const userCompany = await db.query.company.findFirst({
                where: eq(company.id, event.locals.user.companyId),
                columns: {
                    id: true,
                    name: true,
                    code: true,
                }
            });
            
            companyName = userCompany?.name || null;
        } catch (error) {
            console.error("Failed to fetch company:", error);
            // Don't redirect on error, just log it
        }
    }
    
    return { 
        user: event.locals.user,
        companyName: companyName
    };
};