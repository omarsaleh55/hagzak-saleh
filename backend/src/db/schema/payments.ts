import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  char,
  numeric,
  timestamp,
  jsonb,
  index,
} from 'drizzle-orm/pg-core';
import { paymentMethodTypes, paymentStatuses } from './lookups';
import { users } from './users';
import { bookings } from './bookings';

// 7.1 payments
export const payments = pgTable(
  'payments',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    bookingId: uuid('booking_id')
      .notNull()
      .unique()
      .references(() => bookings.id),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id),
    amount: numeric('amount', { precision: 10, scale: 2 }).notNull(),
    paymentMethodTypeId: smallint('payment_method_type_id')
      .notNull()
      .references(() => paymentMethodTypes.id),
    statusId: smallint('status_id')
      .notNull()
      .references(() => paymentStatuses.id),
    gatewayTransactionId: varchar('gateway_transaction_id', { length: 200 }).unique(),
    gatewayOrderId: varchar('gateway_order_id', { length: 200 }),
    gatewayResponse: jsonb('gateway_response'),
    callbackReceivedAt: timestamp('callback_received_at', { withTimezone: true }),
    callbackSignatureValid: boolean('callback_signature_valid'),
    cashConfirmedBy: uuid('cash_confirmed_by').references(() => users.id),
    cashConfirmedAt: timestamp('cash_confirmed_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_payments_booking_id').on(t.bookingId),
    index('idx_payments_user_id').on(t.userId),
    index('idx_payments_gateway_txn_id').on(t.gatewayTransactionId),
    index('idx_payments_status_id').on(t.statusId),
  ],
);

export type Payment = typeof payments.$inferSelect;
export type NewPayment = typeof payments.$inferInsert;

// 7.2 refunds
export const refunds = pgTable('refunds', {
  id: uuid('id').primaryKey().defaultRandom(),
  paymentId: uuid('payment_id')
    .notNull()
    .references(() => payments.id),
  bookingId: uuid('booking_id')
    .notNull()
    .references(() => bookings.id),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  amount: numeric('amount', { precision: 10, scale: 2 }).notNull(),
  refundType: varchar('refund_type', { length: 20 }).notNull(),
  reason: text('reason').notNull(),
  policyApplied: varchar('policy_applied', { length: 30 }),
  penaltyAmount: numeric('penalty_amount', { precision: 8, scale: 2 }).notNull().default('0'),
  gatewayRefundId: varchar('gateway_refund_id', { length: 200 }),
  status: varchar('status', { length: 20 }).notNull().default('pending'),
  issuedBy: uuid('issued_by').references(() => users.id),
  processedAt: timestamp('processed_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 7.3 saved_payment_methods
export const savedPaymentMethods = pgTable('saved_payment_methods', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  paymentMethodTypeId: smallint('payment_method_type_id')
    .notNull()
    .references(() => paymentMethodTypes.id),
  providerToken: text('provider_token').notNull(),
  lastFour: char('last_four', { length: 4 }),
  cardBrand: varchar('card_brand', { length: 20 }),
  expiryMonth: smallint('expiry_month'),
  expiryYear: smallint('expiry_year'),
  walletNumber: varchar('wallet_number', { length: 20 }),
  isDefault: boolean('is_default').notNull().default(false),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});
