import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import { config } from './index';
import * as schema from '../db/schema';

export const pool = new Pool({ connectionString: config.db.url });
export const db = drizzle(pool, { schema });

export async function connectDatabase(): Promise<void> {
  const client = await pool.connect();
  const result = await client.query<{ version: string }>('SELECT version()');
  client.release();
  console.info(`✔ Database connected — ${result.rows[0].version}`);
}
