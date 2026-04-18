import {
  pgTable,
  uuid,
  varchar,
  boolean,
  integer,
  timestamp,
  date,
  time,
  index,
  unique,
} from 'drizzle-orm/pg-core';
import { users } from './users';
import { courts } from './courts';
import { bookings } from './bookings';
import { savedPaymentMethods } from './payments';

// 15.1 waitlist_entries
export const waitlistEntries = pgTable(
  'waitlist_entries',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    courtId: uuid('court_id')
      .notNull()
      .references(() => courts.id, { onDelete: 'cascade' }),
    bookingDate: date('booking_date').notNull(),
    startTime: time('start_time').notNull(),
    endTime: time('end_time').notNull(),
    queuePosition: integer('queue_position').notNull(),
    autoBookEnabled: boolean('auto_book_enabled').notNull().default(false),
    savedPaymentMethodId: uuid('saved_payment_method_id').references(() => savedPaymentMethods.id),
    status: varchar('status', { length: 20 }).notNull().default('waiting'),
    notifiedAt: timestamp('notified_at', { withTimezone: true }),
    responseDeadline: timestamp('response_deadline', { withTimezone: true }),
    bookingId: uuid('booking_id').references(() => bookings.id),
    joinedAt: timestamp('joined_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    unique('uq_waitlist_active').on(t.userId, t.courtId, t.bookingDate, t.startTime),
    index('idx_waitlist_court_slot').on(t.courtId, t.bookingDate, t.startTime, t.queuePosition),
  ],
);
