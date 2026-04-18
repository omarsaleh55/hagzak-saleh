import type { NextFunction, Request, Response } from 'express';
import { successResponse } from '../../shared/utils/response';
import * as authService from './auth.service';
import * as socialService from './social.service';
import type { ProfilePayload, RegistrationTokenPayload } from './token.service';

function ip(req: Request): string {
  return (
    (req.headers['x-forwarded-for'] as string | undefined)?.split(',')[0]?.trim() ??
    req.socket.remoteAddress ??
    '0.0.0.0'
  );
}

// ─── Registration ─────────────────────────────────────────────────────────────

export async function requestOtp(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { email } = req.body as { email: string };
    const result = await authService.requestRegistrationOtp(email, ip(req));
    successResponse(res, result, 'OTP sent to your email');
  } catch (err) {
    next(err);
  }
}

export async function resendOtp(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const result = await authService.resendRegistrationOtp(payload.email, ip(req));
    successResponse(res, result, 'OTP resent');
  } catch (err) {
    next(err);
  }
}

export async function verifyOtp(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const { otp } = req.body as { otp: string };
    const result = await authService.verifyRegistrationOtp(payload.email, otp);
    successResponse(res, result, 'Email verified');
  } catch (err) {
    next(err);
  }
}

export async function requestPhoneOtp(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const { phone } = req.body as { phone: string };
    const result = await authService.requestPhoneOtp(
      payload.email,
      phone,
      ip(req),
      payload.socialProviderData,
    );
    successResponse(res, result, 'OTP sent to your phone');
  } catch (err) {
    next(err);
  }
}

export async function resendPhoneOtp(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const result = await authService.resendPhoneOtp(
      payload.email,
      payload.phone!,
      ip(req),
      payload.socialProviderData,
    );
    successResponse(res, result, 'OTP resent to your phone');
  } catch (err) {
    next(err);
  }
}

export async function verifyPhoneOtp(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const { otp } = req.body as { otp: string };
    const result = await authService.verifyPhoneOtp(
      payload.email,
      payload.phone!,
      otp,
      payload.socialProviderData,
    );
    successResponse(res, result, 'Phone number verified');
  } catch (err) {
    next(err);
  }
}

export function completeProfile(req: Request, res: Response, next: NextFunction): void {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const result = authService.completeProfile(
      payload.email,
      payload.phone!,
      req.body as ProfilePayload,
    );
    successResponse(res, result, 'Profile saved');
  } catch (err) {
    next(err);
  }
}

export async function completeRegistration(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const { password } = req.body as { password: string };
    const ua = req.headers['user-agent'] ?? '';
    const { deviceId, deviceName } = req.body as { deviceId?: string; deviceName?: string };

    const result = await authService.createAccount(
      payload.email,
      payload.phone!,
      payload.profile!,
      password,
      ip(req),
      ua,
      deviceId,
      deviceName,
    );
    successResponse(res, result, 'Account created', 201);
  } catch (err) {
    next(err);
  }
}

// ─── Login & Session ──────────────────────────────────────────────────────────

export async function login(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { email, password, deviceId, deviceName } = req.body as {
      email: string;
      password: string;
      deviceId?: string;
      deviceName?: string;
    };
    const ua = req.headers['user-agent'] ?? '';
    const result = await authService.login(email, password, ip(req), ua, deviceId, deviceName);
    successResponse(res, result, 'Login successful');
  } catch (err) {
    next(err);
  }
}

export async function refresh(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { refreshToken } = req.body as { refreshToken: string };
    const result = await authService.refreshSession(refreshToken);
    successResponse(res, result, 'Token refreshed');
  } catch (err) {
    next(err);
  }
}

export async function logout(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { refreshToken } = req.body as { refreshToken: string };
    await authService.logout(req.user!.id, refreshToken);
    successResponse(res, null, 'Logged out');
  } catch (err) {
    next(err);
  }
}

export async function logoutAll(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    await authService.logoutAll(req.user!.id);
    successResponse(res, null, 'All sessions revoked');
  } catch (err) {
    next(err);
  }
}

// ─── Password Reset ───────────────────────────────────────────────────────────

export async function forgotPassword(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { email } = req.body as { email: string };
    const result = await authService.requestPasswordReset(email, ip(req));
    successResponse(res, result, 'If this email exists, a reset code was sent');
  } catch (err) {
    next(err);
  }
}

export async function resetPassword(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const { otp, newPassword } = req.body as { otp: string; newPassword: string };
    await authService.resetPassword(payload.email, otp, newPassword);
    successResponse(res, null, 'Password reset successfully');
  } catch (err) {
    next(err);
  }
}

// ─── Social Login ─────────────────────────────────────────────────────────────

export function socialLogin(
  provider: 'google' | 'facebook' | 'apple',
): (req: Request, res: Response, next: NextFunction) => Promise<void> {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { idToken, deviceId, deviceName } = req.body as {
        idToken: string;
        deviceId?: string;
        deviceName?: string;
      };
      const ua = req.headers['user-agent'] ?? '';

      let socialData;
      if (provider === 'google') socialData = await socialService.verifyGoogleToken(idToken);
      else if (provider === 'facebook')
        socialData = await socialService.verifyFacebookToken(idToken);
      else socialData = await socialService.verifyAppleToken(idToken);

      const result = await authService.socialLogin(
        provider,
        socialData,
        ip(req),
        ua,
        deviceId,
        deviceName,
      );

      if ('requiresProfile' in result) {
        successResponse(res, result, 'Profile completion required');
      } else {
        successResponse(res, result, 'Login successful');
      }
    } catch (err) {
      next(err);
    }
  };
}

export async function completeSocialProfile(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const payload = req.registrationPayload as RegistrationTokenPayload;
    const ua = req.headers['user-agent'] ?? '';
    const { deviceId, deviceName } = req.body as {
      deviceId?: string;
      deviceName?: string;
    };
    // Phone was OTP-verified; use the value stored in the registration token.
    const phone = payload.phone!;

    const result = await authService.completeSocialProfile(
      payload,
      phone,
      req.body as ProfilePayload,
      ip(req),
      ua,
      deviceId,
      deviceName,
    );
    successResponse(res, result, 'Account created', 201);
  } catch (err) {
    next(err);
  }
}
