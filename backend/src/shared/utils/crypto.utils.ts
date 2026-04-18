import { createHash, randomBytes, randomInt } from 'crypto';

export function hashSha256(value: string): string {
  return createHash('sha256').update(value).digest('hex');
}

export function generateRawToken(): string {
  return randomBytes(64).toString('hex');
}

export function generateOtpCode(): string {
  return randomInt(100000, 1000000).toString();
}
