import type { RegistrationTokenPayload } from '../../modules/auth/token.service';

declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string;
        roleId: number;
        sessionId: string;
      };
      registrationPayload?: RegistrationTokenPayload;
    }
  }
}

export {};
