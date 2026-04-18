import jwt from 'jsonwebtoken';
import { config } from '../../config';
import { hashSha256, generateRawToken } from '../../shared/utils/crypto.utils';
import { UnauthorizedError } from '../../shared/errors';

// ─── Payload Types ────────────────────────────────────────────────────────────

interface AccessTokenPayload {
  sub: string;
  roleId: number;
  sessionId: string;
}

export interface ProfilePayload {
  fullName: string;
  dateOfBirth: string;
  gender: 'male' | 'female';
  city: string;
  preferredLanguageId: number;
  roleId: number;
  referralCode?: string;
}

export interface SocialProviderData {
  provider: string;
  providerUserId: string;
  email: string | null;
  name: string | null;
  picture: string | null;
}

export type RegistrationStep =
  | 'otp_pending'
  | 'phone_pending'
  | 'phone_otp_pending'
  | 'profile_pending'
  | 'password_pending'
  | 'social_profile_pending'
  | 'password_reset_otp_pending';

export interface RegistrationTokenPayload {
  email: string;
  step: RegistrationStep;
  phone?: string;
  profile?: ProfilePayload;
  socialProviderData?: SocialProviderData;
}

// ─── Sign ─────────────────────────────────────────────────────────────────────

export function signAccessToken(payload: AccessTokenPayload): string {
  return jwt.sign(payload, config.jwt.accessSecret, {
    expiresIn: config.jwt.accessExpiresIn as jwt.SignOptions['expiresIn'],
  });
}

export function signRegistrationToken(payload: RegistrationTokenPayload): string {
  return jwt.sign(payload, config.jwt.registrationSecret, {
    expiresIn: config.jwt.registrationExpiresIn as jwt.SignOptions['expiresIn'],
  });
}

// ─── Verify ───────────────────────────────────────────────────────────────────

export function verifyAccessToken(token: string): AccessTokenPayload {
  try {
    return jwt.verify(token, config.jwt.accessSecret) as AccessTokenPayload;
  } catch {
    throw new UnauthorizedError('Invalid or expired access token');
  }
}

export function verifyRegistrationToken(token: string): RegistrationTokenPayload {
  try {
    return jwt.verify(token, config.jwt.registrationSecret) as RegistrationTokenPayload;
  } catch {
    throw new UnauthorizedError('Invalid or expired registration token');
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

export function hashToken(rawToken: string): string {
  return hashSha256(rawToken);
}

export function generateRawRefreshToken(): string {
  return generateRawToken();
}
