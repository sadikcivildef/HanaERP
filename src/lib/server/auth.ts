// lib/server/auth.ts
import { betterAuth } from 'better-auth/minimal';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';
import { sveltekitCookies } from 'better-auth/svelte-kit';
import { env } from '$env/dynamic/private';
import { getRequestEvent } from '$app/server';
import { db } from '$lib/server/db';

export const auth = betterAuth({
	baseURL: env.ORIGIN,
	secret: env.BETTER_AUTH_SECRET,
	database: drizzleAdapter(db, { provider: 'pg' }),
	user: {
    additionalFields: {
      companyId: {
        type: "number",           // or "string" if you use text/uuid
        required: false,          // or true if you want to force it
        // You can add more metadata if using better-auth-ui or similar
        // label: "Company ID",
        // placeholder: "Enter company ID",
      },
    },
  },
	emailAndPassword: { enabled: true },
	plugins: [sveltekitCookies(getRequestEvent)] // make sure this is the last plugin in the array
	// make sure this is the last plugin in the array
});
