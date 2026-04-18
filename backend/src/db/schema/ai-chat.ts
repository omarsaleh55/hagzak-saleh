import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  integer,
  numeric,
  timestamp,
  jsonb,
  index,
} from 'drizzle-orm/pg-core';
import { languages } from './lookups';
import { users } from './users';
import { vector } from './types';

// 12.1 ai_chat_sessions
export const aiChatSessions = pgTable(
  'ai_chat_sessions',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    languageId: smallint('language_id')
      .notNull()
      .references(() => languages.id),
    turnsCount: integer('turns_count').notNull().default(0),
    contextSnapshot: jsonb('context_snapshot'),
    lastActiveAt: timestamp('last_active_at', { withTimezone: true }).notNull().defaultNow(),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_ai_sessions_user_id').on(t.userId),
    index('idx_ai_sessions_last_active').on(t.lastActiveAt),
  ],
);

// 12.2 ai_chat_messages
export const aiChatMessages = pgTable('ai_chat_messages', {
  id: uuid('id').primaryKey().defaultRandom(),
  sessionId: uuid('session_id')
    .notNull()
    .references(() => aiChatSessions.id, { onDelete: 'cascade' }),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  role: varchar('role', { length: 20 }).notNull(),
  content: text('content').notNull(),
  inputType: varchar('input_type', { length: 10 }).notNull().default('text'),
  voiceFilePath: text('voice_file_path'),
  transcription: text('transcription'),
  intentDetected: varchar('intent_detected', { length: 100 }),
  entities: jsonb('entities'),
  actionsExecuted: jsonb('actions_executed'),
  richCardData: jsonb('rich_card_data'),
  modelUsed: varchar('model_used', { length: 100 }),
  tokensUsed: integer('tokens_used'),
  responseTimeMs: integer('response_time_ms'),
  wasFlagged: boolean('was_flagged').notNull().default(false),
  flagReason: text('flag_reason'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 12.3 ai_knowledge_base
export const aiKnowledgeBase = pgTable('ai_knowledge_base', {
  id: uuid('id').primaryKey().defaultRandom(),
  category: varchar('category', { length: 50 }).notNull(),
  questionEn: text('question_en').notNull(),
  questionAr: text('question_ar'),
  answerEn: text('answer_en').notNull(),
  answerAr: text('answer_ar'),
  keywords: text('keywords').array(),
  embeddingVector: vector('embedding_vector', { dimensions: 1536 }),
  isActive: boolean('is_active').notNull().default(true),
  updatedBy: uuid('updated_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

// 12.4 speech_transcription_logs
export const speechTranscriptionLogs = pgTable('speech_transcription_logs', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  audioDurationSec: smallint('audio_duration_sec').notNull(),
  languageDetected: varchar('language_detected', { length: 10 }),
  transcription: text('transcription'),
  confidenceScore: numeric('confidence_score', { precision: 4, scale: 3 }),
  status: varchar('status', { length: 20 }).notNull(),
  errorMessage: text('error_message'),
  context: varchar('context', { length: 30 }).notNull(),
  aiMessageId: uuid('ai_message_id').references(() => aiChatMessages.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
