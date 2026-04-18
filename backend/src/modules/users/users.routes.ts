import { Router, type NextFunction, type Request, type Response } from 'express';
import { z } from 'zod';
import * as controller from './users.controller';

const router = Router();

const createSchema = z.object({
  fullName: z.string().min(1).max(100),
  email: z.string().email(),
  phoneNumber: z.string().min(1).max(20),
  roleId: z.number().int().positive(),
  accountStatusId: z.number().int().positive(),
  preferredLanguageId: z.number().int().positive(),
  referralCode: z.string().min(1).max(20),
  // Optional fields
  passwordHash: z.string().optional(),
  emailVerified: z.boolean().optional(),
  phoneVerified: z.boolean().optional(),
  dateOfBirth: z.string().optional(),
  gender: z.enum(['male', 'female']).optional(),
  profileImageUrl: z.string().url().optional(),
  city: z.string().max(100).optional(),
  latitude: z.string().max(20).optional(),
  longitude: z.string().max(20).optional(),
  socialProviderId: z.number().int().positive().optional(),
  socialProviderUserId: z.string().max(255).optional(),
  referredByUserId: z.string().uuid().optional(),
  twoFaEnabled: z.boolean().optional(),
  termsAcceptedAt: z.string().datetime().optional(),
  termsVersion: z.string().max(20).optional(),
});

const updateSchema = z.object({
  fullName: z.string().min(1).max(100).optional(),
  email: z.string().email().optional(),
  phoneNumber: z.string().min(1).max(20).optional(),
  roleId: z.number().int().positive().optional(),
  accountStatusId: z.number().int().positive().optional(),
  preferredLanguageId: z.number().int().positive().optional(),
  referralCode: z.string().min(1).max(20).optional(),
  passwordHash: z.string().optional(),
  emailVerified: z.boolean().optional(),
  phoneVerified: z.boolean().optional(),
  dateOfBirth: z.string().optional(),
  gender: z.enum(['male', 'female']).optional(),
  profileImageUrl: z.string().url().optional(),
  city: z.string().max(100).optional(),
  latitude: z.string().max(20).optional(),
  longitude: z.string().max(20).optional(),
  socialProviderId: z.number().int().positive().optional(),
  socialProviderUserId: z.string().max(255).optional(),
  referredByUserId: z.string().uuid().optional(),
  twoFaEnabled: z.boolean().optional(),
  termsAcceptedAt: z.string().datetime().optional(),
  termsVersion: z.string().max(20).optional(),
});

function validate(schema: z.ZodTypeAny) {
  return (req: Request, _res: Response, next: NextFunction) => {
    try {
      schema.parse(req.body);
      next();
    } catch (err) {
      next(err);
    }
  };
}

router.post('/', validate(createSchema), controller.create);
router.get('/', controller.getAll);
router.get('/:id', controller.getById);
router.put('/:id', validate(updateSchema), controller.update);
router.delete('/:id', controller.remove);

export default router;
