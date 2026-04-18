import {
  pgTable,
  uuid,
  varchar,
  text,
  boolean,
  smallint,
  integer,
  timestamp,
  unique,
} from 'drizzle-orm/pg-core';
import { users } from './users';
import { venues } from './venues';
import { courts } from './courts';
import { bookings } from './bookings';

// 10.1 reviews
export const reviews = pgTable('reviews', {
  id: uuid('id').primaryKey().defaultRandom(),
  bookingId: uuid('booking_id')
    .notNull()
    .unique()
    .references(() => bookings.id),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  venueId: uuid('venue_id')
    .notNull()
    .references(() => venues.id),
  courtId: uuid('court_id')
    .notNull()
    .references(() => courts.id),
  rating: smallint('rating').notNull(),
  comment: varchar('comment', { length: 1000 }),
  ownerReply: text('owner_reply'),
  ownerRepliedAt: timestamp('owner_replied_at', { withTimezone: true }),
  isReported: boolean('is_reported').notNull().default(false),
  isVisible: boolean('is_visible').notNull().default(true),
  editedAt: timestamp('edited_at', { withTimezone: true }),
  deletedAt: timestamp('deleted_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export type Review = typeof reviews.$inferSelect;
export type NewReview = typeof reviews.$inferInsert;

// 10.2 review_photos
export const reviewPhotos = pgTable('review_photos', {
  id: uuid('id').primaryKey().defaultRandom(),
  reviewId: uuid('review_id')
    .notNull()
    .references(() => reviews.id, { onDelete: 'cascade' }),
  filePath: text('file_path').notNull(),
  fileSizeBytes: integer('file_size_bytes').notNull(),
  mimeType: varchar('mime_type', { length: 30 }).notNull(),
  sortOrder: smallint('sort_order').notNull().default(0),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

// 10.3 review_reports
export const reviewReports = pgTable(
  'review_reports',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    reviewId: uuid('review_id')
      .notNull()
      .references(() => reviews.id, { onDelete: 'cascade' }),
    reportedBy: uuid('reported_by')
      .notNull()
      .references(() => users.id),
    reason: varchar('reason', { length: 200 }).notNull(),
    status: varchar('status', { length: 20 }).notNull().default('pending'),
    resolvedBy: uuid('resolved_by').references(() => users.id),
    resolvedAt: timestamp('resolved_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [unique('uq_review_report').on(t.reviewId, t.reportedBy)],
);
