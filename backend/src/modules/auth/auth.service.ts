import bcrypt from 'bcryptjs';
import { and, eq, isNull } from 'drizzle-orm';
import { db } from '../../db';
import { users, userSessions, userDevices, loginAttempts } from '../../db/schema';
import { config } from '../../config';
import {
  ConflictError,
  ForbiddenError,
  NotFoundError,
  UnauthorizedError,
  UnprocessableEntityError,
} from '../../shared/errors';
import * as tokenService from './token.service';
import type { ProfilePayload, RegistrationTokenPayload, SocialProviderData } from './token.service';
import * as otpService from './otp.service';
import * as emailService from './email.service';
import * as smsService from './sms.service';
import { generateUniqueReferralCode } from '../../shared/utils/referral.utils';

// ─── Lookup ID constants (seeded) ─────────────────────────────────────────────
const ACCOUNT_STATUS = { active: 1, suspended: 2, banned: 3, pending: 4, locked: 5 } as const;

// ─── Helpers ──────────────────────────────────────────────────────────────────
function normalizeEmail(email: string): string {
  return email.toLowerCase().trim();
}

function ageInYears(dob: string): number {
  const birth = new Date(dob);
  const now = new Date();
  let age = now.getFullYear() - birth.getFullYear();
  const m = now.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && now.getDate() < birth.getDate())) age--;
  return age;
}

interface AuthResult {
  user: {
    id: string;
    email: string;
    fullName: string;
    roleId: number;
    accountStatusId: number;
  };
  accessToken: string;
  refreshToken: string;
}

// ─── Registration ─────────────────────────────────────────────────────────────

export async function requestRegistrationOtp(
  rawEmail: string,
  ip: string,
): Promise<{ registrationToken: string }> {
  const email = normalizeEmail(rawEmail);

  const existing = await db.query.users.findFirst({
    where: and(eq(users.email, email), eq(users.emailVerified, true), isNull(users.deletedAt)),
  });
  if (existing) throw new ConflictError('An account with this email already exists');

  await otpService.checkAndIncrementRateLimit(email, ip);
  const rawOtp = await otpService.generateAndStoreOtp(
    email,
    'email',
    'email_registration',
    null,
    ip,
  );
  emailService.sendOtpEmail(email, rawOtp, 'registration');

  const registrationToken = tokenService.signRegistrationToken({ email, step: 'otp_pending' });
  return { registrationToken };
}

export async function resendRegistrationOtp(
  email: string,
  ip: string,
): Promise<{ registrationToken: string }> {
  return requestRegistrationOtp(email, ip);
}

export async function verifyRegistrationOtp(
  email: string,
  otp: string,
): Promise<{ registrationToken: string }> {
  await otpService.verifyOtp(email, 'email_registration', otp);
  const registrationToken = tokenService.signRegistrationToken({ email, step: 'phone_pending' });
  return { registrationToken };
}

export async function requestPhoneOtp(
  email: string,
  phone: string,
  ip: string,
  socialProviderData?: SocialProviderData,
): Promise<{ registrationToken: string }> {
  const existingPhone = await db.query.users.findFirst({
    where: and(eq(users.phoneNumber, phone), isNull(users.deletedAt)),
  });
  if (existingPhone) throw new ConflictError('This phone number is already registered');

  await otpService.checkAndIncrementRateLimit(phone, ip);
  const rawOtp = await otpService.generateAndStoreOtp(
    phone,
    'phone',
    'phone_verification',
    null,
    ip,
  );
  smsService.sendOtpToPhone(phone, rawOtp);

  const registrationToken = tokenService.signRegistrationToken({
    email,
    phone,
    step: 'phone_otp_pending',
    ...(socialProviderData ? { socialProviderData } : {}),
  });
  return { registrationToken };
}

export async function resendPhoneOtp(
  email: string,
  phone: string,
  ip: string,
  socialProviderData?: SocialProviderData,
): Promise<{ registrationToken: string }> {
  return requestPhoneOtp(email, phone, ip, socialProviderData);
}

export async function verifyPhoneOtp(
  email: string,
  phone: string,
  otp: string,
  socialProviderData?: SocialProviderData,
): Promise<{ registrationToken: string }> {
  await otpService.verifyOtp(phone, 'phone_verification', otp);
  const registrationToken = tokenService.signRegistrationToken({
    email,
    phone,
    step: 'profile_pending',
    ...(socialProviderData ? { socialProviderData } : {}),
  });
  return { registrationToken };
}

