# Google Sign-In — Changes Made to Make It Work

**Date:** 2026-04-03  
**Branch:** `omarbackend`  
**Endpoint:** `POST /api/v1/auth/social/google`

---

## Summary of the Problem

The Google Sign-In API was returning errors at every step:

1. `origin=null` — HTML test page opened from file system, not a server
2. `no registered origin` — `http://localhost:3000` not added to Google Cloud Console
3. `unauthorized_client` — OAuth Playground redirect URI not registered
4. `deleted_client` — Old Web OAuth client was deleted
5. `Invalid token signature` — Local JWT signature verification failing
6. `500 Internal Server Error` — `location` column missing from DB

---

## File Changes

---

### 1. `backend/src/modules/auth/social.service.ts`

**What changed:** Replaced local JWT signature verification (`google-auth-library`) with Google's hosted tokeninfo endpoint. This removes the dependency on fetching Google's public keys locally, which was causing `Invalid token signature` errors.

**Before:**
```typescript
import { OAuth2Client } from 'google-auth-library';

const googleClient = new OAuth2Client(config.google.clientId);

export async function verifyGoogleToken(idToken: string): Promise<SocialProviderData> {
  try {
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: config.google.clientId,
    });
    const payload = ticket.getPayload();
    if (!payload?.sub) throw new Error('No payload');
    return {
      provider: 'google',
      providerUserId: payload.sub,
      email: payload.email ?? null,
      name: payload.name ?? null,
    };
  } catch {
    throw new UnauthorizedError('Invalid Google token');
  }
}
```

**After:**
```typescript
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
      aud?: string;
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
    };
  } catch (err) {
    console.error('[google] verification failed:', (err as Error).message);
    throw new UnauthorizedError('Invalid Google token');
  }
}
```

---

### 2. `backend/src/config/index.ts`

**What changed:** Added `androidClientId` to the `google` config block to support tokens from the Android app.

**Before:**
```typescript
google: {
  clientId: process.env.GOOGLE_CLIENT_ID ?? '',
},
```

**After:**
```typescript
google: {
  clientId: process.env.GOOGLE_CLIENT_ID ?? '',
  androidClientId: process.env.GOOGLE_ANDROID_CLIENT_ID ?? '',
},
```

---

### 3. `backend/.env`

**What changed:** Updated `GOOGLE_CLIENT_ID` to the new Web OAuth client, added `GOOGLE_ANDROID_CLIENT_ID`.

**Before:**
```env
GOOGLE_CLIENT_ID=266939416736-8flt6v4hpv156a2a8e03r48g9jb73cnl.apps.googleusercontent.com
```

**After:**
```env
GOOGLE_CLIENT_ID=266939416736-2upknulopogd3eqvvjqbl7ngs0db9877.apps.googleusercontent.com
GOOGLE_ANDROID_CLIENT_ID=266939416736-rb17ikr4u5rbrgns3aoutq199dhcpg8j.apps.googleusercontent.com
```

---

### 4. `backend/src/db/schema/users.ts`

**What changed:** Removed the `location` geography column. It was defined in the schema but never created in the database and never used in any query, causing every DB query on the `users` table to fail with `Failed query`.

**Before:**
```typescript
import { geography } from './types';

// inside users table:
latitude: varchar('latitude', { length: 20 }),
longitude: varchar('longitude', { length: 20 }),
location: geography('location'),
```

**After:**
```typescript
// geography import removed

// inside users table:
latitude: varchar('latitude', { length: 20 }),
longitude: varchar('longitude', { length: 20 }),
// location column removed
```

---

### 5. `backend/src/db/schema/venues.ts`

**What changed:** Same fix as users — removed the unused `location` geography column.

**Before:**
```typescript
import { geography, tsvector } from './types';

// inside venues table:
location: geography('location').notNull(),
```

**After:**
```typescript
import { tsvector } from './types';

// location column removed
```

---

### 6. `backend/src/db/migrate.ts`

**What changed:** Removed PostGIS extension setup since no geography columns remain in the schema.

**Before:**
```typescript
// PostGIS: geography(POINT) columns on users + venues
await client.query(`CREATE EXTENSION IF NOT EXISTS postgis;`);
console.info('  ✓ postgis');
```

**After:**
```typescript
// PostGIS block removed
```

---

### 7. `backend/src/shared/middleware/errorHandler.middleware.ts`

**What changed:** Added `console.error` logging for unhandled 500 errors to make debugging easier.

**Before:**
```typescript
errorResponse(res, 'Internal server error', 500);
```

**After:**
```typescript
console.error('[500]', err.message, err.stack);
errorResponse(res, 'Internal server error', 500);
```

---

### 8. `backend/src/app.ts`

**What changed:** Added static file serving for the `/dev` route (used for the browser-based Google test page).

**Added line:**
```typescript
app.use('/dev', express.static(path.join(__dirname, '..', 'public')));
```

---

### 9. `backend/scripts/get-google-token.js` *(New File)*

**What it does:** A developer utility script that runs a local OAuth2 flow to get a real Google `id_token` for Postman testing. It starts a local server on port 9999, opens the browser for Google sign-in, then prints the token to a file (`google-id-token.txt`).

**How to use:**
```bash
node scripts/get-google-token.js
# Paste the Web Client Secret when prompted
# Sign in via the browser that opens
# Copy token from google-id-token.txt into Postman
```

**Requires:** `http://localhost:9999/callback` added to Authorized Redirect URIs in Google Cloud Console.

---

## Google Cloud Console Setup Required

Two OAuth clients are needed:

| Client Type | Client ID | Purpose |
|-------------|-----------|---------|
| Web application | `266939416736-2upknulopogd3eqvvjqbl7ngs0db9877` | Backend token verification + dev testing |
| Android | `266939416736-rb17ikr4u5rbrgns3aoutq199dhcpg8j` | Flutter Android app |

**Settings on the Web client:**
- Authorized redirect URIs: `http://localhost:9999/callback`
- Test users: add developer emails under OAuth consent screen → Audience

---

## How to Test (Postman)

**Step 1 — Get a token:**
```bash
cd backend
node scripts/get-google-token.js
```

**Step 2 — Send to API:**
```
POST http://localhost:3000/api/v1/auth/social/google
Content-Type: application/json

{
  "idToken": "<paste contents of google-id-token.txt>",
  "deviceId": "test-device-001",
  "deviceName": "Postman"
}
```

**Expected response (new user):**
```json
{
  "success": true,
  "message": "Profile completion required",
  "data": {
    "requiresProfile": true,
    "registrationToken": "eyJ..."
  }
}
```

**Expected response (returning user):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "eyJ...",
    "refreshToken": "eyJ..."
  }
}
```

---

## Root Cause Summary

| # | Problem | Root Cause | Fix |
|---|---------|------------|-----|
| 1 | `Invalid token signature` | `google-auth-library` local key verification failing | Switched to Google tokeninfo endpoint |
| 2 | `500 Internal Server Error` | `location` column in Drizzle schema but not in DB | Removed `location` from schema |
| 3 | `deleted_client` | Old Web OAuth client deleted from Google Cloud Console | Created new Web OAuth client |
| 4 | `no registered origin` | `http://localhost:3000` not in authorized JS origins | Added to Google Cloud Console |
