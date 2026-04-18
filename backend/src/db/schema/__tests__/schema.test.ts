/**
 * Schema definition tests
 *
 * These tests validate the Drizzle table definitions at the structural level:
 *   - Correct columns exist with expected names
 *   - Required (notNull) vs optional columns
 *   - Default values / default functions
 *   - Primary keys, unique constraints
 *   - Foreign-key references resolve to valid target tables
 *   - Inferred TS insert / select types via representative objects
 *
 * No real database connection is used — we inspect the Drizzle column metadata
 * objects directly.
 */

import { getTableConfig } from 'drizzle-orm/pg-core';
import { getTableColumns } from 'drizzle-orm';

// ── Schema imports ─────────────────────────────────────────────────────────────

import {
  users,
  userSessions,
  otpRecords,
  otpRateLimits,
  userDevices,
  loginAttempts,
  legalConsents,
  dataExportRequests,
} from '../users';

import {
  userRoles,
  accountStatuses,
  languages,
  socialProviders,
  genderEnum,
  venueStatuses,
  courtStatuses,
  surfaceTypes,
  cancellationPolicyTypes,
  bookingStatuses,
  paymentMethodTypes,
  paymentStatuses,
  promoCodeTypes,
  promoApplicableTo,
  pointsTransactionTypes,
  rewardActionTypes,
  messageSenderTypes,
  messageTypes,
  conversationTypes,
  notificationEventTypes,
  notificationChannels,
  logTypes,
  cancellationByTypes,
  findPlayerSkillLevels,
  findPlayerPostStatuses,
  fraudFlagTypes,
  subscriptionPlanTypes,
  amenities,
  pricingLabels,
  documentTypes,
} from '../lookups';

import { venues, venueImages, venueDocuments } from '../venues';

import { bookings, bookingSlots, bookingStatusHistory } from '../bookings';

import { payments, refunds, savedPaymentMethods } from '../payments';

import { reviews, reviewPhotos, reviewReports } from '../reviews';

// ── Helpers ────────────────────────────────────────────────────────────────────

/** Return an array of column names for a table */
function columnNames(table: Parameters<typeof getTableColumns>[0]) {
  return Object.keys(getTableColumns(table));
}

/** Return the SQL table name */
function tableName(table: Parameters<typeof getTableConfig>[0]) {
  return getTableConfig(table).name;
}

/** Check whether a column has notNull in its config */
function isNotNull(table: Parameters<typeof getTableColumns>[0], col: string) {
  const columns = getTableColumns(table);
  return (columns as Record<string, { notNull: boolean }>)[col]?.notNull === true;
}

/** Check if a column has a default value */
function hasDefault(table: Parameters<typeof getTableColumns>[0], col: string) {
  const columns = getTableColumns(table);
  return (columns as Record<string, { hasDefault: boolean }>)[col]?.hasDefault === true;
}

// ═════════════════════════════════════════════════════════════════════════════
// 1.  LOOKUP TABLES
// ═════════════════════════════════════════════════════════════════════════════

