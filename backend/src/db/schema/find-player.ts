import { pgTable, uuid, text, smallint, numeric, timestamp, date, time } from 'drizzle-orm/pg-core';
import { findPlayerSkillLevels, findPlayerPostStatuses } from './lookups';
import { users } from './users';
import { courts, sportTypes } from './courts';
import { bookings } from './bookings';
import { payments } from './payments';

// 14.1 find_player_posts
export const findPlayerPosts = pgTable('find_player_posts', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  courtId: uuid('court_id')
    .notNull()
    .references(() => courts.id),
  bookingId: uuid('booking_id').references(() => bookings.id),
  bookingDate: date('booking_date').notNull(),
  startTime: time('start_time').notNull(),
  endTime: time('end_time').notNull(),
  totalCost: numeric('total_cost', { precision: 10, scale: 2 }).notNull(),
  maxPlayers: smallint('max_players').notNull(),
  currentPlayers: smallint('current_players').notNull().default(1),
  costPerPlayer: numeric('cost_per_player', { precision: 8, scale: 2 }).notNull(),
  sportTypeId: uuid('sport_type_id')
    .notNull()
    .references(() => sportTypes.id),
  skillLevelId: smallint('skill_level_id')
    .notNull()
    .references(() => findPlayerSkillLevels.id),
  description: text('description'),
  statusId: smallint('status_id')
    .notNull()
    .references(() => findPlayerPostStatuses.id),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

// 14.2 find_player_participants
export const findPlayerParticipants = pgTable('find_player_participants', {
  id: uuid('id').primaryKey().defaultRandom(),
  postId: uuid('post_id')
    .notNull()
    .references(() => findPlayerPosts.id, { onDelete: 'cascade' }),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  paymentId: uuid('payment_id').references(() => payments.id),
  shareAmount: numeric('share_amount', { precision: 8, scale: 2 }).notNull(),
  paidAt: timestamp('paid_at', { withTimezone: true }),
  joinedAt: timestamp('joined_at', { withTimezone: true }).notNull().defaultNow(),
  leftAt: timestamp('left_at', { withTimezone: true }),
});
