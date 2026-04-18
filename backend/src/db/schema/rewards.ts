import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  integer,
  timestamp,
  date,
  index,
  unique,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { pointsTransactionTypes, rewardActionTypes } from './lookups';
import { users } from './users';

// 8.1 user_points_summary
export const userPointsSummary = pgTable('user_points_summary', {
  userId: uuid('user_id')
    .primaryKey()
    .references(() => users.id, { onDelete: 'cascade' }),
  pointsBalance: integer('points_balance').notNull().default(0),
  totalEarned: integer('total_earned').notNull().default(0),
  totalRedeemed: integer('total_redeemed').notNull().default(0),
  totalExpired: integer('total_expired').notNull().default(0),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

// 8.2 points_ledger
export const pointsLedger = pgTable(
  'points_ledger',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id),
    transactionTypeId: smallint('transaction_type_id')
      .notNull()
      .references(() => pointsTransactionTypes.id),
    rewardActionTypeId: smallint('reward_action_type_id').references(() => rewardActionTypes.id),
    points: integer('points').notNull(),
    balanceAfter: integer('balance_after').notNull(),
    referenceId: uuid('reference_id'),
    referenceType: varchar('reference_type', { length: 30 }),
    expiresAt: timestamp('expires_at', { withTimezone: true }),
    notes: text('notes'),
    createdBy: uuid('created_by').references(() => users.id),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_points_ledger_user_id').on(t.userId),
    index('idx_points_ledger_expires_at')
      .on(t.expiresAt)
      .where(sql`expires_at IS NOT NULL`),
    index('idx_points_ledger_reference').on(t.referenceType, t.referenceId),
  ],
);

export type PointsLedgerEntry = typeof pointsLedger.$inferSelect;
export type NewPointsLedgerEntry = typeof pointsLedger.$inferInsert;

// 8.3 milestone_definitions
export const milestoneDefinitions = pgTable('milestone_definitions', {
  id: uuid('id').primaryKey().defaultRandom(),
  nameEn: varchar('name_en', { length: 100 }).notNull(),
  nameAr: varchar('name_ar', { length: 100 }),
  requiredBookingsPerMonth: smallint('required_bookings_per_month').notNull(),
  bonusPoints: integer('bonus_points').notNull(),
  badgeName: varchar('badge_name', { length: 60 }),
  badgeIconUrl: text('badge_icon_url'),
  isActive: boolean('is_active').notNull().default(true),
  sortOrder: smallint('sort_order').notNull().default(0),
  createdBy: uuid('created_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

// 8.4 user_milestone_achievements
export const userMilestoneAchievements = pgTable(
  'user_milestone_achievements',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    milestoneId: uuid('milestone_id')
      .notNull()
      .references(() => milestoneDefinitions.id),
    achievementMonth: date('achievement_month').notNull(),
    bookingsCount: smallint('bookings_count').notNull(),
    pointsAwarded: integer('points_awarded').notNull(),
    pointsLedgerId: uuid('points_ledger_id')
      .notNull()
      .references(() => pointsLedger.id),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_milestone_achievement').on(t.userId, t.milestoneId, t.achievementMonth)],
);