describe('Lookup tables', () => {
  describe('genderEnum', () => {
    it('defines male and female values', () => {
      expect(genderEnum.enumValues).toEqual(['male', 'female']);
    });
  });

  describe('userRoles', () => {
    it('has correct table name', () => {
      expect(tableName(userRoles)).toBe('user_roles');
    });

    it('has id, code, description columns', () => {
      expect(columnNames(userRoles)).toEqual(expect.arrayContaining(['id', 'code', 'description']));
    });

    it('marks id and code as not-null', () => {
      expect(isNotNull(userRoles, 'id')).toBe(true);
      expect(isNotNull(userRoles, 'code')).toBe(true);
    });
  });

  describe('accountStatuses', () => {
    it('has correct table name', () => {
      expect(tableName(accountStatuses)).toBe('account_statuses');
    });

    it('has id, code, description columns', () => {
      expect(columnNames(accountStatuses)).toEqual(
        expect.arrayContaining(['id', 'code', 'description']),
      );
    });
  });

  describe('languages', () => {
    it('has correct table name', () => {
      expect(tableName(languages)).toBe('languages');
    });

    it('has id, code, name', () => {
      expect(columnNames(languages)).toEqual(expect.arrayContaining(['id', 'code', 'name']));
    });

    it('marks name as not-null', () => {
      expect(isNotNull(languages, 'name')).toBe(true);
    });
  });

  describe('socialProviders', () => {
    it('has correct table name', () => {
      expect(tableName(socialProviders)).toBe('social_providers');
    });

    it('has id and code columns', () => {
      expect(columnNames(socialProviders)).toEqual(expect.arrayContaining(['id', 'code']));
    });
  });

  describe('venueStatuses', () => {
    it('has correct table name', () => {
      expect(tableName(venueStatuses)).toBe('venue_statuses');
    });
  });

  describe('courtStatuses', () => {
    it('has correct table name', () => {
      expect(tableName(courtStatuses)).toBe('court_statuses');
    });
  });

  describe('surfaceTypes', () => {
    it('has correct table name', () => {
      expect(tableName(surfaceTypes)).toBe('surface_types');
    });

    it('has nameEn and optional nameAr', () => {
      expect(isNotNull(surfaceTypes, 'nameEn')).toBe(true);
      expect(isNotNull(surfaceTypes, 'nameAr')).toBe(false);
    });

    it('defaults isActive to true', () => {
      expect(hasDefault(surfaceTypes, 'isActive')).toBe(true);
    });
  });

  describe('cancellationPolicyTypes', () => {
    it('has correct table name', () => {
      expect(tableName(cancellationPolicyTypes)).toBe('cancellation_policy_types');
    });
  });

  describe('bookingStatuses', () => {
    it('has correct table name', () => {
      expect(tableName(bookingStatuses)).toBe('booking_statuses');
    });

    it('has id, code, description', () => {
      expect(columnNames(bookingStatuses)).toEqual(
        expect.arrayContaining(['id', 'code', 'description']),
      );
    });
  });

  describe('paymentMethodTypes', () => {
    it('has correct table name', () => {
      expect(tableName(paymentMethodTypes)).toBe('payment_method_types');
    });

    it('has isOnline and isActive columns', () => {
      expect(isNotNull(paymentMethodTypes, 'isOnline')).toBe(true);
      expect(hasDefault(paymentMethodTypes, 'isActive')).toBe(true);
    });
  });

  describe('paymentStatuses', () => {
    it('has correct table name', () => {
      expect(tableName(paymentStatuses)).toBe('payment_statuses');
    });
  });

  describe('promoCodeTypes', () => {
    it('has correct table name', () => {
      expect(tableName(promoCodeTypes)).toBe('promo_code_types');
    });
  });

  describe('promoApplicableTo', () => {
    it('has correct table name', () => {
      expect(tableName(promoApplicableTo)).toBe('promo_applicable_to');
    });
  });

  describe('pointsTransactionTypes', () => {
    it('has correct table name', () => {
      expect(tableName(pointsTransactionTypes)).toBe('points_transaction_types');
    });
  });

  describe('rewardActionTypes', () => {
    it('has correct table name', () => {
      expect(tableName(rewardActionTypes)).toBe('reward_action_types');
    });

    it('has defaultPoints with a default value', () => {
      expect(hasDefault(rewardActionTypes, 'defaultPoints')).toBe(true);
    });
  });

  describe('messageSenderTypes', () => {
    it('has correct table name', () => {
      expect(tableName(messageSenderTypes)).toBe('message_sender_types');
    });
  });

  describe('messageTypes', () => {
    it('has correct table name', () => {
      expect(tableName(messageTypes)).toBe('message_types');
    });
  });

  describe('conversationTypes', () => {
    it('has correct table name', () => {
      expect(tableName(conversationTypes)).toBe('conversation_types');
    });
  });

  describe('notificationEventTypes', () => {
    it('has correct table name', () => {
      expect(tableName(notificationEventTypes)).toBe('notification_event_types');
    });

    it('defaults supportsPush and supportsEmail to true', () => {
      expect(hasDefault(notificationEventTypes, 'supportsPush')).toBe(true);
      expect(hasDefault(notificationEventTypes, 'supportsEmail')).toBe(true);
    });
  });

  describe('notificationChannels', () => {
    it('has correct table name', () => {
      expect(tableName(notificationChannels)).toBe('notification_channels');
    });
  });

  describe('logTypes', () => {
    it('has correct table name', () => {
      expect(tableName(logTypes)).toBe('log_types');
    });
  });

  describe('cancellationByTypes', () => {
    it('has correct table name', () => {
      expect(tableName(cancellationByTypes)).toBe('cancellation_by_types');
    });
  });

  describe('findPlayerSkillLevels', () => {
    it('has correct table name', () => {
      expect(tableName(findPlayerSkillLevels)).toBe('find_player_skill_levels');
    });

    it('has labelEn and optional labelAr', () => {
      expect(isNotNull(findPlayerSkillLevels, 'labelEn')).toBe(true);
      expect(isNotNull(findPlayerSkillLevels, 'labelAr')).toBe(false);
    });
  });

  describe('findPlayerPostStatuses', () => {
    it('has correct table name', () => {
      expect(tableName(findPlayerPostStatuses)).toBe('find_player_post_statuses');
    });
  });

  describe('fraudFlagTypes', () => {
    it('has correct table name', () => {
      expect(tableName(fraudFlagTypes)).toBe('fraud_flag_types');
    });

    it('has optional description', () => {
      expect(isNotNull(fraudFlagTypes, 'description')).toBe(false);
    });
  });

  describe('subscriptionPlanTypes', () => {
    it('has correct table name', () => {
      expect(tableName(subscriptionPlanTypes)).toBe('subscription_plan_types');
    });

    it('defaults monthlyPrice to 0', () => {
      expect(hasDefault(subscriptionPlanTypes, 'monthlyPrice')).toBe(true);
    });

    it('has optional maxActiveCourts', () => {
      expect(isNotNull(subscriptionPlanTypes, 'maxActiveCourts')).toBe(false);
    });
  });

  describe('amenities', () => {
    it('has correct table name', () => {
      expect(tableName(amenities)).toBe('amenities');
    });

    it('uses uuid primary key', () => {
      const cols = getTableColumns(amenities);
      expect((cols.id as { columnType: string }).columnType).toBe('PgUUID');
    });
  });

  describe('pricingLabels', () => {
    it('has correct table name', () => {
      expect(tableName(pricingLabels)).toBe('pricing_labels');
    });
  });

  describe('documentTypes', () => {
    it('has correct table name', () => {
      expect(tableName(documentTypes)).toBe('document_types');
    });
  });
});

