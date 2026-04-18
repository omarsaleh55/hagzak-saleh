import {
  pgTable,
  uuid,
  varchar,
  boolean,
  smallint,
  integer,
  numeric,
  timestamp,
  date,
  index,
} from 'drizzle-orm/pg-core';
import { promoCodeTypes, promoApplicableTo } from './lookups';
import { users } from './users';

// 9.1 promo_codes
export const promoCodes = pgTable(
  'promo_codes',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    code: varchar('code', { length: 40 }).unique().notNull(),
    promoTypeId: smallint('promo_type_id')
      .notNull()
      .references(() => promoCodeTypes.id),
    value: numeric('value', { precision: 10, scale: 2 }).notNull(),
    minBookingAmount: numeric('min_booking_amount', { precision: 10, scale: 2 })
      .notNull()
      .default('0'),
    maxDiscountCap: numeric('max_discount_cap', { precision: 10, scale: 2 }),
    maxUsesTotal: integer('max_uses_total'),
    maxUsesPerUser: smallint('max_uses_per_user').notNull().default(1),
    currentUses: integer('current_uses').notNull().default(0),
    applicableToId: smallint('applicable_to_id')
      .notNull()
      .references(() => promoApplicableTo.id),
    applicableEntityId: uuid('applicable_entity_id'),
    startDate: date('start_date').notNull(),
    endDate: date('end_date').notNull(),
    isActive: boolean('is_active').notNull().default(true),
    isStackable: boolean('is_stackable').notNull().default(false),
    createdBy: uuid('created_by')
      .notNull()
      .references(() => users.id),
    scope: varchar('scope', { length: 10 }).notNull().default('global'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_promo_code').on(t.code),
    index('idx_promo_active').on(t.isActive, t.startDate, t.endDate),
  ],
);

export type PromoCode = typeof promoCodes.$inferSelect;
export type NewPromoCode = typeof promoCodes.$inferInsert;
