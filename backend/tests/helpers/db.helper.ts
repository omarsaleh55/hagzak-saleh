import { Pool } from 'pg';
import * as dotenv from 'dotenv';
dotenv.config();

export const testPool = new Pool({ connectionString: process.env.DATABASE_URL });

/**
 * Ensures the minimum lookup rows required by FK constraints on the users table
 * exist before tests run. Uses ON CONFLICT DO NOTHING so it is safe to call
 * multiple times and works whether or not db:seed has already been run.
 */
export async function setupTestTable(): Promise<void> {
  await testPool.query(`
    INSERT INTO user_roles (id, code)
      VALUES (1, 'player'), (2, 'owner'), (3, 'admin')
      ON CONFLICT DO NOTHING;

    INSERT INTO account_statuses (id, code)
      VALUES (1, 'active'), (2, 'suspended'), (3, 'banned')
      ON CONFLICT DO NOTHING;

    INSERT INTO languages (id, code, name)
      VALUES (1, 'ar', 'Arabic'), (2, 'en', 'English')
      ON CONFLICT DO NOTHING;
  `);
}

export async function clearUsersTable(): Promise<void> {
  await testPool.query('DELETE FROM users');
}

export async function teardownTestDB(): Promise<void> {
  await testPool.end();
}
