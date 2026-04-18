import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  integer,
  timestamp,
  jsonb,
  index,
  primaryKey,
} from 'drizzle-orm/pg-core';
import { conversationTypes, messageSenderTypes, messageTypes } from './lookups';
import { users } from './users';
import { bookings } from './bookings';

// 11.1 conversations
export const conversations = pgTable('conversations', {
  id: uuid('id').primaryKey().defaultRandom(),
  conversationTypeId: smallint('conversation_type_id')
    .notNull()
    .references(() => conversationTypes.id),
  bookingId: uuid('booking_id').references(() => bookings.id),
  lastMessageAt: timestamp('last_message_at', { withTimezone: true }),
  lastMessagePreview: varchar('last_message_preview', { length: 100 }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export type Conversation = typeof conversations.$inferSelect;
export type NewConversation = typeof conversations.$inferInsert;

// 11.2 conversation_participants
export const conversationParticipants = pgTable(
  'conversation_participants',
  {
    conversationId: uuid('conversation_id')
      .notNull()
      .references(() => conversations.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id),
    joinedAt: timestamp('joined_at', { withTimezone: true }).notNull().defaultNow(),
    lastReadAt: timestamp('last_read_at', { withTimezone: true }),
    isMuted: boolean('is_muted').notNull().default(false),
    unreadCount: integer('unread_count').notNull().default(0),
  },
  (t) => [primaryKey({ columns: [t.conversationId, t.userId] })],
);

// 11.3 messages
export const messages = pgTable(
  'messages',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    conversationId: uuid('conversation_id')
      .notNull()
      .references(() => conversations.id, { onDelete: 'cascade' }),
    senderId: uuid('sender_id').references(() => users.id),
    senderTypeId: smallint('sender_type_id')
      .notNull()
      .references(() => messageSenderTypes.id),
    messageTypeId: smallint('message_type_id')
      .notNull()
      .references(() => messageTypes.id),
    content: varchar('content', { length: 2000 }),
    filePath: text('file_path'),
    fileSizeBytes: integer('file_size_bytes'),
    mimeType: varchar('mime_type', { length: 60 }),
    voiceDurationSec: smallint('voice_duration_sec'),
    richCardData: jsonb('rich_card_data'),
    isDeleted: boolean('is_deleted').notNull().default(false),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [index('idx_messages_conversation_id').on(t.conversationId, t.createdAt)],
);

// 11.4 user_blocks
export const userBlocks = pgTable(
  'user_blocks',
  {
    blockerId: uuid('blocker_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    blockedId: uuid('blocked_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.blockerId, t.blockedId] })],
);

// 11.5 owner_auto_replies
export const ownerAutoReplies = pgTable('owner_auto_replies', {
  id: uuid('id').primaryKey().defaultRandom(),
  ownerId: uuid('owner_id')
    .notNull()
    .unique()
    .references(() => users.id, { onDelete: 'cascade' }),
  messageEn: text('message_en').notNull(),
  messageAr: text('message_ar'),
  isActive: boolean('is_active').notNull().default(false),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});
