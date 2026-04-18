import bcrypt from 'bcryptjs';
import { and, eq, sql } from 'drizzle-orm';
import { db } from '../../db';
import { otpRecords } from '../../db/schema';
import { generateOtpCode } from '../../shared/utils/crypto.utils';
import { GoneError, TooManyRequestsError, UnauthorizedError } from '../../shared/errors';
import { config } from '../../config';

type OtpPurpose = 'email_registration' | 'password_reset' | 'phone_verification';

export async function generateAndStoreOtp(
  identifier: string,
  identifierType: 'email' | 'phone',
  purpose: OtpPurpose,
  userId: string | null,
  ip: string,
): Promise<string> {
  // Invalidate any prior unused OTPs for this identifier + purpose
  await db
    .update(otpRecords)
    .set({ isUsed: true, usedAt: new Date() })
    .where(
      and(
        eq(otpRecords.identifier, identifier),
        eq(otpRecords.purpose, purpose),
        eq(otpRecords.isUsed, false),
      ),
    );

  const rawOtp = generateOtpCode();
  console.info('>>> OTP CODE:', rawOtp);
  const otpHash = await bcrypt.hash(rawOtp, 8);

  const expiresAt = new Date(Date.now() + config.otp.expiryMinutes * 60 * 1000);

  await db.insert(otpRecords).values({
    userId: userId ?? undefined,
    identifier,
    identifierType,
    otpHash,
    purpose,
    ipAddress: ip,
    expiresAt,
  });

  return rawOtp;
}

export async function verifyOtp(
  identifier: string,
  purpose: OtpPurpose,
  rawOtp: string,
): Promise<void> {
  const record = await db.query.otpRecords.findFirst({
    where: and(
      eq(otpRecords.identifier, identifier),
      eq(otpRecords.purpose, purpose),
      eq(otpRecords.isUsed, false),
    ),
    orderBy: (t, { desc }) => [desc(t.createdAt)],
  });

  if (!record) {
    throw new UnauthorizedError('Invalid or expired OTP');
  }

  if (new Date() > record.expiresAt) {
    throw new GoneError('OTP has expired. Please request a new one.');
  }

  const attemptCount = (record.attemptCount ?? 0) + 1;

  if (attemptCount > 10) {
    throw new TooManyRequestsError('Too many incorrect OTP attempts. Please request a new code.');
  }

  const isValid = await bcrypt.compare(rawOtp, record.otpHash);

  if (!isValid) {
    await db
      .update(otpRecords)
      .set({ attemptCount: attemptCount })
      .where(eq(otpRecords.id, record.id));
    throw new UnauthorizedError('Incorrect OTP');
  }

  await db
    .update(otpRecords)
    .set({ isUsed: true, usedAt: new Date() })
    .where(eq(otpRecords.id, record.id));
}

export async function checkAndIncrementRateLimit(identifier: string, ip: string): Promise<void> {
  const result = await db.execute(sql`
    INSERT INTO otp_rate_limits (
      identifier, identifier_type, ip_address,
      window_hour_start, window_day_start,
      hourly_count, daily_count, updated_at
    )
    VALUES (
      ${identifier}, 'email', ${ip}::inet,
      date_trunc('hour', now()), current_date,
      1, 1, now()
    )
    ON CONFLICT (identifier, identifier_type, window_day_start)
    DO UPDATE SET
      hourly_count = CASE
        WHEN otp_rate_limits.window_hour_start < date_trunc('hour', now()) THEN 1
        ELSE otp_rate_limits.hourly_count + 1
      END,
      window_hour_start = CASE
        WHEN otp_rate_limits.window_hour_start < date_trunc('hour', now())
          THEN date_trunc('hour', now())
        ELSE otp_rate_limits.window_hour_start
      END,
      daily_count = otp_rate_limits.daily_count + 1,
      ip_address = ${ip}::inet,
      updated_at = now()
    RETURNING hourly_count, daily_count
  `);

  const row = result.rows[0] as { hourly_count: number; daily_count: number } | undefined;

  if (!row) return;

  if (row.hourly_count > config.otp.maxHourlyResends) {
    throw new TooManyRequestsError(
      `OTP limit reached. You can request at most ${config.otp.maxHourlyResends} OTPs per hour.`,
    );
  }

  if (row.daily_count > config.otp.maxDailyResends) {
    throw new TooManyRequestsError(
      `Daily OTP limit reached. You can request at most ${config.otp.maxDailyResends} OTPs per day.`,
    );
  }
}
