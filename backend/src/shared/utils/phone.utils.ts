import { z } from 'zod';

export const e164PhoneSchema = z
  .string()
  .regex(/^\+[1-9]\d{7,14}$/, 'Phone number must be in E.164 format (e.g. +966501234567)');
