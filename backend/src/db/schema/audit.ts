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
  inet,
} from 'drizzle-orm/pg-core';
import { logTypes } from './lookups';
import { users } from './users';

// 17.1 audit_logs
export const auditLogs = pgTable(
  'audit_logs',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    logTypeId: smallint('log_type_id')
      .notNull()
      .references(() => logTypes.id),
    userId: uuid('user_id').references(() => users.id),
    targetUserId: uuid('target_user_id').references(() => users.id),
    ipAddress: inet('ip_address'),
    userAgent: text('user_agent'),
    deviceFingerprint: varchar('device_fingerprint', { length: 255 }),
    action: varchar('action', { length: 100 }).notNull(),
    resourceType: varchar('resource_type', { length: 40 }),
    resourceId: uuid('resource_id'),
    oldValue: jsonb('old_value'),
    newValue: jsonb('new_value'),
    result: varchar('result', { length: 10 }).notNull().default('success'),
    errorCode: varchar('error_code', { length: 20 }),
    metadata: jsonb('metadata'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_audit_logs_user_id').on(t.userId),
    index('idx_audit_logs_action').on(t.action),
    index('idx_audit_logs_resource').on(t.resourceType, t.resourceId),
    index('idx_audit_logs_created_at').on(t.createdAt),
  ],
);

// 17.2 security_logs
export const securityLogs = pgTable(
  'security_logs',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id').references(() => users.id),
    eventType: varchar('event_type', { length: 60 }).notNull(),
    ipAddress: inet('ip_address').notNull(),
    userAgent: text('user_agent'),
    deviceFingerprint: varchar('device_fingerprint', { length: 255 }),
    identifier: varchar('identifier', { length: 255 }),
    isNewDevice: boolean('is_new_device'),
    isSuspicious: boolean('is_suspicious').notNull().default(false),
    details: jsonb('details'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_security_logs_user_id').on(t.userId),
    index('idx_security_logs_ip').on(t.ipAddress),
    index('idx_security_logs_created_at').on(t.createdAt),
  ],
);

// 17.3 api_request_logs
export const apiRequestLogs = pgTable('api_request_logs', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id'),
  method: varchar('method', { length: 10 }).notNull(),
  path: varchar('path', { length: 500 }).notNull(),
  queryParams: text('query_params'),
  statusCode: smallint('status_code').notNull(),
  responseTimeMs: integer('response_time_ms').notNull(),
  ipAddress: inet('ip_address'),
  userAgent: text('user_agent'),
  requestId: uuid('request_id'),
  errorCode: varchar('error_code', { length: 20 }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 17.4 payment_logs
export const paymentLogs = pgTable('payment_logs', {
  id: uuid('id').primaryKey().defaultRandom(),
  paymentId: uuid('payment_id').notNull(),
  bookingId: uuid('booking_id').notNull(),
  userId: uuid('user_id'),
  eventType: varchar('event_type', { length: 60 }).notNull(),
  oldStatus: varchar('old_status', { length: 30 }),
  newStatus: varchar('new_status', { length: 30 }),
  amount: numeric('amount', { precision: 10, scale: 2 }),
  gatewayTransactionId: varchar('gateway_transaction_id', { length: 200 }),
  signatureValid: boolean('signature_valid'),
  rawPayload: jsonb('raw_payload'),
  ipAddress: inet('ip_address'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 17.5 system_event_logs
export const systemEventLogs = pgTable('system_event_logs', {
  id: uuid('id').primaryKey().defaultRandom(),
  eventType: varchar('event_type', { length: 80 }).notNull(),
  status: varchar('status', { length: 10 }).notNull(),
  affectedId: uuid('affected_id'),
  affectedType: varchar('affected_type', { length: 30 }),
  recordsAffected: integer('records_affected'),
  durationMs: integer('duration_ms'),
  errorMessage: text('error_message'),
  metadata: jsonb('metadata'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
