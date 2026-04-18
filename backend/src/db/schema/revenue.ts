import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  integer,
  numeric,
  timestamp,
  date,
  index,
} from 'drizzle-orm/pg-core';
import { users } from './users';
import { venues } from './venues';
import { bookings } from './bookings';
import { payments } from './payments';
import { ownerSubscriptions } from './system';

// 25.2 payout_batches (defined first so owner_payouts can reference it)
export const payoutBatches = pgTable('payout_batches', {
  id: uuid('id').primaryKey().defaultRandom(),
  ownerId: uuid('owner_id')
    .notNull()
    .references(() => users.id),
  periodStart: date('period_start').notNull(),
  periodEnd: date('period_end').notNull(),
  totalGross: numeric('total_gross', { precision: 12, scale: 2 }).notNull(),
  totalCommission: numeric('total_commission', { precision: 10, scale: 2 }).notNull(),
  totalNet: numeric('total_net', { precision: 12, scale: 2 }).notNull(),
  payoutCount: integer('payout_count').notNull(),
  status: varchar('status', { length: 20 }).notNull().default('draft'),
  approvedBy: uuid('approved_by').references(() => users.id),
  approvedAt: timestamp('approved_at', { withTimezone: true }),
  paidAt: timestamp('paid_at', { withTimezone: true }),
  externalReference: varchar('external_reference', { length: 200 }),
  createdBy: uuid('created_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 25.1 owner_payouts
export const ownerPayouts = pgTable(
  'owner_payouts',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    ownerId: uuid('owner_id')
      .notNull()
      .references(() => users.id),
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id),
    bookingId: uuid('booking_id')
      .notNull()
      .unique()
      .references(() => bookings.id),
    paymentId: uuid('payment_id')
      .notNull()
      .references(() => payments.id),
    grossAmount: numeric('gross_amount', { precision: 10, scale: 2 }).notNull(),
    platformCommission: numeric('platform_commission', { precision: 8, scale: 2 }).notNull(),
    commissionRatePercent: numeric('commission_rate_percent', { precision: 5, scale: 2 }).notNull(),
    cashSurchargeRetained: numeric('cash_surcharge_retained', { precision: 8, scale: 2 })
      .notNull()
      .default('0'),
    netAmount: numeric('net_amount', { precision: 10, scale: 2 }).notNull(),
    status: varchar('status', { length: 20 }).notNull().default('pending'),
    payoutMethod: varchar('payout_method', { length: 40 }),
    payoutReference: varchar('payout_reference', { length: 200 }),
    payoutBatchId: uuid('payout_batch_id').references(() => payoutBatches.id),
    paidAt: timestamp('paid_at', { withTimezone: true }),
    cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
    notes: text('notes'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_owner_payouts_owner_id').on(t.ownerId, t.status),
    index('idx_owner_payouts_booking_id').on(t.bookingId),
    index('idx_owner_payouts_batch_id').on(t.payoutBatchId),
  ],
);

// 25.3 featured_venue_purchases
export const featuredVenuePurchases = pgTable('featured_venue_purchases', {
  id: uuid('id').primaryKey().defaultRandom(),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id),
  ownerId: uuid('owner_id')
    .notNull()
    .references(() => users.id),
  paymentId: uuid('payment_id')
    .notNull()
    .unique()
    .references(() => payments.id),
  amountPaid: numeric('amount_paid', { precision: 8, scale: 2 }).notNull(),
  durationDays: smallint('duration_days').notNull(),
  startsAt: timestamp('starts_at', { withTimezone: true }).notNull(),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  isActive: boolean('is_active').notNull().default(true),
  cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
  cancelledBy: uuid('cancelled_by').references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 25.4 subscription_invoices
export const subscriptionInvoices = pgTable('subscription_invoices', {
  id: uuid('id').primaryKey().defaultRandom(),
  subscriptionId: uuid('subscription_id')
    .notNull()
    .references(() => ownerSubscriptions.id),
  ownerId: uuid('owner_id')
    .notNull()
    .references(() => users.id),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id),
  billingPeriodStart: date('billing_period_start').notNull(),
  billingPeriodEnd: date('billing_period_end').notNull(),
  amount: numeric('amount', { precision: 10, scale: 2 }).notNull(),
  status: varchar('status', { length: 20 }).notNull().default('pending'),
  paymentId: uuid('payment_id').references(() => payments.id),
  dueDate: date('due_date').notNull(),
  paidAt: timestamp('paid_at', { withTimezone: true }),
  retryCount: smallint('retry_count').notNull().default(0),
  lastAttemptAt: timestamp('last_attempt_at', { withTimezone: true }),
  failureReason: text('failure_reason'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
