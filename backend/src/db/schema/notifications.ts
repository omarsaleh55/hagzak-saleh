import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  timestamp,
  jsonb,
  index,
  primaryKey,
  unique,
} from 'drizzle-orm/pg-core';
import { notificationEventTypes, notificationChannels, languages } from './lookups';
import { users } from './users';

// 13.1 notification_templates
export const notificationTemplates = pgTable(
  'notification_templates',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    eventTypeId: smallint('event_type_id')
      .notNull()
      .references(() => notificationEventTypes.id),
    channelId: smallint('channel_id')
      .notNull()
      .references(() => notificationChannels.id),
    languageId: smallint('language_id')
      .notNull()
      .references(() => languages.id),
    subject: varchar('subject', { length: 200 }),
    body: text('body').notNull(),
    isActive: boolean('is_active').notNull().default(true),
    updatedBy: uuid('updated_by').references(() => users.id),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_notification_template').on(t.eventTypeId, t.channelId, t.languageId)],
);

// 13.2 notifications
export const notifications = pgTable(
  'notifications',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    eventTypeId: smallint('event_type_id')
      .notNull()
      .references(() => notificationEventTypes.id),
    channelId: smallint('channel_id')
      .notNull()
      .references(() => notificationChannels.id),
    title: varchar('title', { length: 200 }),
    body: text('body').notNull(),
    data: jsonb('data'),
    referenceId: uuid('reference_id'),
    referenceType: varchar('reference_type', { length: 30 }),
    status: varchar('status', { length: 20 }).notNull().default('queued'),
    retryCount: smallint('retry_count').notNull().default(0),
    lastError: text('last_error'),
    sentAt: timestamp('sent_at', { withTimezone: true }),
    readAt: timestamp('read_at', { withTimezone: true }),
    scheduledFor: timestamp('scheduled_for', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_notifications_user_id').on(t.userId, t.createdAt),
    index('idx_notifications_status').on(t.status),
    index('idx_notifications_scheduled').on(t.scheduledFor),
  ],
);

export type Notification = typeof notifications.$inferSelect;
export type NewNotification = typeof notifications.$inferInsert;

// 13.3 notification_preferences
export const notificationPreferences = pgTable(
  'notification_preferences',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    eventTypeId: smallint('event_type_id')
      .notNull()
      .references(() => notificationEventTypes.id),
    channelId: smallint('channel_id')
      .notNull()
      .references(() => notificationChannels.id),
    isEnabled: boolean('is_enabled').notNull().default(true),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.eventTypeId, t.channelId] })],
);
