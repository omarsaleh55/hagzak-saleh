import { pgTable, uuid, numeric, timestamp, unique } from 'drizzle-orm/pg-core';
import { users } from './users';
import { promoCodes } from './promotions';
import { bookings } from './bookings';

// 9.2 promo_code_usages
export const promoCodeUsages = pgTable(
  'promo_code_usages',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    promoId: uuid('promo_id')
      .notNull()
      .references(() => promoCodes.id),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id),
    bookingId: uuid('booking_id')
      .notNull()
      .unique()
      .references(() => bookings.id),
    discountApplied: numeric('discount_applied', { precision: 8, scale: 2 }).notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_promo_usage').on(t.promoId, t.userId, t.bookingId)],
);
