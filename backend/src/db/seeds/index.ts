import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import { runLookupSeeds } from './01-lookups.seed';
import { runSystemSettingsSeeds } from './02-system-settings.seed';

dotenv.config();

async function main(): Promise<void> {
  if (!process.env.DATABASE_URL) {
    throw new Error('DATABASE_URL environment variable is required');
  }

  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
  const db: NodePgDatabase<Record<string, never>> = drizzle(pool);

  console.info('Starting database seeding...');

  await runLookupSeeds(db);
  await runSystemSettingsSeeds(db);

  console.info('\nAll seeds completed successfully.');
  await pool.end();
}

main().catch((err: Error) => {
  console.error('Seeding failed:', err.message);
  process.exit(1);
});
