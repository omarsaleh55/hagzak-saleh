import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  timestamp,
  date,
  inet,
  index,
  unique,
  type AnyPgColumn,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { genderEnum, userRoles, accountStatuses, languages, socialProviders } from './lookups';
// 2.1 users
export const users = pgTable(
  'users',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    fullName: varchar('full_name', { length: 100 }).notNull(),
    email: varchar('email', { length: 255 }).unique().notNull(),
    emailVerified: boolean('email_verified').notNull().default(false),
    passwordHash: text('password_hash'),
    phoneNumber: varchar('phone_number', { length: 20 }).unique().notNull(),
    phoneVerified: boolean('phone_verified').notNull().default(false),
    dateOfBirth: date('date_of_birth'),
    gender: genderEnum('gender'),
    profileImageUrl: text('profile_image_url'),
    city: varchar('city', { length: 100 }),
    latitude: varchar('latitude', { length: 20 }),
    longitude: varchar('longitude', { length: 20 }),
    roleId: smallint('role_id')
      .notNull()
      .references(() => userRoles.id),
    accountStatusId: smallint('account_status_id')
      .notNull()
      .references(() => accountStatuses.id),
    preferredLanguageId: smallint('preferred_language_id')
      .notNull()
      .references(() => languages.id),
    socialProviderId: smallint('social_provider_id').references(() => socialProviders.id),
    socialProviderUserId: varchar('social_provider_user_id', { length: 255 }),
    failedLoginAttempts: smallint('failed_login_attempts').notNull().default(0),
    lockedUntil: timestamp('locked_until', { withTimezone: true }),
    lastLoginAt: timestamp('last_login_at', { withTimezone: true }),
    referralCode: varchar('referral_code', { length: 20 }).unique().notNull(),
    referredByUserId: uuid('referred_by_user_id').references((): AnyPgColumn => users.id),
    twoFaEnabled: boolean('two_fa_enabled').notNull().default(false),
    twoFaSecret: text('two_fa_secret'),
    termsAcceptedAt: timestamp('terms_accepted_at', { withTimezone: true }),
    termsVersion: varchar('terms_version', { length: 20 }),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    deletionRequestedAt: timestamp('deletion_requested_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_users_email').on(t.email),
    index('idx_users_phone').on(t.phoneNumber),
    index('idx_users_role').on(t.roleId),
    index('idx_users_referral_code').on(t.referralCode),
    index('idx_users_city').on(t.city),
    index('idx_users_deleted_at')
      .on(t.deletedAt)
      .where(sql`deleted_at IS NULL`),
  ],
);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;

// 2.2 user_sessions
export const userSessions = pgTable(
  'user_sessions',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    tokenHash: text('token_hash').notNull().unique(),
    deviceId: varchar('device_id', { length: 255 }),
    deviceName: varchar('device_name', { length: 200 }),
    userAgent: text('user_agent'),
    ipAddress: inet('ip_address'),
    issuedAt: timestamp('issued_at', { withTimezone: true }).notNull().defaultNow(),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    lastUsedAt: timestamp('last_used_at', { withTimezone: true }),
    revokedAt: timestamp('revoked_at', { withTimezone: true }),
    revokeReason: varchar('revoke_reason', { length: 50 }),
  },
  (t) => [
    index('idx_sessions_user_id').on(t.userId),
    index('idx_sessions_token_hash').on(t.tokenHash),
    index('idx_sessions_expires_at').on(t.expiresAt),
  ],
);

export type UserSession = typeof userSessions.$inferSelect;
export type NewUserSession = typeof userSessions.$inferInsert;

// 2.3 otp_records
export const otpRecords = pgTable(
  'otp_records',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id').references(() => users.id),
    identifier: varchar('identifier', { length: 255 }).notNull(),
    identifierType: varchar('identifier_type', { length: 10 }).notNull(),
    otpHash: text('otp_hash').notNull(),
    purpose: varchar('purpose', { length: 30 }).notNull(),
    ipAddress: inet('ip_address'),
    isUsed: boolean('is_used').notNull().default(false),
    usedAt: timestamp('used_at', { withTimezone: true }),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    attemptCount: smallint('attempt_count').notNull().default(0),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_otp_identifier')
      .on(t.identifier, t.purpose)
      .where(sql`is_used = false`),
    index('idx_otp_expires_at').on(t.expiresAt),
  ],
);

// 2.4 otp_rate_limits
export const otpRateLimits = pgTable(
  'otp_rate_limits',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    identifier: varchar('identifier', { length: 255 }).notNull(),
    identifierType: varchar('identifier_type', { length: 10 }).notNull(),
    ipAddress: inet('ip_address'),
    windowHourStart: timestamp('window_hour_start', { withTimezone: true }).notNull(),
    windowDayStart: date('window_day_start').notNull(),
    hourlyCount: smallint('hourly_count').notNull().default(0),
    dailyCount: smallint('daily_count').notNull().default(0),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_otp_rate_limits').on(t.identifier, t.identifierType, t.windowDayStart)],
);

// 2.5 user_devices
export const userDevices = pgTable(
  'user_devices',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    deviceFingerprint: varchar('device_fingerprint', { length: 255 }).notNull(),
    deviceName: varchar('device_name', { length: 200 }),
    platform: varchar('platform', { length: 20 }),
    osVersion: varchar('os_version', { length: 50 }),
    appVersion: varchar('app_version', { length: 20 }),
    fcmToken: text('fcm_token'),
    firstSeenAt: timestamp('first_seen_at', { withTimezone: true }).notNull().defaultNow(),
    lastSeenAt: timestamp('last_seen_at', { withTimezone: true }).notNull().defaultNow(),
    lastIp: inet('last_ip'),
    isTrusted: boolean('is_trusted').notNull().default(false),
  },
  (t) => [
    unique('uq_user_device').on(t.userId, t.deviceFingerprint),
    index('idx_devices_user_id').on(t.userId),
    index('idx_devices_fingerprint').on(t.deviceFingerprint),
  ],
);

// 2.6 login_attempts
export const loginAttempts = pgTable(
  'login_attempts',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id').references(() => users.id),
    identifier: varchar('identifier', { length: 255 }).notNull(),
    ipAddress: inet('ip_address').notNull(),
    userAgent: text('user_agent'),
    deviceFingerprint: varchar('device_fingerprint', { length: 255 }),
    success: boolean('success').notNull(),
    failureReason: varchar('failure_reason', { length: 60 }),
    isNewDevice: boolean('is_new_device'),
    isNewLocation: boolean('is_new_location'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_login_attempts_user_id').on(t.userId),
    index('idx_login_attempts_ip').on(t.ipAddress),
    index('idx_login_attempts_created_at').on(t.createdAt),
  ],
);

// 2.7 legal_consents
export const legalConsents = pgTable('legal_consents', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  consentType: varchar('consent_type', { length: 40 }).notNull(),
  version: varchar('version', { length: 20 }).notNull(),
  accepted: boolean('accepted').notNull(),
  ipAddress: inet('ip_address'),
  userAgent: text('user_agent'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 2.8 data_export_requests
export const dataExportRequests = pgTable('data_export_requests', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  status: varchar('status', { length: 20 }).notNull().default('pending'),
  requestedAt: timestamp('requested_at', { withTimezone: true }).notNull().defaultNow(),
  fulfilledAt: timestamp('fulfilled_at', { withTimezone: true }),
  expiresAt: timestamp('expires_at', { withTimezone: true }),
  downloadUrl: text('download_url'),
  processedBy: uuid('processed_by').references(() => users.id),
  slaDeadline: timestamp('sla_deadline', { withTimezone: true }).notNull(),
});
