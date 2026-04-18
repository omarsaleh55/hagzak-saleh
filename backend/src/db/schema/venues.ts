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
import { sql } from 'drizzle-orm';
import {
  venueStatuses,
  cancellationPolicyTypes,
  subscriptionPlanTypes,
  amenities,
  documentTypes,
  paymentMethodTypes,
} from './lookups';
import { users } from './users';
import { geography, tsvector } from './types';

// 3.1 venues
export const venues = pgTable(
  'venues',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    ownerId: uuid('owner_id')
      .notNull()
      .references(() => users.id),
    name: varchar('name', { length: 200 }).notNull(),
    nameAr: varchar('name_ar', { length: 200 }),
    description: text('description'),
    descriptionAr: text('description_ar'),
    address: varchar('address', { length: 400 }).notNull(),
    city: varchar('city', { length: 100 }).notNull(),
    latitude: numeric('latitude', { precision: 10, scale: 7 }).notNull(),
    longitude: numeric('longitude', { precision: 10, scale: 7 }).notNull(),
    location: geography('location').notNull(),
    phoneNumber: varchar('phone_number', { length: 20 }),
    rules: text('rules'),
    rulesAr: text('rules_ar'),
    statusId: smallint('status_id')
      .notNull()
      .references(() => venueStatuses.id),
    approvalNote: text('approval_note'),
    approvedBy: uuid('approved_by').references(() => users.id),
    approvedAt: timestamp('approved_at', { withTimezone: true }),
    cancellationPolicyTypeId: smallint('cancellation_policy_type_id')
      .notNull()
      .references(() => cancellationPolicyTypes.id),
    cancellationHoursBefore: smallint('cancellation_hours_before'),
    cancellationPenaltyPercent: smallint('cancellation_penalty_percent'),
    cashSurcharge: numeric('cash_surcharge', { precision: 8, scale: 2 }).notNull().default('10.00'),
    subscriptionPlanId: smallint('subscription_plan_id')
      .notNull()
      .references(() => subscriptionPlanTypes.id),
    subscriptionExpiresAt: timestamp('subscription_expires_at', { withTimezone: true }),
    isFeatured: boolean('is_featured').notNull().default(false),
    featureExpiresAt: timestamp('feature_expires_at', { withTimezone: true }),
    averageRating: numeric('average_rating', { precision: 3, scale: 2 }).default('0'),
    totalReviews: integer('total_reviews').notNull().default(0),
    totalBookings: integer('total_bookings').notNull().default(0),
    searchVector: tsvector('search_vector'),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [
    index('idx_venues_owner_id').on(t.ownerId),
    index('idx_venues_status_id').on(t.statusId),
    index('idx_venues_city').on(t.city),
    index('idx_venues_rating').on(t.averageRating),
    index('idx_venues_featured')
      .on(t.isFeatured)
      .where(sql`is_featured = true`),
    index('idx_venues_status_city').on(t.statusId, t.city),
  ],
);

export type Venue = typeof venues.$inferSelect;
export type NewVenue = typeof venues.$inferInsert;

// 3.2 venue_images
export const venueImages = pgTable('venue_images', {
  id: uuid('id').primaryKey().defaultRandom(),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id, { onDelete: 'cascade' }),
  filePath: text('file_path').notNull(),
  fileSizeBytes: integer('file_size_bytes').notNull(),
  mimeType: varchar('mime_type', { length: 30 }).notNull(),
  widthPx: smallint('width_px'),
  heightPx: smallint('height_px'),
  isPrimary: boolean('is_primary').notNull().default(false),
  sortOrder: smallint('sort_order').notNull().default(0),
  uploadedBy: uuid('uploaded_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 3.3 venue_documents
export const venueDocuments = pgTable('venue_documents', {
  id: uuid('id').primaryKey().defaultRandom(),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id, { onDelete: 'cascade' }),
  documentTypeId: smallint('document_type_id')
    .notNull()
    .references(() => documentTypes.id),
  filePath: text('file_path').notNull(),
  fileSizeBytes: integer('file_size_bytes').notNull(),
  mimeType: varchar('mime_type', { length: 30 }).notNull(),
  status: varchar('status', { length: 20 }).notNull().default('pending'),
  reviewedBy: uuid('reviewed_by').references(() => users.id),
  reviewedAt: timestamp('reviewed_at', { withTimezone: true }),
  rejectionNote: text('rejection_note'),
  uploadedBy: uuid('uploaded_by')
    .notNull()
    .references(() => users.id),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 3.4 venue_amenity_map
export const venueAmenityMap = pgTable(
  'venue_amenity_map',
  {
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id, { onDelete: 'cascade' }),
    amenityId: uuid('amenity_id')
      .notNull()
      .references(() => amenities.id),
    notes: varchar('notes', { length: 200 }),
  },
  (t) => [{ primaryKey: [t.venueId, t.amenityId] }],
);

// 3.5 venue_payment_methods
export const venuePaymentMethods = pgTable(
  'venue_payment_methods',
  {
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id, { onDelete: 'cascade' }),
    paymentMethodTypeId: smallint('payment_method_type_id')
      .notNull()
      .references(() => paymentMethodTypes.id),
  },
  (t) => [{ primaryKey: [t.venueId, t.paymentMethodTypeId] }],
);

// 3.6 venue_approval_history
export const venueApprovalHistory = pgTable('venue_approval_history', {
  id: uuid('id').primaryKey().defaultRandom(),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id, { onDelete: 'cascade' }),
  changedBy: uuid('changed_by')
    .notNull()
    .references(() => users.id),
  oldStatusId: smallint('old_status_id').references(() => venueStatuses.id),
  newStatusId: smallint('new_status_id')
    .notNull()
    .references(() => venueStatuses.id),
  note: text('note'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 3.7 user_favorite_venues
export const userFavoriteVenues = pgTable(
  'user_favorite_venues',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    venueId: uuid('venue_id')
      .notNull()
      .references(() => venues.id, { onDelete: 'cascade' }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [{ primaryKey: [t.userId, t.venueId] }],
);