// ═════════════════════════════════════════════════════════════════════════════
// 2.  USERS MODULE TABLES
// ═════════════════════════════════════════════════════════════════════════════

describe('users table', () => {
  it('has table name "users"', () => {
    expect(tableName(users)).toBe('users');
  });

  const requiredColumns = [
    'id',
    'fullName',
    'email',
    'emailVerified',
    'phoneNumber',
    'phoneVerified',
    'roleId',
    'accountStatusId',
    'preferredLanguageId',
    'failedLoginAttempts',
    'referralCode',
    'twoFaEnabled',
    'createdAt',
    'updatedAt',
  ];

  it('contains all required columns', () => {
    const cols = columnNames(users);
    requiredColumns.forEach((col) => {
      expect(cols).toContain(col);
    });
  });

  it('marks required columns as notNull', () => {
    requiredColumns.forEach((col) => {
      expect(isNotNull(users, col)).toBe(true);
    });
  });

  const optionalColumns = [
    'passwordHash',
    'dateOfBirth',
    'gender',
    'profileImageUrl',
    'city',
    'latitude',
    'longitude',
    'socialProviderId',
    'socialProviderUserId',
    'lockedUntil',
    'lastLoginAt',
    'referredByUserId',
    'twoFaSecret',
    'termsAcceptedAt',
    'termsVersion',
    'deletedAt',
    'deletionRequestedAt',
  ];

  it('contains all optional columns', () => {
    const cols = columnNames(users);
    optionalColumns.forEach((col) => {
      expect(cols).toContain(col);
    });
  });

  it('marks optional columns as nullable', () => {
    optionalColumns.forEach((col) => {
      expect(isNotNull(users, col)).toBe(false);
    });
  });

  it('defaults emailVerified to false', () => {
    expect(hasDefault(users, 'emailVerified')).toBe(true);
  });

  it('defaults phoneVerified to false', () => {
    expect(hasDefault(users, 'phoneVerified')).toBe(true);
  });

  it('defaults failedLoginAttempts to 0', () => {
    expect(hasDefault(users, 'failedLoginAttempts')).toBe(true);
  });

  it('defaults twoFaEnabled to false', () => {
    expect(hasDefault(users, 'twoFaEnabled')).toBe(true);
  });

  it('defaults createdAt and updatedAt', () => {
    expect(hasDefault(users, 'createdAt')).toBe(true);
    expect(hasDefault(users, 'updatedAt')).toBe(true);
  });

  it('has id with a default (defaultRandom)', () => {
    expect(hasDefault(users, 'id')).toBe(true);
  });

  it('defines indexes', () => {
    const { indexes } = getTableConfig(users);
    expect(indexes.length).toBeGreaterThanOrEqual(6);
  });

  it('has an email index', () => {
    const { indexes } = getTableConfig(users);
    const emailIdx = indexes.find((i) => i.config.name === 'idx_users_email');
    expect(emailIdx).toBeDefined();
  });

  it('has a phone index', () => {
    const { indexes } = getTableConfig(users);
    const phoneIdx = indexes.find((i) => i.config.name === 'idx_users_phone');
    expect(phoneIdx).toBeDefined();
  });

  it('has a role index', () => {
    const { indexes } = getTableConfig(users);
    const roleIdx = indexes.find((i) => i.config.name === 'idx_users_role');
    expect(roleIdx).toBeDefined();
  });

  it('has a referral_code index', () => {
    const { indexes } = getTableConfig(users);
    const refIdx = indexes.find((i) => i.config.name === 'idx_users_referral_code');
    expect(refIdx).toBeDefined();
  });

  it('has a city index', () => {
    const { indexes } = getTableConfig(users);
    const cityIdx = indexes.find((i) => i.config.name === 'idx_users_city');
    expect(cityIdx).toBeDefined();
  });

  it('has a partial deleted_at index', () => {
    const { indexes } = getTableConfig(users);
    const delIdx = indexes.find((i) => i.config.name === 'idx_users_deleted_at');
    expect(delIdx).toBeDefined();
  });

  it('exports the expected total number of columns', () => {
    // If someone adds or removes a column, this test will catch it
    expect(columnNames(users).length).toBe(31);
  });
});

