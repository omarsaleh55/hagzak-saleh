import {
  pgEnum,
  pgTable,
  smallint,
  smallserial,
  uuid,
  varchar,
  text,
  boolean,
  integer,
  numeric,
} from 'drizzle-orm/pg-core';

// The ONLY true ENUM in the schema
export const genderEnum = pgEnum('gender_enum', ['male', 'female']);

// 1.1 user_roles
export const userRoles = pgTable('user_roles', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
  description: text('description'),
});

// 1.2 account_statuses
export const accountStatuses = pgTable('account_statuses', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
  description: text('description'),
});

// 1.3 languages
export const languages = pgTable('languages', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 10 }).unique().notNull(),
  name: varchar('name', { length: 50 }).notNull(),
});

// 1.4 social_providers
export const socialProviders = pgTable('social_providers', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.5 venue_statuses
export const venueStatuses = pgTable('venue_statuses', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.6 court_statuses
export const courtStatuses = pgTable('court_statuses', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.7 surface_types
export const surfaceTypes = pgTable('surface_types', {
  id: smallserial('id').primaryKey(),
  nameEn: varchar('name_en', { length: 60 }).unique().notNull(),
  nameAr: varchar('name_ar', { length: 60 }),
  isActive: boolean('is_active').default(true),
});

// 1.8 cancellation_policy_types
export const cancellationPolicyTypes = pgTable('cancellation_policy_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
  description: text('description'),
});

// 1.9 booking_statuses
export const bookingStatuses = pgTable('booking_statuses', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
  description: text('description'),
});

// 1.10 payment_method_types
export const paymentMethodTypes = pgTable('payment_method_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 40 }).unique().notNull(),
  label: varchar('label', { length: 60 }).notNull(),
  isOnline: boolean('is_online').notNull(),
  isActive: boolean('is_active').default(true),
});

// 1.11 payment_statuses
export const paymentStatuses = pgTable('payment_statuses', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.12 promo_code_types
export const promoCodeTypes = pgTable('promo_code_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.13 promo_applicable_to
export const promoApplicableTo = pgTable('promo_applicable_to', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.14 points_transaction_types
export const pointsTransactionTypes = pgTable('points_transaction_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.15 reward_action_types
export const rewardActionTypes = pgTable('reward_action_types', {
  id: smallserial('id').primaryKey(),
  code: varchar('code', { length: 60 }).unique().notNull(),
  labelEn: varchar('label_en', { length: 100 }).notNull(),
  labelAr: varchar('label_ar', { length: 100 }),
  defaultPoints: integer('default_points').notNull().default(0),
  isActive: boolean('is_active').default(true),
});

// 1.16 message_sender_types
export const messageSenderTypes = pgTable('message_sender_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.17 message_types
export const messageTypes = pgTable('message_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.18 conversation_types
export const conversationTypes = pgTable('conversation_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.19 notification_event_types
export const notificationEventTypes = pgTable('notification_event_types', {
  id: smallserial('id').primaryKey(),
  code: varchar('code', { length: 60 }).unique().notNull(),
  label: varchar('label', { length: 100 }).notNull(),
  supportsPush: boolean('supports_push').default(true),
  supportsEmail: boolean('supports_email').default(true),
  isActive: boolean('is_active').default(true),
});

// 1.20 notification_channels
export const notificationChannels = pgTable('notification_channels', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.21 log_types
export const logTypes = pgTable('log_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
});

// 1.22 cancellation_by_types
export const cancellationByTypes = pgTable('cancellation_by_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.23 find_player_skill_levels
export const findPlayerSkillLevels = pgTable('find_player_skill_levels', {
  id: smallserial('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
  labelEn: varchar('label_en', { length: 40 }).notNull(),
  labelAr: varchar('label_ar', { length: 40 }),
});

// 1.24 find_player_post_statuses
export const findPlayerPostStatuses = pgTable('find_player_post_statuses', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
});

// 1.25 fraud_flag_types
export const fraudFlagTypes = pgTable('fraud_flag_types', {
  id: smallserial('id').primaryKey(),
  code: varchar('code', { length: 60 }).unique().notNull(),
  description: text('description'),
});

// 1.26 subscription_plan_types
export const subscriptionPlanTypes = pgTable('subscription_plan_types', {
  id: smallint('id').primaryKey(),
  code: varchar('code', { length: 20 }).unique().notNull(),
  label: varchar('label', { length: 40 }).notNull(),
  monthlyPrice: numeric('monthly_price', { precision: 10, scale: 2 }).notNull().default('0'),
  maxActiveCourts: integer('max_active_courts'),
  isActive: boolean('is_active').default(true),
});

// 1.27 amenities
export const amenities = pgTable('amenities', {
  id: uuid('id').primaryKey().defaultRandom(),
  code: varchar('code', { length: 40 }).unique().notNull(),
  labelEn: varchar('label_en', { length: 60 }).notNull(),
  labelAr: varchar('label_ar', { length: 60 }),
  iconUrl: text('icon_url'),
  isActive: boolean('is_active').default(true),
});

// 1.28 pricing_labels
export const pricingLabels = pgTable('pricing_labels', {
  id: smallserial('id').primaryKey(),
  code: varchar('code', { length: 30 }).unique().notNull(),
  labelEn: varchar('label_en', { length: 40 }).notNull(),
  labelAr: varchar('label_ar', { length: 40 }),
});

// 1.29 document_types
export const documentTypes = pgTable('document_types', {
  id: smallserial('id').primaryKey(),
  code: varchar('code', { length: 40 }).unique().notNull(),
  labelEn: varchar('label_en', { length: 60 }).notNull(),
  labelAr: varchar('label_ar', { length: 60 }),
});
