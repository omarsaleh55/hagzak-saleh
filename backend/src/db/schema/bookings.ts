import {
  pgTable,
  uuid,
  varchar,
  text,
  smallint,
  integer,
  numeric,
  timestamp,
  date,
  time,
  index,
  uniqueIndex,
} from 'drizzle-orm/pg-core';
import { bookingStatuses, paymentMethodTypes, cancellationByTypes } from './lookups';
import { users } from './users';
import { courts } from './courts';
import { venues } from './venues';
import { promoCodes } from './promotions';
import { courtPricingSlots } from './scheduling';

// 6.1 bookings
export const bookings = pgTable(
  'bookings',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id),
    courtId: uuid('court_id')
      .notNull()
      .references(() => courts.id),
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id),
    bookingDate: date('booking_date').notNull(),
    totalHours: smallint('total_hours').notNull(),
    startTime: time('start_time').notNull(),
    endTime: time('end_time').notNull(),
    subtotal: numeric('subtotal', { precision: 10, scale: 2 }).notNull(),
    cashSurcharge: numeric('cash_surcharge', { precision: 8, scale: 2 }).notNull().default('0'),
    discountAmount: numeric('discount_amount', { precision: 8, scale: 2 }).notNull().default('0'),
    promoDiscount: numeric('promo_discount', { precision: 8, scale: 2 }).notNull().default('0'),
    pointsDiscount: numeric('points_discount', { precision: 8, scale: 2 }).notNull().default('0'),
    platformCommission: numeric('platform_commission', { precision: 8, scale: 2 })
      .notNull()
      .default('0'),
    totalAmount: numeric('total_amount', { precision: 10, scale: 2 }).notNull(),
    paymentMethodTypeId: smallint('payment_method_type_id')
      .notNull()
      .references(() => paymentMethodTypes.id),
    statusId: smallint('status_id')
      .notNull()
      .references(() => bookingStatuses.id),
    reservationExpiresAt: timestamp('reservation_expires_at', { withTimezone: true }),
    confirmedAt: timestamp('confirmed_at', { withTimezone: true }),
    cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
    cancellationReason: text('cancellation_reason'),
    cancelledByTypeId: smallint('cancelled_by_type_id').references(() => cancellationByTypes.id),
    cancelledByUserId: uuid('cancelled_by_user_id').references(() => users.id),
    noShowMarkedAt: timestamp('no_show_marked_at', { withTimezone: true }),
    promoCodeId: uuid('promo_code_id').references(() => promoCodes.id),
    pointsUsed: integer('points_used').notNull().default(0),
    checkInAt: timestamp('check_in_at', { withTimezone: true }),
    checkInMethod: varchar('check_in_method', { length: 10 }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_bookings_user_id').on(t.userId),
    index('idx_bookings_court_date').on(t.courtId, t.bookingDate),
    index('idx_bookings_venue_id').on(t.venueId),
    index('idx_bookings_status_id').on(t.statusId),
    index('idx_bookings_confirmed_at').on(t.confirmedAt),
    index('idx_bookings_reservation_expires').on(t.reservationExpiresAt),
  ],
);

export type Booking = typeof bookings.$inferSelect;
export type NewBooking = typeof bookings.$inferInsert;

// 6.2 booking_slots
export const bookingSlots = pgTable(
  'booking_slots',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    bookingId: uuid('booking_id')
      .notNull()
      .references(() => bookings.id, { onDelete: 'cascade' }),
    slotStart: time('slot_start').notNull(),
    slotEnd: time('slot_end').notNull(),
    price: numeric('price', { precision: 8, scale: 2 }).notNull(),
    pricingSlotId: uuid('pricing_slot_id').references(() => courtPricingSlots.id),
  },
  (t) => [uniqueIndex('uq_booking_slot').on(t.bookingId, t.slotStart)],
);

// 6.3 booking_status_history
export const bookingStatusHistory = pgTable('booking_status_history', {
  id: uuid('id').primaryKey().defaultRandom(),
  bookingId: uuid('booking_id')
    .notNull()
    .references(() => bookings.id, { onDelete: 'cascade' }),
  oldStatusId: smallint('old_status_id').references(() => bookingStatuses.id),
  newStatusId: smallint('new_status_id')
    .notNull()
    .references(() => bookingStatuses.id),
  changedBy: uuid('changed_by').references(() => users.id),
  reason: text('reason'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
