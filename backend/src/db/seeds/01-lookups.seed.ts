import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import {
  userRoles,
  accountStatuses,
  languages,
  socialProviders,
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
} from '../schema';

export async function runLookupSeeds(db: NodePgDatabase<Record<string, never>>): Promise<void> {
  console.info('  Seeding lookup tables...');

  // 1.1 user_roles
  await db
    .insert(userRoles)
    .values([
      { id: 1, code: 'player', description: 'Regular player who books courts' },
      { id: 2, code: 'owner', description: 'Venue owner who manages courts' },
      { id: 3, code: 'admin', description: 'Platform administrator' },
    ])
    .onConflictDoNothing();

  // 1.2 account_statuses
  await db
    .insert(accountStatuses)
    .values([
      { id: 1, code: 'active', description: 'Account is active and in good standing' },
      { id: 2, code: 'suspended', description: 'Account suspended by admin' },
      { id: 3, code: 'banned', description: 'Account permanently banned' },
      { id: 4, code: 'pending_verification', description: 'Awaiting email/phone verification' },
      { id: 5, code: 'locked', description: 'Temporarily locked due to failed login attempts' },
    ])
    .onConflictDoNothing();

  // 1.3 languages
  await db
    .insert(languages)
    .values([
      { id: 1, code: 'ar', name: 'Arabic' },
      { id: 2, code: 'en', name: 'English' },
    ])
    .onConflictDoNothing();

  // 1.4 social_providers
  await db
    .insert(socialProviders)
    .values([
      { id: 1, code: 'google' },
      { id: 2, code: 'facebook' },
      { id: 3, code: 'apple' },
    ])
    .onConflictDoNothing();

  // 1.5 venue_statuses
  await db
    .insert(venueStatuses)
    .values([
      { id: 1, code: 'pending' },
      { id: 2, code: 'active' },
      { id: 3, code: 'suspended' },
      { id: 4, code: 'rejected' },
    ])
    .onConflictDoNothing();

  // 1.6 court_statuses
  await db
    .insert(courtStatuses)
    .values([
      { id: 1, code: 'active' },
      { id: 2, code: 'inactive' },
      { id: 3, code: 'maintenance' },
    ])
    .onConflictDoNothing();

  // 1.7 surface_types
  await db
    .insert(surfaceTypes)
    .values([
      { nameEn: 'Grass', nameAr: 'عشب', isActive: true },
      { nameEn: 'Artificial Turf', nameAr: 'عشب صناعي', isActive: true },
      { nameEn: 'Hard Court', nameAr: 'ملعب صلب', isActive: true },
      { nameEn: 'Clay', nameAr: 'طين', isActive: true },
      { nameEn: 'Sand', nameAr: 'رمل', isActive: true },
      { nameEn: 'Rubber', nameAr: 'مطاط', isActive: true },
    ])
    .onConflictDoNothing();

  // 1.8 cancellation_policy_types
  await db
    .insert(cancellationPolicyTypes)
    .values([
      { id: 1, code: 'no_cancellation', description: 'No cancellation allowed after booking' },
      { id: 2, code: 'free_anytime', description: 'Free cancellation at any time' },
      { id: 3, code: 'before_hours', description: 'Free cancellation before specified hours' },
    ])
    .onConflictDoNothing();

  // 1.9 booking_statuses
  await db
    .insert(bookingStatuses)
    .values([
      { id: 1, code: 'pending', description: 'Booking created, awaiting payment' },
      { id: 2, code: 'reserved', description: 'Slot reserved, payment in progress' },
      { id: 3, code: 'confirmed', description: 'Payment received, booking confirmed' },
      { id: 4, code: 'ongoing', description: 'Session currently in progress' },
      { id: 5, code: 'completed', description: 'Session completed successfully' },
      { id: 6, code: 'cancelled', description: 'Booking cancelled' },
      { id: 7, code: 'no_show', description: 'Player did not show up' },
      { id: 8, code: 'refunded', description: 'Payment refunded' },
      { id: 9, code: 'failed', description: 'Booking failed (payment failure, etc.)' },
    ])
    .onConflictDoNothing();

  // 1.10 payment_method_types
  await db
    .insert(paymentMethodTypes)
    .values([
      { id: 1, code: 'paymob_card', label: 'Credit/Debit Card', isOnline: true, isActive: true },
      { id: 2, code: 'paymob_wallet', label: 'Mobile Wallet', isOnline: true, isActive: true },
      { id: 3, code: 'fawry', label: 'Fawry', isOnline: true, isActive: true },
      { id: 4, code: 'cash', label: 'Cash at Venue', isOnline: false, isActive: true },
    ])
    .onConflictDoNothing();

  // 1.11 payment_statuses
  await db
    .insert(paymentStatuses)
    .values([
      { id: 1, code: 'pending' },
      { id: 2, code: 'processing' },
      { id: 3, code: 'paid' },
      { id: 4, code: 'failed' },
      { id: 5, code: 'refunded' },
      { id: 6, code: 'partial_refund' },
      { id: 7, code: 'pending_cash_confirmation' },
    ])
    .onConflictDoNothing();

  // 1.12 promo_code_types
  await db
    .insert(promoCodeTypes)
    .values([
      { id: 1, code: 'fixed' },
      { id: 2, code: 'percentage' },
    ])
    .onConflictDoNothing();

  // 1.13 promo_applicable_to
  await db
    .insert(promoApplicableTo)
    .values([
      { id: 1, code: 'all' },
      { id: 2, code: 'sport_type' },
      { id: 3, code: 'venue' },
      { id: 4, code: 'user_segment' },
    ])
    .onConflictDoNothing();

  // 1.14 points_transaction_types
  await db
    .insert(pointsTransactionTypes)
    .values([
      { id: 1, code: 'earn' },
      { id: 2, code: 'redeem' },
      { id: 3, code: 'expire' },
      { id: 4, code: 'adjust' },
    ])
    .onConflictDoNothing();

  // 1.15 reward_action_types
  await db
    .insert(rewardActionTypes)
    .values([
      {
        code: 'booking_completed',
        labelEn: 'Booking Completed',
        labelAr: 'اكتمال الحجز',
        defaultPoints: 10,
        isActive: true,
      },
      {
        code: 'review_with_photo',
        labelEn: 'Review with Photo',
        labelAr: 'تقييم مع صورة',
        defaultPoints: 15,
        isActive: true,
      },
      {
        code: 'review_without_photo',
        labelEn: 'Review without Photo',
        labelAr: 'تقييم بدون صورة',
        defaultPoints: 5,
        isActive: true,
      },
      {
        code: 'referral_success',
        labelEn: 'Successful Referral',
        labelAr: 'إحالة ناجحة',
        defaultPoints: 50,
        isActive: true,
      },
      {
        code: 'monthly_streak',
        labelEn: 'Monthly Streak Bonus',
        labelAr: 'مكافأة الاستمرارية الشهرية',
        defaultPoints: 100,
        isActive: true,
      },
      {
        code: 'first_booking',
        labelEn: 'First Booking Bonus',
        labelAr: 'مكافأة الحجز الأول',
        defaultPoints: 25,
        isActive: true,
      },
      {
        code: 'admin_adjust',
        labelEn: 'Admin Adjustment',
        labelAr: 'تعديل إداري',
        defaultPoints: 0,
        isActive: true,
      },
    ])
    .onConflictDoNothing();

  // 1.16 message_sender_types
  await db
    .insert(messageSenderTypes)
    .values([
      { id: 1, code: 'user' },
      { id: 2, code: 'ai_assistant' },
      { id: 3, code: 'system' },
    ])
    .onConflictDoNothing();

  // 1.17 message_types
  await db
    .insert(messageTypes)
    .values([
      { id: 1, code: 'text' },
      { id: 2, code: 'image' },
      { id: 3, code: 'file' },
      { id: 4, code: 'voice' },
      { id: 5, code: 'system' },
      { id: 6, code: 'ai_rich_card' },
    ])
    .onConflictDoNothing();

  // 1.18 conversation_types
  await db
    .insert(conversationTypes)
    .values([
      { id: 1, code: 'player_owner' },
      { id: 2, code: 'player_player' },
      { id: 3, code: 'ai_assistant' },
    ])
    .onConflictDoNothing();

  // 1.19 notification_event_types
  await db
    .insert(notificationEventTypes)
    .values([
      {
        code: 'booking_confirmed',
        label: 'Booking Confirmed',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'booking_cancelled',
        label: 'Booking Cancelled',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'booking_reminder',
        label: 'Booking Reminder',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'payment_failed',
        label: 'Payment Failed',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'payment_success',
        label: 'Payment Successful',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'refund_processed',
        label: 'Refund Processed',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'points_earned',
        label: 'Points Earned',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'points_redeemed',
        label: 'Points Redeemed',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'venue_approved',
        label: 'Venue Approved',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'venue_rejected',
        label: 'Venue Rejected',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'new_review',
        label: 'New Review',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'waitlist_available',
        label: 'Waitlist Slot Available',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'new_message',
        label: 'New Message',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'fraud_high_severity',
        label: 'High Severity Fraud Flag',
        supportsPush: true,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'account_locked',
        label: 'Account Locked',
        supportsPush: false,
        supportsEmail: true,
        isActive: true,
      },
      {
        code: 'referral_rewarded',
        label: 'Referral Reward Granted',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'milestone_achieved',
        label: 'Milestone Achieved',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
      {
        code: 'reservation_expiring',
        label: 'Reservation Expiring Soon',
        supportsPush: true,
        supportsEmail: false,
        isActive: true,
      },
    ])
    .onConflictDoNothing();

  // 1.20 notification_channels
  await db
    .insert(notificationChannels)
    .values([
      { id: 1, code: 'push' },
      { id: 2, code: 'email' },
    ])
    .onConflictDoNothing();

  // 1.21 log_types
  await db
    .insert(logTypes)
    .values([
      { id: 1, code: 'api_request' },
      { id: 2, code: 'user_action' },
      { id: 3, code: 'owner_action' },
      { id: 4, code: 'admin_action' },
      { id: 5, code: 'security' },
      { id: 6, code: 'payment' },
      { id: 7, code: 'system_event' },
    ])
    .onConflictDoNothing();

  // 1.22 cancellation_by_types
  await db
    .insert(cancellationByTypes)
    .values([
      { id: 1, code: 'user' },
      { id: 2, code: 'owner' },
      { id: 3, code: 'system' },
      { id: 4, code: 'admin' },
    ])
    .onConflictDoNothing();

  // 1.23 find_player_skill_levels
  await db
    .insert(findPlayerSkillLevels)
    .values([
      { code: 'beginner', labelEn: 'Beginner', labelAr: 'مبتدئ' },
      { code: 'intermediate', labelEn: 'Intermediate', labelAr: 'متوسط' },
      { code: 'advanced', labelEn: 'Advanced', labelAr: 'متقدم' },
    ])
    .onConflictDoNothing();

  // 1.24 find_player_post_statuses
  await db
    .insert(findPlayerPostStatuses)
    .values([
      { id: 1, code: 'open' },
      { id: 2, code: 'full' },
      { id: 3, code: 'cancelled' },
      { id: 4, code: 'completed' },
    ])
    .onConflictDoNothing();

  // 1.25 fraud_flag_types
  await db
    .insert(fraudFlagTypes)
    .values([
      { code: 'multi_account_device', description: 'Multiple accounts on same device' },
      { code: 'rapid_book_cancel', description: 'Rapid booking and cancellation pattern' },
      { code: 'promo_abuse', description: 'Promo code abuse detected' },
      { code: 'reward_manipulation', description: 'Reward points manipulation' },
      { code: 'payment_abuse', description: 'Payment system abuse' },
      { code: 'referral_abuse', description: 'Referral system abuse' },
    ])
    .onConflictDoNothing();

  // 1.26 subscription_plan_types
  await db
    .insert(subscriptionPlanTypes)
    .values([
      {
        id: 1,
        code: 'free',
        label: 'Free Plan',
        monthlyPrice: '0',
        maxActiveCourts: 3,
        isActive: true,
      },
      {
        id: 2,
        code: 'premium',
        label: 'Premium Plan',
        monthlyPrice: '299',
        maxActiveCourts: null,
        isActive: true,
      },
    ])
    .onConflictDoNothing();

  // 1.27 amenities
  await db
    .insert(amenities)
    .values([
      { code: 'parking', labelEn: 'Parking', labelAr: 'موقف سيارات', isActive: true },
      { code: 'lighting', labelEn: 'Lighting', labelAr: 'إضاءة', isActive: true },
      { code: 'showers', labelEn: 'Showers', labelAr: 'دش', isActive: true },
      { code: 'cafe', labelEn: 'Café', labelAr: 'كافيه', isActive: true },
      { code: 'changing_rooms', labelEn: 'Changing Rooms', labelAr: 'غرف تغيير', isActive: true },
      { code: 'wifi', labelEn: 'Wi-Fi', labelAr: 'واي فاي', isActive: true },
      {
        code: 'spectator_seating',
        labelEn: 'Spectator Seating',
        labelAr: 'مقاعد المتفرجين',
        isActive: true,
      },
    ])
    .onConflictDoNothing();

  // 1.28 pricing_labels
  await db
    .insert(pricingLabels)
    .values([
      { code: 'peak', labelEn: 'Peak Hours', labelAr: 'أوقات الذروة' },
      { code: 'off_peak', labelEn: 'Off-Peak Hours', labelAr: 'أوقات خارج الذروة' },
      { code: 'weekend', labelEn: 'Weekend', labelAr: 'عطلة نهاية الأسبوع' },
      { code: 'special_event', labelEn: 'Special Event', labelAr: 'حدث خاص' },
      { code: 'ramadan', labelEn: 'Ramadan', labelAr: 'رمضان' },
    ])
    .onConflictDoNothing();

  // 1.29 document_types
  await db
    .insert(documentTypes)
    .values([
      { code: 'national_id', labelEn: 'National ID', labelAr: 'الرقم القومي' },
      { code: 'business_license', labelEn: 'Business License', labelAr: 'رخصة تجارية' },
      { code: 'commercial_register', labelEn: 'Commercial Register', labelAr: 'السجل التجاري' },
      { code: 'tax_card', labelEn: 'Tax Card', labelAr: 'البطاقة الضريبية' },
    ])
    .onConflictDoNothing();

  console.info('  ✓ Lookup tables seeded');
}
