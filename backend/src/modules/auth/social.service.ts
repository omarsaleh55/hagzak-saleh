import jwt from 'jsonwebtoken';
import jwksClient from 'jwks-rsa';
import { config } from '../../config';
import { UnauthorizedError } from '../../shared/errors';
import type { SocialProviderData } from './token.service';

const appleJwksClient = jwksClient({
  jwksUri: 'https://appleid.apple.com/auth/keys',
  cache: true,
  rateLimit: true,
  jwksRequestsPerMinute: 10,
});

function getApplePublicKey(kid: string): Promise<string> {
  return new Promise((resolve, reject) => {
    appleJwksClient.getSigningKey(kid, (err, key) => {
      if (err || !key) return reject(err ?? new Error('Key not found'));
      resolve(key.getPublicKey());
    });
  });
}

export async function verifyGoogleToken(idToken: string): Promise<SocialProviderData> {
  try {
    const res = await fetch(
      `https://oauth2.googleapis.com/tokeninfo?id_token=${encodeURIComponent(idToken)}`,
    );
    if (!res.ok) throw new Error(`tokeninfo returned ${res.status}`);

    const payload = (await res.json()) as {
      sub?: string;
      email?: string;
      name?: string;
      picture?: string;
      aud?: string;
      iss?: string;
      exp?: string;
    };

    if (!payload.sub) throw new Error('No sub in payload');

    const validAudiences = [config.google.clientId, config.google.androidClientId].filter(Boolean);
    if (!validAudiences.includes(payload.aud ?? '')) {
      throw new Error(`Audience mismatch: ${payload.aud}`);
    }

    return {
      provider: 'google',
      providerUserId: payload.sub,
      email: payload.email ?? null,
      name: payload.name ?? null,
      picture: payload.picture ?? null,
    };
  } catch (err) {
    console.error('[google] verification failed:', (err as Error).message);
    throw new UnauthorizedError('Invalid Google token');
  }
}

export async function verifyFacebookToken(accessToken: string): Promise<SocialProviderData> {
  try {
    const url = `https://graph.facebook.com/me?access_token=${encodeURIComponent(accessToken)}&fields=id,email,name`;
    const res = await fetch(url);
    if (!res.ok) throw new Error('Facebook API error');

    const data = (await res.json()) as {
      id?: string;
      email?: string;
      name?: string;
      error?: unknown;
    };
    if (!data.id) throw new Error('No user id');

    return {
      provider: 'facebook',
      providerUserId: data.id,
      email: data.email ?? null,
      name: data.name ?? null,
      picture: null,
    };
  } catch {
    throw new UnauthorizedError('Invalid Facebook token');
  }
}

export async function verifyAppleToken(idToken: string): Promise<SocialProviderData> {
  try {
    const decoded = jwt.decode(idToken, { complete: true });
    if (!decoded || typeof decoded === 'string') throw new Error('Invalid token format');

    const kid = (decoded.header as { kid?: string }).kid;
    if (!kid) throw new Error('No kid in token header');

    const publicKey = await getApplePublicKey(kid);

    const payload = jwt.verify(idToken, publicKey, {
      algorithms: ['RS256'],
      issuer: 'https://appleid.apple.com',
      audience: config.apple.bundleId || undefined,
    }) as { sub?: string; email?: string };

    if (!payload.sub) throw new Error('No sub in payload');

    return {
      provider: 'apple',
      providerUserId: payload.sub,
      email: payload.email ?? null,
      name: null, // Apple does not return name after first sign-in
      picture: null,
    };
  } catch (err) {
    console.error('[apple] verification failed:', (err as Error).message);
    throw new UnauthorizedError('Invalid Apple token');
  }
}
