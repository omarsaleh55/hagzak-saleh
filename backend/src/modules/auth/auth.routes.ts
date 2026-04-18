import { Router, type NextFunction, type Request, type Response } from 'express';
import { z } from 'zod';
import { authenticate } from '../../shared/middleware/authenticate.middleware';
import { UnauthorizedError } from '../../shared/errors';
import { verifyRegistrationToken, type RegistrationStep } from './token.service';
import * as ctrl from './auth.controller';
import { e164PhoneSchema } from '../../shared/utils/phone.utils';

const router = Router();

// ─── Helpers ──────────────────────────────────────────────────────────────────

function validate<T extends z.ZodTypeAny>(schema: T) {
  return (req: Request, res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      res
        .status(422)
        .json({ success: false, message: 'Validation failed', errors: result.error.errors });
      return;
    }
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    req.body = result.data;
    next();
  };
}

function requireRegistrationStep(expectedStep: RegistrationStep) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      return next(new UnauthorizedError('Registration token required'));
    }
    try {
      const payload = verifyRegistrationToken(authHeader.slice(7));
      if (payload.step !== expectedStep) {
        return next(
          new UnauthorizedError(
            `Expected registration step "${expectedStep}", got "${payload.step}"`,
          ),
        );
      }
      req.registrationPayload = payload;
      next();
    } catch (err) {
      next(err);
    }
  };
}

// ─── Zod Schemas ─────────────────────────────────────────────────────────────

const emailSchema = z.object({
  email: z
    .string()
    .email()
    .transform((e) => e.toLowerCase().trim()),
});

const otpSchema = z.object({
  otp: z
    .string()
    .length(6, 'OTP must be exactly 6 digits')
    .regex(/^\d{6}$/),
});

const passwordSchema = z
  .string()
  .min(8, 'Password must be at least 8 characters')
  .max(128)
  .regex(/[A-Z]/, 'Must contain at least one uppercase letter')
  .regex(/[a-z]/, 'Must contain at least one lowercase letter')
  .regex(/[0-9]/, 'Must contain at least one number')
  .regex(/[^A-Za-z0-9]/, 'Must contain at least one special character');

const phoneSchema = z.object({ phone: e164PhoneSchema });

const profileSchema = z.object({
  fullName: z.string().min(1).max(100),
  dateOfBirth: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be YYYY-MM-DD'),
  gender: z.enum(['male', 'female']),
  city: z.string().min(1).max(100),
  preferredLanguageId: z.number().int().min(1).max(2),
  roleId: z.number().int().min(1).max(2),
  referralCode: z.string().optional(),
});

const completeSchema = z
  .object({
    password: passwordSchema,
    confirmPassword: z.string(),
    deviceId: z.string().optional(),
    deviceName: z.string().optional(),
  })
  .refine((d) => d.password === d.confirmPassword, {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
  });

const loginSchema = z.object({
  email: z
    .string()
    .email()
    .transform((e) => e.toLowerCase().trim()),
  password: z.string().min(1),
  deviceId: z.string().optional(),
  deviceName: z.string().optional(),
});

const refreshSchema = z.object({ refreshToken: z.string().min(1) });

const logoutSchema = z.object({ refreshToken: z.string().min(1) });

const forgotSchema = z.object({
  email: z
    .string()
    .email()
    .transform((e) => e.toLowerCase().trim()),
});

const resetSchema = z
  .object({
    otp: z
      .string()
      .length(6)
      .regex(/^\d{6}$/),
    newPassword: passwordSchema,
    confirmPassword: z.string(),
  })
  .refine((d) => d.newPassword === d.confirmPassword, {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
  });

const socialSchema = z.object({
  idToken: z.string().min(1),
  deviceId: z.string().optional(),
  deviceName: z.string().optional(),
});

const socialProfileSchema = profileSchema.extend({
  // Phone is now read from the OTP-verified registration token; body field is optional.
  phone: e164PhoneSchema.optional(),
  email: z
    .string()
    .email()
    .transform((e) => e.toLowerCase().trim())
    .optional(),
  deviceId: z.string().optional(),
  deviceName: z.string().optional(),
});

// ─── Registration Routes ──────────────────────────────────────────────────────

router.post('/register/request-otp', validate(emailSchema), ctrl.requestOtp);

router.post('/register/resend-otp', requireRegistrationStep('otp_pending'), ctrl.resendOtp);

router.post(
  '/register/verify-otp',
  requireRegistrationStep('otp_pending'),
  validate(otpSchema),
  ctrl.verifyOtp,
);

router.post(
  '/register/request-phone-otp',
  requireRegistrationStep('phone_pending'),
  validate(phoneSchema),
  ctrl.requestPhoneOtp,
);

router.post(
  '/register/resend-phone-otp',
  requireRegistrationStep('phone_otp_pending'),
  ctrl.resendPhoneOtp,
);

router.post(
  '/register/verify-phone-otp',
  requireRegistrationStep('phone_otp_pending'),
  validate(otpSchema),
  ctrl.verifyPhoneOtp,
);

router.post(
  '/register/profile',
  requireRegistrationStep('profile_pending'),
  validate(profileSchema),
  ctrl.completeProfile,
);

router.post(
  '/register/complete',
  requireRegistrationStep('password_pending'),
  validate(completeSchema),
  ctrl.completeRegistration,
);

// ─── Login & Session Routes ───────────────────────────────────────────────────

router.post('/login', validate(loginSchema), ctrl.login);

router.post('/refresh', validate(refreshSchema), ctrl.refresh);

router.post('/logout', authenticate, validate(logoutSchema), ctrl.logout);

router.post('/logout-all', authenticate, ctrl.logoutAll);

// ─── Password Reset Routes ────────────────────────────────────────────────────

router.post('/password/forgot', validate(forgotSchema), ctrl.forgotPassword);

router.post(
  '/password/reset',
  requireRegistrationStep('password_reset_otp_pending'),
  validate(resetSchema),
  ctrl.resetPassword,
);

// ─── Social Login Routes ──────────────────────────────────────────────────────

router.post('/social/google', validate(socialSchema), ctrl.socialLogin('google'));

router.post('/social/facebook', validate(socialSchema), ctrl.socialLogin('facebook'));

router.post('/social/apple', validate(socialSchema), ctrl.socialLogin('apple'));

router.post(
  '/social/complete-profile',
  requireRegistrationStep('profile_pending'),
  validate(socialProfileSchema),
  ctrl.completeSocialProfile,
);

export default router;