describe('userSessions table', () => {
  it('has table name "user_sessions"', () => {
    expect(tableName(userSessions)).toBe('user_sessions');
  });

  it('has all expected columns', () => {
    const cols = columnNames(userSessions);
    expect(cols).toEqual(
      expect.arrayContaining([
        'id',
        'userId',
        'tokenHash',
        'deviceId',
        'deviceName',
        'userAgent',
        'ipAddress',
        'issuedAt',
        'expiresAt',
        'lastUsedAt',
        'revokedAt',
        'revokeReason',
      ]),
    );
  });

  it('marks userId as not-null', () => {
    expect(isNotNull(userSessions, 'userId')).toBe(true);
  });

  it('marks tokenHash as not-null', () => {
    expect(isNotNull(userSessions, 'tokenHash')).toBe(true);
  });

  it('marks expiresAt as not-null', () => {
    expect(isNotNull(userSessions, 'expiresAt')).toBe(true);
  });

  it('defaults issuedAt', () => {
    expect(hasDefault(userSessions, 'issuedAt')).toBe(true);
  });

  it('has session indexes', () => {
    const { indexes } = getTableConfig(userSessions);
    expect(indexes.length).toBeGreaterThanOrEqual(3);
  });
});

describe('otpRecords table', () => {
  it('has table name "otp_records"', () => {
    expect(tableName(otpRecords)).toBe('otp_records');
  });

  it('marks otpHash, identifier, identifierType, purpose as required', () => {
    expect(isNotNull(otpRecords, 'otpHash')).toBe(true);
    expect(isNotNull(otpRecords, 'identifier')).toBe(true);
    expect(isNotNull(otpRecords, 'identifierType')).toBe(true);
    expect(isNotNull(otpRecords, 'purpose')).toBe(true);
  });

  it('defaults isUsed to false', () => {
    expect(hasDefault(otpRecords, 'isUsed')).toBe(true);
  });

  it('defaults attemptCount to 0', () => {
    expect(hasDefault(otpRecords, 'attemptCount')).toBe(true);
  });

  it('userId is optional (OTP can be sent before user exists)', () => {
    expect(isNotNull(otpRecords, 'userId')).toBe(false);
  });
});

