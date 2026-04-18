import type { NextFunction, Request, Response } from 'express';
import { and, eq, gt, isNull } from 'drizzle-orm';
import { db } from '../../db';
import { users, userSessions } from '../../db/schema';
import { verifyAccessToken } from '../../modules/auth/token.service';
import { ForbiddenError, UnauthorizedError } from '../errors';

const SUSPENDED = 2;
const BANNED = 3;

export async function authenticate(
  req: Request,
  _res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      throw new UnauthorizedError('No token provided');
    }

    const token = authHeader.slice(7);
    const payload = verifyAccessToken(token);

    const now = new Date();
    const session = await db.query.userSessions.findFirst({
      where: and(
        eq(userSessions.id, payload.sessionId),
        isNull(userSessions.revokedAt),
        gt(userSessions.expiresAt, now),
      ),
    });

    if (!session) throw new UnauthorizedError('Session revoked or expired');

    // Fire-and-forget: update lastUsedAt
    void db.update(userSessions).set({ lastUsedAt: now }).where(eq(userSessions.id, session.id));

    const user = await db.query.users.findFirst({
      where: and(eq(users.id, payload.sub), isNull(users.deletedAt)),
    });

    if (!user) throw new ForbiddenError('Account not found');

    if (user.accountStatusId === SUSPENDED || user.accountStatusId === BANNED) {
      throw new ForbiddenError('Account suspended or banned');
    }

    req.user = {
      id: user.id,
      email: user.email,
      roleId: user.roleId,
      sessionId: session.id,
    };

    next();
  } catch (err) {
    next(err);
  }
}

export function requireRole(...roles: number[]) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.user || !roles.includes(req.user.roleId)) {
      return next(new ForbiddenError('Insufficient permissions'));
    }
    next();
  };
}
