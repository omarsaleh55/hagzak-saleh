import { nanoid } from 'nanoid';
import { eq } from 'drizzle-orm';
import { db } from '../../db';
import { users } from '../../db/schema';

export async function generateUniqueReferralCode(): Promise<string> {
  for (let attempt = 0; attempt < 5; attempt++) {
    const code = nanoid(8).toUpperCase();
    const existing = await db.query.users.findFirst({ where: eq(users.referralCode, code) });
    if (!existing) return code;
  }
  throw new Error('Failed to generate unique referral code after 5 attempts');
}