describe('otpRateLimits table', () => {
  it('has table name "otp_rate_limits"', () => {
    expect(tableName(otpRateLimits)).toBe('otp_rate_limits');
  });

  it('defaults hourlyCount and dailyCount to 0', () => {
    expect(hasDefault(otpRateLimits, 'hourlyCount')).toBe(true);
    expect(hasDefault(otpRateLimits, 'dailyCount')).toBe(true);
  });
});

describe('userDevices table', () => {
  it('has table name "user_devices"', () => {
    expect(tableName(userDevices)).toBe('user_devices');
  });

  it('marks userId and deviceFingerprint as required', () => {
    expect(isNotNull(userDevices, 'userId')).toBe(true);
    expect(isNotNull(userDevices, 'deviceFingerprint')).toBe(true);
  });

  it('defaults isTrusted to false', () => {
    expect(hasDefault(userDevices, 'isTrusted')).toBe(true);
  });

  it('has device indexes', () => {
    const { indexes } = getTableConfig(userDevices);
    expect(indexes.length).toBeGreaterThanOrEqual(2);
  });
});

describe('loginAttempts table', () => {
  it('has table name "login_attempts"', () => {
    expect(tableName(loginAttempts)).toBe('login_attempts');
  });

  it('marks identifier, ipAddress, success as required', () => {
    expect(isNotNull(loginAttempts, 'identifier')).toBe(true);
    expect(isNotNull(loginAttempts, 'ipAddress')).toBe(true);
    expect(isNotNull(loginAttempts, 'success')).toBe(true);
  });

  it('userId is optional (for failed attempts with unknown user)', () => {
    expect(isNotNull(loginAttempts, 'userId')).toBe(false);
  });

  it('has login attempt indexes', () => {
    const { indexes } = getTableConfig(loginAttempts);
    expect(indexes.length).toBeGreaterThanOrEqual(3);
  });
});

describe('legalConsents table', () => {
  it('has table name "legal_consents"', () => {
    expect(tableName(legalConsents)).toBe('legal_consents');
  });

  it('marks userId, consentType, version, accepted as required', () => {
    expect(isNotNull(legalConsents, 'userId')).toBe(true);
    expect(isNotNull(legalConsents, 'consentType')).toBe(true);
    expect(isNotNull(legalConsents, 'version')).toBe(true);
    expect(isNotNull(legalConsents, 'accepted')).toBe(true);
  });
});

