import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  numeric,
  timestamp,
} from 'drizzle-orm/pg-core';
import { subscriptionPlanTypes } from './lookups';
import { users } from './users';
import { venues } from './venues';
import { payments } from './payments';

// 18.1 system_settings
export const systemSettings = pgTable('system_settings', {
  key: varchar('key', { length: 80 }).primaryKey(),
  value: text('value').notNull(),
  valueType: varchar('value_type', { length: 10 }).notNull(),
  description: text('description').notNull(),
  category: varchar('category', { length: 40 }).notNull(),
  updatedBy: uuid('updated_by').references(() => users.id),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export type SystemSetting = typeof systemSettings.$inferSelect;
export type NewSystemSetting = typeof systemSettings.$inferInsert;

// 18.2 owner_subscriptions
export const ownerSubscriptions = pgTable('owner_subscriptions', {
  id: uuid('id').primaryKey().defaultRandom(),
  ownerId: uuid('owner_id')
    .notNull()
    .references(() => users.id),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id),
  planId: smallint('plan_id')
    .notNull()
    .references(() => subscriptionPlanTypes.id),
  startedAt: timestamp('started_at', { withTimezone: true }).notNull(),
  expiresAt: timestamp('expires_at', { withTimezone: true }),
  billingCycleDays: smallint('billing_cycle_days').notNull().default(30),
  amountPaid: numeric('amount_paid', { precision: 10, scale: 2 }).notNull().default('0'),
  paymentId: uuid('payment_id').references(() => payments.id),
  autoRenew: boolean('auto_renew').notNull().default(true),
  cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 18.3 commission_rates
export const commissionRates = pgTable('commission_rates', {
  id: uuid('id').primaryKey().defaultRandom(),
  planId: smallint('plan_id').references(() => subscriptionPlanTypes.id),
  ownerId: uuid('owner_id').references(() => users.id),
  ratePercent: numeric('rate_percent', { precision: 5, scale: 2 }).notNull(),
  validFrom: timestamp('valid_from', { withTimezone: true }).notNull(),
  validUntil: timestamp('valid_until', { withTimezone: true }),
  notes: text('notes'),
  createdBy: uuid('created_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
