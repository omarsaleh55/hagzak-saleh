import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { systemSettings } from '../schema';

export async function runSystemSettingsSeeds(
  db: NodePgDatabase<Record<string, never>>,
): Promise<void> {
  console.info('  Seeding system settings...');

  const settings = [
    // Auth
    {
      key: 'auth.otp_expiry_minutes',
      value: '5',
      valueType: 'integer',
      description: 'OTP lifetime in minutes',
      category: 'auth',
    },
    {
      key: 'auth.otp_resend_limit_hourly',
      value: '5',
      valueType: 'integer',
      description: 'Max OTP resend requests per hour per identifier',
      category: 'auth',
    },
    {
      key: 'auth.otp_resend_limit_daily',
      value: '10',
      valueType: 'integer',
      description: 'Max OTP resend requests per day per identifier',
      category: 'auth',
    },
    {
      key: 'auth.jwt_access_expiry_minutes',
      value: '30',
      valueType: 'integer',
      description: 'JWT access token lifetime in minutes',
      category: 'auth',
    },
    {
      key: 'auth.jwt_refresh_expiry_days',
      value: '30',
      valueType: 'integer',
      description: 'JWT refresh token lifetime in days',
      category: 'auth',
    },
    {
      key: 'auth.max_failed_logins',
      value: '5',
      valueType: 'integer',
      description: 'Max failed login attempts before account lockout',
      category: 'auth',
    },
    {
      key: 'auth.lockout_minutes',
      value: '15',
      valueType: 'integer',
      description: 'Account lockout duration in minutes',
      category: 'auth',
    },
    // Booking
    {
      key: 'booking.reservation_lock_minutes',
      value: '10',
      valueType: 'integer',
      description: 'Temporary reservation hold duration in minutes',
      category: 'booking',
    },
    {
      key: 'booking.max_hours_per_session',
      value: '4',
      valueType: 'integer',
      description: 'Maximum consecutive hours per single booking',
      category: 'booking',
    },
    {
      key: 'booking.no_show_grace_minutes',
      value: '30',
      valueType: 'integer',
      description: 'Grace period before marking a booking as no-show',
      category: 'booking',
    },
    // Payment
    {
      key: 'payment.default_cash_surcharge_egp',
      value: '10',
      valueType: 'decimal',
      description: 'Default cash payment surcharge in EGP',
      category: 'payment',
    },
    // Rewards
    {
      key: 'rewards.points_per_hour',
      value: '10',
      valueType: 'integer',
      description: 'Points earned per booked hour',
      category: 'rewards',
    },
    {
      key: 'rewards.points_expiry_months',
      value: '12',
      valueType: 'integer',
      description: 'Points expiry period in months',
      category: 'rewards',
    },
    {
      key: 'rewards.min_redeem_points',
      value: '50',
      valueType: 'integer',
      description: 'Minimum points required for redemption',
      category: 'rewards',
    },
    {
      key: 'rewards.max_redeem_percent',
      value: '50',
      valueType: 'integer',
      description: 'Maximum percentage of booking value redeemable with points',
      category: 'rewards',
    },
    {
      key: 'rewards.points_to_egp_rate',
      value: '0.10',
      valueType: 'decimal',
      description: 'EGP value per point (100 pts = 10 EGP)',
      category: 'rewards',
    },
    // Waitlist
    {
      key: 'waitlist.response_window_minutes',
      value: '15',
      valueType: 'integer',
      description: 'Window for user to respond to waitlist availability notification',
      category: 'limits',
    },
    // AI
    {
      key: 'ai.max_messages_per_day',
      value: '100',
      valueType: 'integer',
      description: 'Maximum AI chat messages per user per day',
      category: 'notifications',
    },
    // API Rate Limiting
    {
      key: 'api.rate_limit_per_minute',
      value: '60',
      valueType: 'integer',
      description: 'API rate limit per user/IP per minute',
      category: 'limits',
    },
    // Logging & Retention
    {
      key: 'log.api_retention_days',
      value: '90',
      valueType: 'integer',
      description: 'API request log retention period in days',
      category: 'notifications',
    },
    {
      key: 'log.audit_retention_days',
      value: '365',
      valueType: 'integer',
      description: 'Audit log retention period in days',
      category: 'notifications',
    },
    // Chat
    {
      key: 'chat.rate_limit_per_minute',
      value: '10',
      valueType: 'integer',
      description: 'Chat messages per user per minute',
      category: 'limits',
    },
  ];

  await db.insert(systemSettings).values(settings).onConflictDoNothing();

  console.info('  ✓ System settings seeded');
}
