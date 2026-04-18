import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  timestamp,
  inet,
} from 'drizzle-orm/pg-core';
import { fraudFlagTypes } from './lookups';
import { users } from './users';

// 16.1 fraud_flags
export const fraudFlags = pgTable('fraud_flags', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  flagTypeId: smallint('flag_type_id')
    .notNull()
    .references(() => fraudFlagTypes.id),
  description: text('description').notNull(),
  ipAddress: inet('ip_address'),
  deviceFingerprint: varchar('device_fingerprint', { length: 255 }),
  relatedUserIds: uuid('related_user_ids').array(),
  referenceId: uuid('reference_id'),
  referenceType: varchar('reference_type', { length: 30 }),
  severity: varchar('severity', { length: 10 }).notNull().default('medium'),
  status: varchar('status', { length: 20 }).notNull().default('open'),
  reviewedBy: uuid('reviewed_by').references(() => users.id),
  reviewedAt: timestamp('reviewed_at', { withTimezone: true }),
  adminNotes: text('admin_notes'),
  autoFlagged: boolean('auto_flagged').notNull().default(true),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