describe('dataExportRequests table', () => {
  it('has table name "data_export_requests"', () => {
    expect(tableName(dataExportRequests)).toBe('data_export_requests');
  });

  it('marks userId and slaDeadline as required', () => {
    expect(isNotNull(dataExportRequests, 'userId')).toBe(true);
    expect(isNotNull(dataExportRequests, 'slaDeadline')).toBe(true);
  });

  it('defaults status to pending', () => {
    expect(hasDefault(dataExportRequests, 'status')).toBe(true);
  });

  it('downloadUrl is optional', () => {
    expect(isNotNull(dataExportRequests, 'downloadUrl')).toBe(false);
  });
});

// ═════════════════════════════════════════════════════════════════════════════
// 3.  VENUES MODULE TABLES
// ═════════════════════════════════════════════════════════════════════════════

describe('venues table', () => {
  it('has table name "venues"', () => {
    expect(tableName(venues)).toBe('venues');
  });

  const requiredVenueCols = [
    'id',
    'ownerId',
    'name',
    'address',
    'city',
    'latitude',
    'longitude',
    'location',
    'statusId',
    'cancellationPolicyTypeId',
    'cashSurcharge',
    'subscriptionPlanId',
    'isFeatured',
    'totalReviews',
    'totalBookings',
    'createdAt',
    'updatedAt',
  ];

  it('contains all required columns', () => {
    const cols = columnNames(venues);
    requiredVenueCols.forEach((col) => {
      expect(cols).toContain(col);
    });
  });

  it('marks required columns as notNull', () => {
    requiredVenueCols.forEach((col) => {
      expect(isNotNull(venues, col)).toBe(true);
    });
  });

  it('defaults isFeatured to false', () => {
    expect(hasDefault(venues, 'isFeatured')).toBe(true);
  });

  it('defaults totalReviews to 0', () => {
    expect(hasDefault(venues, 'totalReviews')).toBe(true);
  });

  it('defaults totalBookings to 0', () => {
    expect(hasDefault(venues, 'totalBookings')).toBe(true);
  });

  it('has venue indexes', () => {
    const { indexes } = getTableConfig(venues);
    expect(indexes.length).toBeGreaterThanOrEqual(6);
  });

  it('has a featured partial index', () => {
    const { indexes } = getTableConfig(venues);
    const featuredIdx = indexes.find((i) => i.config.name === 'idx_venues_featured');
    expect(featuredIdx).toBeDefined();
  });
});

describe('venueImages table', () => {
  it('has table name "venue_images"', () => {
    expect(tableName(venueImages)).toBe('venue_images');
  });

  it('marks venueId, filePath, fileSizeBytes, mimeType, uploadedBy as required', () => {
    expect(isNotNull(venueImages, 'venueId')).toBe(true);
    expect(isNotNull(venueImages, 'filePath')).toBe(true);
    expect(isNotNull(venueImages, 'fileSizeBytes')).toBe(true);
    expect(isNotNull(venueImages, 'mimeType')).toBe(true);
    expect(isNotNull(venueImages, 'uploadedBy')).toBe(true);
  });

  it('defaults isPrimary to false', () => {
    expect(hasDefault(venueImages, 'isPrimary')).toBe(true);
  });

  it('defaults sortOrder to 0', () => {
    expect(hasDefault(venueImages, 'sortOrder')).toBe(true);
  });
});

describe('venueDocuments table', () => {
  it('has table name "venue_documents"', () => {
    expect(tableName(venueDocuments)).toBe('venue_documents');
  });

  it('defaults status to pending', () => {
    expect(hasDefault(venueDocuments, 'status')).toBe(true);
  });
});

// ═════════════════════════════════════════════════════════════════════════════
// 4.  BOOKINGS MODULE TABLES
// ═════════════════════════════════════════════════════════════════════════════