export function completeProfile(
  email: string,
  phone: string,
  profile: ProfilePayload,
): { registrationToken: string } {
  if (ageInYears(profile.dateOfBirth) < 12) {
    throw new UnprocessableEntityError('You must be at least 12 years old to register');
  }

  if (profile.roleId === 3) {
    throw new ForbiddenError('Admin accounts cannot be self-registered');
  }

  const registrationToken = tokenService.signRegistrationToken({
    email,
    phone,
    step: 'password_pending',
    profile,
  });
  return { registrationToken };
}

export async function createAccount(
  email: string,
  phone: string,
  profile: ProfilePayload,
  password: string,
  ip: string,
  userAgent: string,
  deviceId?: string,
  deviceName?: string,
): Promise<AuthResult> {
  const passwordHash = await bcrypt.hash(password, config.bcrypt.saltRounds);
  const referralCode = await generateUniqueReferralCode();

  // Resolve optional referrer
  let referredByUserId: string | undefined;
  if (profile.referralCode) {
    const referrer = await db.query.users.findFirst({
      where: eq(users.referralCode, profile.referralCode),
    });
    referredByUserId = referrer?.id;
  }

  return db.transaction(async (tx) => {
    const [user] = await tx
      .insert(users)
      .values({
        email,
        emailVerified: true,
        passwordHash,
        fullName: profile.fullName,
        phoneNumber: phone,
        phoneVerified: true,
        dateOfBirth: profile.dateOfBirth,
        gender: profile.gender,
        city: profile.city,
        preferredLanguageId: profile.preferredLanguageId,
        roleId: profile.roleId,
        accountStatusId: ACCOUNT_STATUS.active,
        referralCode,
        referredByUserId,
      })
      .returning();

    const rawRefreshToken = tokenService.generateRawRefreshToken();
    const tokenHash = tokenService.hashToken(rawRefreshToken);
    const expiresAt = new Date(Date.now() + config.jwt.refreshExpiresInDays * 24 * 60 * 60 * 1000);

    const [session] = await tx
      .insert(userSessions)
      .values({
        userId: user.id,
        tokenHash,
        deviceId: deviceId ?? null,
        deviceName: deviceName ?? null,
        userAgent,
        ipAddress: ip,
        expiresAt,
      })
      .returning();

    if (deviceId) {
      await tx
        .insert(userDevices)
        .values({
          userId: user.id,
          deviceFingerprint: deviceId,
          deviceName: deviceName ?? null,
          isTrusted: false,
        })
        .onConflictDoNothing();
    }

    await tx.insert(loginAttempts).values({
      userId: user.id,
      identifier: email,
      ipAddress: ip,
      userAgent,
      deviceFingerprint: deviceId ?? null,
      success: true,
      isNewDevice: true,
      isNewLocation: true,
    });

    const accessToken = tokenService.signAccessToken({
      sub: user.id,
      roleId: user.roleId,
      sessionId: session.id,
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        roleId: user.roleId,
        accountStatusId: user.accountStatusId,
      },
      accessToken,
      refreshToken: rawRefreshToken,
    };
  });
}

// ─── Login ────────────────────────────────────────────────────────────────────

// A dummy hash used for timing-safe comparison when user is not found
const DUMMY_HASH = '$2b$12$invalid.hash.padding.for.timing.safety.xxxxxxxxxx';

