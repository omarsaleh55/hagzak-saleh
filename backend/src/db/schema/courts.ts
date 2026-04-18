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
  index,
} from 'drizzle-orm/pg-core';
import { courtStatuses, surfaceTypes } from './lookups';
import { users } from './users';
import { venues } from './venues';

// 4.1 sport_types
export const sportTypes = pgTable('sport_types', {
  id: uuid('id').primaryKey().defaultRandom(),
  nameEn: varchar('name_en', { length: 80 }).notNull().unique(),
  nameAr: varchar('name_ar', { length: 80 }),
  iconUrl: text('icon_url'),
  attributes: text('attributes'), // JSONB stored as text, cast in app
  isActive: boolean('is_active').notNull().default(true),
  sortOrder: smallint('sort_order').notNull().default(0),
  createdBy: uuid('created_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export type SportType = typeof sportTypes.$inferSelect;
export type NewSportType = typeof sportTypes.$inferInsert;

// 4.2 courts
export const courts = pgTable(
  'courts',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id, { onDelete: 'restrict' }),
    sportTypeId: uuid('sport_type_id')
      .notNull()
      .references(() => sportTypes.id),
    surfaceTypeId: smallint('surface_type_id').references(() => surfaceTypes.id),
    name: varchar('name', { length: 100 }).notNull(),
    description: text('description'),
    descriptionAr: text('description_ar'),
    capacity: smallint('capacity'),
    hasLighting: boolean('has_lighting').notNull().default(false),
    statusId: smallint('status_id')
      .notNull()
      .references(() => courtStatuses.id),
    maintenanceNote: text('maintenance_note'),
    totalBookings: integer('total_bookings').notNull().default(0),
    averageRating: numeric('average_rating', { precision: 3, scale: 2 }).default('0'),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_courts_venue_id').on(t.venueId),
    index('idx_courts_sport_type_id').on(t.sportTypeId),
    index('idx_courts_status_id').on(t.statusId),
    index('idx_courts_venue_sport').on(t.venueId, t.sportTypeId),
  ],
);

export type Court = typeof courts.$inferSelect;
export type NewCourt = typeof courts.$inferInsert;

// 4.3 court_images
export const courtImages = pgTable('court_images', {
  id: uuid('id').primaryKey().defaultRandom(),
  courtId: uuid('court_id')
    .notNull()
    .references(() => courts.id, { onDelete: 'cascade' }),
  filePath: text('file_path').notNull(),
  fileSizeBytes: integer('file_size_bytes').notNull(),
  mimeType: varchar('mime_type', { length: 30 }).notNull(),
  isPrimary: boolean('is_primary').notNull().default(false),
  sortOrder: smallint('sort_order').notNull().default(0),
  uploadedBy: uuid('uploaded_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});
