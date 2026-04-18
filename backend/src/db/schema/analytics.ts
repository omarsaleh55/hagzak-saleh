import {
  pgTable,
  uuid,
  varchar,
  boolean,
  smallint,
  integer,
  bigint,
  numeric,
  timestamp,
  date,
  index,
  primaryKey,
  text,
  inet,
} from 'drizzle-orm/pg-core';
import { users } from './users';
import { venues } from './venues';
import { sportTypes } from './courts';

// 27.1 search_analytics
export const searchAnalytics = pgTable(
  'search_analytics',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id').references(() => users.id),
    queryText: varchar('query_text', { length: 200 }),
    sportTypeId: uuid('sport_type_id').references(() => sportTypes.id),
    city: varchar('city', { length: 100 }),
    searchDate: date('search_date').notNull().defaultNow(),
    resultCount: integer('result_count'),
    clickedVenueId: uuid('clicked_venue_id').references(() => venues.id),
    ipAddress: inet('ip_address'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [index('idx_search_analytics_date').on(t.searchDate)],
);

// 27.2 venue_view_counts
export const venueViewCounts = pgTable(
  'venue_view_counts',
  {
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id, { onDelete: 'cascade' }),
    countDate: date('count_date').notNull().defaultNow(),
    impressionCount: integer('impression_count').notNull().default(0),
    profileViewCount: integer('profile_view_count').notNull().default(0),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.venueId, t.countDate] })],
);

// 28.1 ai_model_configs
export const aiModelConfigs = pgTable('ai_model_configs', {
  id: uuid('id').primaryKey().defaultRandom(),
  isActive: boolean('is_active').notNull().default(false),
  modelProvider: varchar('model_provider', { length: 20 }).notNull(),
  modelId: varchar('model_id', { length: 100 }).notNull(),
  systemPrompt: text('system_prompt').notNull(),
  temperature: numeric('temperature', { precision: 3, scale: 2 }).notNull().default('0.70'),
  maxTokens: integer('max_tokens').notNull().default(1000),
  contextWindowTurns: smallint('context_window_turns').notNull().default(10),
  fallbackModelId: varchar('fallback_model_id', { length: 100 }),
  costPer1kInputTokens: numeric('cost_per_1k_input_tokens', { precision: 8, scale: 6 }),
  costPer1kOutputTokens: numeric('cost_per_1k_output_tokens', { precision: 8, scale: 6 }),
  updatedBy: uuid('updated_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

// 28.2 ai_cost_tracking
export const aiCostTracking = pgTable(
  'ai_cost_tracking',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    trackingDate: date('tracking_date').notNull().defaultNow(),
    modelId: varchar('model_id', { length: 100 }).notNull(),
    totalRequests: integer('total_requests').notNull().default(0),
    totalInputTokens: bigint('total_input_tokens', { mode: 'number' }).notNull().default(0),
    totalOutputTokens: bigint('total_output_tokens', { mode: 'number' }).notNull().default(0),
    estimatedCostUsd: numeric('estimated_cost_usd', { precision: 10, scale: 4 })
      .notNull()
      .default('0'),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [{ primaryKey: [t.trackingDate, t.modelId] }],
);
