import { pgTable, uuid, varchar, timestamp } from 'drizzle-orm/pg-core';
import { users } from './users';
import { bookings } from './bookings';
import { pointsLedger } from './rewards';

// 8.5 referrals
export const referrals = pgTable('referrals', {
  id: uuid('id').primaryKey().defaultRandom(),
  referrerUserId: uuid('referrer_user_id')
    .notNull()
    .references(() => users.id),
  referredUserId: uuid('referred_user_id')
    .notNull()
    .unique()
    .references(() => users.id),
  referralCodeUsed: varchar('referral_code_used', { length: 20 }).notNull(),
  status: varchar('status', { length: 20 }).notNull().default('pending'),
  firstBookingId: uuid('first_booking_id').references(() => bookings.id),
  rewardGrantedAt: timestamp('reward_granted_at', { withTimezone: true }),
  referrerPointsLedgerId: uuid('referrer_points_ledger_id').references(() => pointsLedger.id),
  referredPointsLedgerId: uuid('referred_points_ledger_id').references(() => pointsLedger.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export type Referral = typeof referrals.$inferSelect;
export type NewReferral = typeof referrals.$inferInsert;
