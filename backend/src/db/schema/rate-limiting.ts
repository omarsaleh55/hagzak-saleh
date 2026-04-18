import {
  pgTable,
  uuid,
  integer,
  smallint,
  timestamp,
  date,
  index,
  primaryKey,
} from 'drizzle-orm/pg-core';
import { users } from './users';

// 26.1 ai_usage_daily
export const aiUsageDaily = pgTable(
  'ai_usage_daily',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    usageDate: date('usage_date').notNull().defaultNow(),
    messageCount: integer('message_count').notNull().default(0),
    lastMessageAt: timestamp('last_message_at', { withTimezone: true }),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    primaryKey({ columns: [t.userId, t.usageDate] }),
    index('idx_ai_usage_user_date').on(t.userId, t.usageDate),
  ],
);

// 26.2 message_rate_limit_buckets
export const messageRateLimitBuckets = pgTable(
  'message_rate_limit_buckets',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    windowStart: timestamp('window_start', { withTimezone: true }).notNull(),
    messageCount: smallint('message_count').notNull().default(0),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.windowStart] })],
);