export async function login(
  rawEmail: string,
  password: string,
  ip: string,
  userAgent: string,
  deviceId?: string,
  deviceName?: string,
): Promise<AuthResult> {
  const email = normalizeEmail(rawEmail);

  const user = await db.query.users.findFirst({
    where: and(eq(users.email, email), isNull(users.deletedAt)),
  });

  // Timing-safe: always run bcrypt even when user not found
  await bcrypt.compare(password, user?.passwordHash ?? DUMMY_HASH);

  if (!user) throw new UnauthorizedError('Invalid credentials');

  // Auto-unlock check
  const now = new Date();
  if (user.lockedUntil && user.lockedUntil <= now) {
    await db
      .update(users)
      .set({ failedLoginAttempts: 0, lockedUntil: null, accountStatusId: ACCOUNT_STATUS.active })
      .where(eq(users.id, user.id));
    user.failedLoginAttempts = 0;
    user.lockedUntil = null;
    user.accountStatusId = ACCOUNT_STATUS.active;
  }

  if (user.lockedUntil && user.lockedUntil > now) {
    throw new ForbiddenError(`Account locked. Try again after ${user.lockedUntil.toUTCString()}`);
  }

  if (
    user.accountStatusId === ACCOUNT_STATUS.suspended ||
    user.accountStatusId === ACCOUNT_STATUS.banned
  ) {
    throw new ForbiddenError('Your account has been suspended or banned');
  }

  const passwordValid = await bcrypt.compare(password, user.passwordHash ?? '');

  if (!passwordValid) {
    const newAttempts = (user.failedLoginAttempts ?? 0) + 1;
    const isLockout = newAttempts >= config.security.maxFailedLogins;
    const lockedUntil = isLockout
      ? new Date(now.getTime() + config.security.lockDurationMinutes * 60 * 1000)
      : null;

    await db
      .update(users)
      .set({
        failedLoginAttempts: newAttempts,
        ...(isLockout ? { accountStatusId: ACCOUNT_STATUS.locked, lockedUntil } : {}),
      })
      .where(eq(users.id, user.id));

    await db.insert(loginAttempts).values({
      userId: user.id,
      identifier: email,
      ipAddress: ip,
      userAgent,
      deviceFingerprint: deviceId ?? null,
      success: false,
      failureReason: 'invalid_password',
    });

    if (isLockout && lockedUntil) {
      emailService.sendAccountLockedEmail(email, lockedUntil);
    }

    throw new UnauthorizedError('Invalid credentials');
  }

  // Success — reset failed attempts
  await db
    .update(users)
    .set({ failedLoginAttempts: 0, lockedUntil: null, lastLoginAt: now })
    .where(eq(users.id, user.id));

  // New device detection
  let isNewDevice = false;
  if (deviceId) {
    const knownDevice = await db.query.userDevices.findFirst({
      where: and(eq(userDevices.userId, user.id), eq(userDevices.deviceFingerprint, deviceId)),
    });
    isNewDevice = !knownDevice;

    await db
      .insert(userDevices)
      .values({
        userId: user.id,
        deviceFingerprint: deviceId,
        deviceName: deviceName ?? null,
        lastIp: ip,
        lastSeenAt: now,
      })
      .onConflictDoUpdate({
        target: [userDevices.userId, userDevices.deviceFingerprint],
        set: { lastSeenAt: now, lastIp: ip },
      });

    if (isNewDevice) {
      emailService.sendNewDeviceAlert(email, deviceName ?? 'Unknown device', ip, now);
    }
  }

  // New location detection (IP-based)
  const knownIp = await db.query.loginAttempts.findFirst({
    where: and(
      eq(loginAttempts.userId, user.id),
      eq(loginAttempts.ipAddress, ip),
      eq(loginAttempts.success, true),
    ),
  });
  const isNewLocation = !knownIp;
  if (isNewLocation) {
    emailService.sendNewLocationAlert(email, ip, now);
  }

  // Create session
  const rawRefreshToken = tokenService.generateRawRefreshToken();
  const tokenHash = tokenService.hashToken(rawRefreshToken);
  const expiresAt = new Date(now.getTime() + config.jwt.refreshExpiresInDays * 24 * 60 * 60 * 1000);

  const [session] = await db
    .insert(userSessions)
    .values({
      userId: user.id,
      tokenHash,
      deviceId: deviceId ?? null,
      deviceName: deviceName ?? null,
      userAgent,
      ipAddress: ip,
      expiresAt,
    })
    .returning();

  await db.insert(loginAttempts).values({
    userId: user.id,
    identifier: email,
    ipAddress: ip,
    userAgent,
    deviceFingerprint: deviceId ?? null,
    success: true,
    isNewDevice,
    isNewLocation,
  });

  const accessToken = tokenService.signAccessToken({
    sub: user.id,
    roleId: user.roleId,
    sessionId: session.id,
  });

  return {
    user: {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      roleId: user.roleId,
      accountStatusId: user.accountStatusId,
    },
    accessToken,
    refreshToken: rawRefreshToken,
  };
}

// ─── Session Management ───────────────────────────────────────────────────────

export async function refreshSession(
  rawRefreshToken: string,
): Promise<{ accessToken: string; refreshToken: string }> {
  const tokenHash = tokenService.hashToken(rawRefreshToken);
  const now = new Date();

  const session = await db.query.userSessions.findFirst({
    where: eq(userSessions.tokenHash, tokenHash),
  });

  if (!session || session.revokedAt || session.expiresAt <= now) {
    throw new UnauthorizedError('Invalid or expired refresh token');
  }

  // Token rotation
  const newRaw = tokenService.generateRawRefreshToken();
  const newHash = tokenService.hashToken(newRaw);
  const newExpiry = new Date(now.getTime() + config.jwt.refreshExpiresInDays * 24 * 60 * 60 * 1000);

  await db
    .update(userSessions)
    .set({ tokenHash: newHash, expiresAt: newExpiry, lastUsedAt: now })
    .where(eq(userSessions.id, session.id));

  const user = await db.query.users.findFirst({ where: eq(users.id, session.userId) });
  if (!user) throw new UnauthorizedError('User not found');

  const accessToken = tokenService.signAccessToken({
    sub: user.id,
    roleId: user.roleId,
    sessionId: session.id,
  });

  return { accessToken, refreshToken: newRaw };
}

