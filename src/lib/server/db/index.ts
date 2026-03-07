import { drizzle } from 'drizzle-orm/neon-http';
import { neon } from '@neondatabase/serverless';
import * as schema from './schema';
import { env } from '$env/dynamic/private';
import { dev } from '$app/environment';

// 1. Check SvelteKit's env, then fallback to process.env (for CLI tools), 
// then fallback to Bun's global Bun.env
const DATABASE_URL = env?.DATABASE_URL || process.env.DATABASE_URL || Bun.env.DATABASE_URL;

if (!DATABASE_URL) {
	throw new Error('DATABASE_URL is not set');
}

const client = neon(DATABASE_URL);

export const db = drizzle(client, { schema });