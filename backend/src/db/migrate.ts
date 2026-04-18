import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config();

async function enableExtensions(pool: Pool): Promise<void> {
  const client = await pool.connect();
  try {
    console.info('Enabling PostgreSQL extensions...');

    // Required for gen_random_uuid() and crypt()
    await client.query(`CREATE EXTENSION IF NOT EXISTS pgcrypto;`);
    console.info('  ✓ pgcrypto');

    // Required for GIN trigram text indexes
    await client.query(`CREATE EXTENSION IF NOT EXISTS pg_trgm;`);
    console.info('  ✓ pg_trgm');

    // pgvector: optional — required only when AI embedding features are active.
    // Install via: apt-get install postgresql-16-pgvector  (Debian)
    //              brew install pgvector                   (macOS)
    try {
      await client.query(`CREATE EXTENSION IF NOT EXISTS vector;`);
      console.info('  ✓ vector (pgvector)');
    } catch {
      console.warn('  ⚠ vector (pgvector) not installed — AI embedding column will be skipped.');
    }
  } finally {
    client.release();
  }
}

async function main(): Promise<void> {
  if (!process.env.DATABASE_URL) {
    throw new Error('DATABASE_URL environment variable is required');
  }

  const pool = new Pool({ connectionString: process.env.DATABASE_URL });

  await enableExtensions(pool);

  const db = drizzle(pool);

  console.info('Running database migrations...');

  await migrate(db, {
    migrationsFolder: path.join(__dirname, 'migrations'),
  });

  console.info('All migrations completed successfully.');
  await pool.end();
}

main().catch((err: Error) => {
  console.error('Migration failed:', err.message);
  process.exit(1);
});