export async function logout(userId: string, rawRefreshToken: string): Promise<void> {
  const tokenHash = tokenService.hashToken(rawRefreshToken);
  await db
    .update(userSessions)
    .set({ revokedAt: new Date(), revokeReason: 'logout' })
    .where(and(eq(userSessions.tokenHash, tokenHash), eq(userSessions.userId, userId)));
}

export async function logoutAll(userId: string): Promise<void> {
  await db
    .update(userSessions)
    .set({ revokedAt: new Date(), revokeReason: 'logout_all' })
    .where(and(eq(userSessions.userId, userId), isNull(userSessions.revokedAt)));
}

// ─── Password Reset ───────────────────────────────────────────────────────────

export async function requestPasswordReset(
  rawEmail: string,
  ip: string,
): Promise<{ registrationToken: string }> {
  const email = normalizeEmail(rawEmail);

  // Always return success to prevent email enumeration
  const user = await db.query.users.findFirst({
    where: and(eq(users.email, email), isNull(users.deletedAt)),
  });

  if (user) {
    try {
      await otpService.checkAndIncrementRateLimit(email, ip);
      const rawOtp = await otpService.generateAndStoreOtp(
        email,
        'email',
        'password_reset',
        user.id,
        ip,
      );
      emailService.sendOtpEmail(email, rawOtp, 'password_reset');
    } catch {
      // Silently ignore rate limit errors to prevent enumeration
    }
  }

  const registrationToken = tokenService.signRegistrationToken({
    email,
    step: 'password_reset_otp_pending',
  });
  return { registrationToken };
}

export async function resetPassword(
  email: string,
  otp: string,
  newPassword: string,
): Promise<void> {
  await otpService.verifyOtp(email, 'password_reset', otp);

  const user = await db.query.users.findFirst({
    where: and(eq(users.email, email), isNull(users.deletedAt)),
  });
  if (!user) throw new NotFoundError('User');

  const passwordHash = await bcrypt.hash(newPassword, config.bcrypt.saltRounds);

  await db.update(users).set({ passwordHash, updatedAt: new Date() }).where(eq(users.id, user.id));

  // Invalidate all sessions
  await db
    .update(userSessions)
    .set({ revokedAt: new Date(), revokeReason: 'password_reset' })
    .where(and(eq(userSessions.userId, user.id), isNull(userSessions.revokedAt)));

  emailService.sendPasswordChangedEmail(email);
}

// ─── Social Login ─────────────────────────────────────────────────────────────

export async function socialLogin(
  provider: 'google' | 'facebook' | 'apple',
  socialData: SocialProviderData,
  ip: string,
  userAgent: string,
  deviceId?: string,
  deviceName?: string,
): Promise<
  | AuthResult
  | {
      requiresProfile: true;
      registrationToken: string;
      socialHints: { name: string | null; email: string | null; picture: string | null };
    }
