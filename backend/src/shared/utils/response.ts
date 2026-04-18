import type { Response } from 'express';

export function successResponse<T>(
  res: Response,
  data: T,
  message = 'Success',
  statusCode = 200,
): Response {
  return res.status(statusCode).json({ success: true, message, data });
}

export function errorResponse(
  res: Response,
  message: string,
  statusCode = 500,
  errors?: unknown,
): Response {
  const body: Record<string, unknown> = { success: false, message };
  if (errors !== undefined) body.errors = errors;
  return res.status(statusCode).json(body);
}
