import type { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';
import { AppError } from '../errors';
import { errorResponse } from '../utils/response';

export function errorHandler(err: Error, _req: Request, res: Response, _next: NextFunction): void {
  if (err instanceof AppError) {
    errorResponse(res, err.message, err.statusCode);
    return;
  }
  if (err instanceof ZodError) {
    errorResponse(res, 'Validation failed', 422, err.errors);
    return;
  }
  console.error('[500]', err.message, err.stack);
  errorResponse(res, 'Internal server error', 500);
}

export function notFoundHandler(_req: Request, res: Response): void {
  errorResponse(res, 'Route not found', 404);
}