> {
  const providerIdMap = { google: 1, facebook: 2, apple: 3 } as const;
  const providerId = providerIdMap[provider];

  const existing = await db.query.users.findFirst({
    where: and(
      eq(users.socialProviderId, providerId),
      eq(users.socialProviderUserId, socialData.providerUserId),
      isNull(users.deletedAt),
    ),
  });

  if (existing) {
    // Existing user — issue tokens
    const now = new Date();
    await db.update(users).set({ lastLoginAt: now }).where(eq(users.id, existing.id));

    let isNewDevice = false;
    if (deviceId) {
      const knownDevice = await db.query.userDevices.findFirst({
        where: and(
          eq(userDevices.userId, existing.id),
          eq(userDevices.deviceFingerprint, deviceId),
        ),
      });
      isNewDevice = !knownDevice;
      await db
        .insert(userDevices)
        .values({
          userId: existing.id,
          deviceFingerprint: deviceId,
          deviceName: deviceName ?? null,
          lastIp: ip,
          lastSeenAt: now,
        })
        .onConflictDoUpdate({
          target: [userDevices.userId, userDevices.deviceFingerprint],
          set: { lastSeenAt: now, lastIp: ip },
        });
      if (isNewDevice && existing.email) {
        emailService.sendNewDeviceAlert(existing.email, deviceName ?? 'Unknown device', ip, now);
      }
    }

    // New location detection (IP-based)
    const knownIp = await db.query.loginAttempts.findFirst({
      where: and(
        eq(loginAttempts.userId, existing.id),
        eq(loginAttempts.ipAddress, ip),
        eq(loginAttempts.success, true),
      ),
    });
    if (!knownIp && existing.email) {
      emailService.sendNewLocationAlert(existing.email, ip, now);
    }

    const rawRefreshToken = tokenService.generateRawRefreshToken();
    const tokenHash = tokenService.hashToken(rawRefreshToken);
    const expiresAt = new Date(
      now.getTime() + config.jwt.refreshExpiresInDays * 24 * 60 * 60 * 1000,
    );

    const [session] = await db
      .insert(userSessions)
      .values({
        userId: existing.id,
        tokenHash,
        deviceId: deviceId ?? null,
        deviceName: deviceName ?? null,
        userAgent,
        ipAddress: ip,
        expiresAt,
      })
      .returning();

    const accessToken = tokenService.signAccessToken({
      sub: existing.id,
      roleId: existing.roleId,
      sessionId: session.id,
    });

    return {
      user: {
        id: existing.id,
        email: existing.email,
        fullName: existing.fullName,
        roleId: existing.roleId,
        accountStatusId: existing.accountStatusId,
      },
      accessToken,
      refreshToken: rawRefreshToken,
    };
  }

  // New user — require phone verification then profile completion
  const email = socialData.email ? normalizeEmail(socialData.email) : '';
  const registrationToken = tokenService.signRegistrationToken({
    email,
    step: 'phone_pending',
    socialProviderData: socialData,
  });

  return {
    requiresProfile: true,
    registrationToken,
    socialHints: {
      name: socialData.name,
      email: socialData.email,
      picture: socialData.picture,
    },
  };
}

export async function completeSocialProfile(
  regPayload: RegistrationTokenPayload,
  phone: string,
  profile: ProfilePayload,
  ip: string,
  userAgent: string,
  deviceId?: string,
  deviceName?: string,
): Promise<AuthResult> {
  if (!regPayload.socialProviderData) {
    throw new UnprocessableEntityError('Social provider data missing from registration token');
  }

  const { socialProviderData } = regPayload;
  const providerIdMap = { google: 1, facebook: 2, apple: 3 } as const;
  const providerId = providerIdMap[socialProviderData.provider as keyof typeof providerIdMap] ?? 1;

  if (ageInYears(profile.dateOfBirth) < 12) {
    throw new UnprocessableEntityError('You must be at least 12 years old to register');
  }

  if (profile.roleId === 3) {
    throw new ForbiddenError('Admin accounts cannot be self-registered');
  }

  const existingPhone = await db.query.users.findFirst({
    where: and(eq(users.phoneNumber, phone), isNull(users.deletedAt)),
  });
  if (existingPhone) throw new ConflictError('This phone number is already registered');

  const referralCode = await generateUniqueReferralCode();
  const email = regPayload.email || '';

  return db.transaction(async (tx) => {
    const [user] = await tx
      .insert(users)
      .values({
        email,
        emailVerified: !!regPayload.email,
        passwordHash: null,
        fullName: profile.fullName,
        phoneNumber: phone,
        dateOfBirth: profile.dateOfBirth,
        gender: profile.gender,
        city: profile.city,
        preferredLanguageId: profile.preferredLanguageId,
        roleId: profile.roleId,
        accountStatusId: ACCOUNT_STATUS.active,
        referralCode,
        socialProviderId: providerId,
        socialProviderUserId: socialProviderData.providerUserId,
      })
      .returning();

    const rawRefreshToken = tokenService.generateRawRefreshToken();
    const tokenHash = tokenService.hashToken(rawRefreshToken);
    const expiresAt = new Date(Date.now() + config.jwt.refreshExpiresInDays * 24 * 60 * 60 * 1000);

    const [session] = await tx
      .insert(userSessions)
      .values({
        userId: user.id,
        tokenHash,
        deviceId: deviceId ?? null,
        deviceName: deviceName ?? null,
        userAgent,
        ipAddress: ip,
        expiresAt,
      })
      .returning();

    if (deviceId) {
      await tx
        .insert(userDevices)
        .values({
          userId: user.id,
          deviceFingerprint: deviceId,
          deviceName: deviceName ?? null,
        })
        .onConflictDoNothing();
    }

    const accessToken = tokenService.signAccessToken({
      sub: user.id,
      roleId: user.roleId,
      sessionId: session.id,
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        roleId: user.roleId,
        accountStatusId: user.accountStatusId,
      },
      accessToken,
      refreshToken: rawRefreshToken,
    };
  });
}