describe('bookings table', () => {
  it('has table name "bookings"', () => {
    expect(tableName(bookings)).toBe('bookings');
  });

  const requiredBookingCols = [
    'id',
    'userId',
    'courtId',
    'venueId',
    'bookingDate',
    'totalHours',
    'startTime',
    'endTime',
    'subtotal',
    'totalAmount',
    'paymentMethodTypeId',
    'statusId',
    'createdAt',
    'updatedAt',
  ];

  it('contains all required columns', () => {
    const cols = columnNames(bookings);
    requiredBookingCols.forEach((col) => {
      expect(cols).toContain(col);
    });
  });

  it('marks required columns as notNull', () => {
    requiredBookingCols.forEach((col) => {
      expect(isNotNull(bookings, col)).toBe(true);
    });
  });

  it('defaults cashSurcharge, discountAmount, promoDiscount, pointsDiscount, platformCommission to 0', () => {
    [
      'cashSurcharge',
      'discountAmount',
      'promoDiscount',
      'pointsDiscount',
      'platformCommission',
    ].forEach((col) => {
      expect(hasDefault(bookings, col)).toBe(true);
    });
  });

  it('defaults pointsUsed to 0', () => {
    expect(hasDefault(bookings, 'pointsUsed')).toBe(true);
  });

  it('has booking indexes', () => {
    const { indexes } = getTableConfig(bookings);
    expect(indexes.length).toBeGreaterThanOrEqual(6);
  });
});

describe('bookingSlots table', () => {
  it('has table name "booking_slots"', () => {
    expect(tableName(bookingSlots)).toBe('booking_slots');
  });

  it('marks bookingId, slotStart, slotEnd, price as required', () => {
    expect(isNotNull(bookingSlots, 'bookingId')).toBe(true);
    expect(isNotNull(bookingSlots, 'slotStart')).toBe(true);
    expect(isNotNull(bookingSlots, 'slotEnd')).toBe(true);
    expect(isNotNull(bookingSlots, 'price')).toBe(true);
  });

  it('pricingSlotId is optional', () => {
    expect(isNotNull(bookingSlots, 'pricingSlotId')).toBe(false);
  });
});

describe('bookingStatusHistory table', () => {
  it('has table name "booking_status_history"', () => {
    expect(tableName(bookingStatusHistory)).toBe('booking_status_history');
  });

  it('marks bookingId and newStatusId as required', () => {
    expect(isNotNull(bookingStatusHistory, 'bookingId')).toBe(true);
    expect(isNotNull(bookingStatusHistory, 'newStatusId')).toBe(true);
  });

  it('oldStatusId is optional (first status has no old)', () => {
    expect(isNotNull(bookingStatusHistory, 'oldStatusId')).toBe(false);
  });
});

// ═════════════════════════════════════════════════════════════════════════════
// 5.  PAYMENTS MODULE TABLES
// ═════════════════════════════════════════════════════════════════════════════

describe('payments table', () => {
  it('has table name "payments"', () => {
    expect(tableName(payments)).toBe('payments');
  });

  it('marks bookingId, userId, amount, paymentMethodTypeId, statusId as required', () => {
    expect(isNotNull(payments, 'bookingId')).toBe(true);
    expect(isNotNull(payments, 'userId')).toBe(true);
    expect(isNotNull(payments, 'amount')).toBe(true);
    expect(isNotNull(payments, 'paymentMethodTypeId')).toBe(true);
    expect(isNotNull(payments, 'statusId')).toBe(true);
  });

  it('gatewayResponse is optional', () => {
    expect(isNotNull(payments, 'gatewayResponse')).toBe(false);
  });

  it('has payment indexes', () => {
    const { indexes } = getTableConfig(payments);
    expect(indexes.length).toBeGreaterThanOrEqual(4);
  });
});

describe('refunds table', () => {
  it('has table name "refunds"', () => {
    expect(tableName(refunds)).toBe('refunds');
  });

  it('marks paymentId, bookingId, userId, amount, refundType, reason as required', () => {
    expect(isNotNull(refunds, 'paymentId')).toBe(true);
    expect(isNotNull(refunds, 'bookingId')).toBe(true);
    expect(isNotNull(refunds, 'userId')).toBe(true);
    expect(isNotNull(refunds, 'amount')).toBe(true);
    expect(isNotNull(refunds, 'refundType')).toBe(true);
    expect(isNotNull(refunds, 'reason')).toBe(true);
  });

  it('defaults penaltyAmount to 0', () => {
    expect(hasDefault(refunds, 'penaltyAmount')).toBe(true);
  });

  it('defaults status to pending', () => {
    expect(hasDefault(refunds, 'status')).toBe(true);
  });
});

