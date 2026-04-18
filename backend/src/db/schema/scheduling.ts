import {
  pgTable,
  uuid,
  varchar,
  boolean,
  smallint,
  numeric,
  timestamp,
  date,
  time,
  index,
  unique,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { pricingLabels } from './lookups';
import { users } from './users';
import { courts } from './courts';

// 5.1 court_weekly_availability
export const courtWeeklyAvailability = pgTable(
  'court_weekly_availability',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    courtId: uuid('court_id')
      .notNull()
      .references(() => courts.id, { onDelete: 'cascade' }),
    dayOfWeek: smallint('day_of_week').notNull(),
    openTime: time('open_time'),
    closeTime: time('close_time'),
    isClosed: boolean('is_closed').notNull().default(false),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_court_weekly_availability').on(t.courtId, t.dayOfWeek)],
);

// 5.2 court_schedule_overrides
export const courtScheduleOverrides = pgTable(
  'court_schedule_overrides',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    courtId: uuid('court_id')
      .notNull()
      .references(() => courts.id, { onDelete: 'cascade' }),
    overrideDate: date('override_date').notNull(),
    openTime: time('open_time'),
    closeTime: time('close_time'),
    isClosed: boolean('is_closed').notNull().default(false),
    reason: varchar('reason', { length: 200 }),
    createdBy: uuid('created_by')
      .notNull()
      .references(() => users.id),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_court_schedule_override').on(t.courtId, t.overrideDate)],
);

// 5.3 court_pricing_slots
export const courtPricingSlots = pgTable(
  'court_pricing_slots',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    courtId: uuid('court_id')
      .notNull()
      .references(() => courts.id, { onDelete: 'cascade' }),
    pricingLabelId: smallint('pricing_label_id').references(() => pricingLabels.id),
    dayOfWeek: smallint('day_of_week'),
    startTime: time('start_time').notNull(),
    endTime: time('end_time').notNull(),
    pricePerHour: numeric('price_per_hour', { precision: 10, scale: 2 }).notNull(),
    validFrom: date('valid_from'),
    validUntil: date('valid_until'),
    isActive: boolean('is_active').notNull().default(true),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_pricing_court_day')
      .on(t.courtId, t.dayOfWeek)
      .where(sql`is_active = true`),
  ],
);

// 5.4 court_blocked_slots
export const courtBlockedSlots = pgTable(
  'court_blocked_slots',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    courtId: uuid('court_id')
      .notNull()
      .references(() => courts.id, { onDelete: 'cascade' }),
    blockDate: date('block_date').notNull(),
    startTime: time('start_time').notNull(),
    endTime: time('end_time').notNull(),
    reason: varchar('reason', { length: 200 }),
    createdBy: uuid('created_by')
      .notNull()
      .references(() => users.id),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [index('idx_blocked_slots_court_date').on(t.courtId, t.blockDate)],
);