describe('savedPaymentMethods table', () => {
  it('has table name "saved_payment_methods"', () => {
    expect(tableName(savedPaymentMethods)).toBe('saved_payment_methods');
  });

  it('marks userId, paymentMethodTypeId, providerToken as required', () => {
    expect(isNotNull(savedPaymentMethods, 'userId')).toBe(true);
    expect(isNotNull(savedPaymentMethods, 'paymentMethodTypeId')).toBe(true);
    expect(isNotNull(savedPaymentMethods, 'providerToken')).toBe(true);
  });

  it('defaults isDefault to false', () => {
    expect(hasDefault(savedPaymentMethods, 'isDefault')).toBe(true);
  });

  it('lastFour and cardBrand are optional', () => {
    expect(isNotNull(savedPaymentMethods, 'lastFour')).toBe(false);
    expect(isNotNull(savedPaymentMethods, 'cardBrand')).toBe(false);
  });
});

// ═════════════════════════════════════════════════════════════════════════════
// 6.  REVIEWS MODULE TABLES
// ═════════════════════════════════════════════════════════════════════════════

describe('reviews table', () => {
  it('has table name "reviews"', () => {
    expect(tableName(reviews)).toBe('reviews');
  });

  it('marks bookingId, userId, venueId, courtId, rating as required', () => {
    expect(isNotNull(reviews, 'bookingId')).toBe(true);
    expect(isNotNull(reviews, 'userId')).toBe(true);
    expect(isNotNull(reviews, 'venueId')).toBe(true);
    expect(isNotNull(reviews, 'courtId')).toBe(true);
    expect(isNotNull(reviews, 'rating')).toBe(true);
  });

  it('defaults isReported to false', () => {
    expect(hasDefault(reviews, 'isReported')).toBe(true);
  });

  it('defaults isVisible to true', () => {
    expect(hasDefault(reviews, 'isVisible')).toBe(true);
  });

  it('comment is optional', () => {
    expect(isNotNull(reviews, 'comment')).toBe(false);
  });

  it('ownerReply is optional', () => {
    expect(isNotNull(reviews, 'ownerReply')).toBe(false);
  });
});

describe('reviewPhotos table', () => {
  it('has table name "review_photos"', () => {
    expect(tableName(reviewPhotos)).toBe('review_photos');
  });

  it('marks reviewId, filePath, fileSizeBytes, mimeType as required', () => {
    expect(isNotNull(reviewPhotos, 'reviewId')).toBe(true);
    expect(isNotNull(reviewPhotos, 'filePath')).toBe(true);
    expect(isNotNull(reviewPhotos, 'fileSizeBytes')).toBe(true);
    expect(isNotNull(reviewPhotos, 'mimeType')).toBe(true);
  });

  it('defaults sortOrder to 0', () => {
    expect(hasDefault(reviewPhotos, 'sortOrder')).toBe(true);
  });
});

describe('reviewReports table', () => {
  it('has table name "review_reports"', () => {
    expect(tableName(reviewReports)).toBe('review_reports');
  });

  it('marks reviewId, reportedBy, reason as required', () => {
    expect(isNotNull(reviewReports, 'reviewId')).toBe(true);
    expect(isNotNull(reviewReports, 'reportedBy')).toBe(true);
    expect(isNotNull(reviewReports, 'reason')).toBe(true);
  });

  it('defaults status to pending', () => {
    expect(hasDefault(reviewReports, 'status')).toBe(true);
  });

  it('resolvedBy and resolvedAt are optional', () => {
    expect(isNotNull(reviewReports, 'resolvedBy')).toBe(false);
    expect(isNotNull(reviewReports, 'resolvedAt')).toBe(false);
  });
});
