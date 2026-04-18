# Hagzak Backend — Local Setup Guide

Follow these steps to get the backend running on your machine.

---

## Prerequisites

Install these before starting:

| Tool | Version | Download |
|------|---------|----------|
| Node.js | 18+ | https://nodejs.org |
| PostgreSQL | 14+ | https://www.postgresql.org/download |
| Git | any | https://git-scm.com |

---

## 1. Clone the Repository

```bash
git clone <repo-url>
cd Hagzak
```

---

## 2. Install Dependencies

```bash
cd backend
npm install
```

---

## 3. Create the Database

Open pgAdmin or psql and create a new database:

```sql
CREATE DATABASE hagzak;
```

---

## 4. Configure Environment Variables

Copy the example env file:

```bash
cp .env.example .env
```

Then open `.env` and fill in your values:

```env
NODE_ENV=development
PORT=3000

# Replace with your local PostgreSQL credentials
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/hagzak

# JWT — keep these as-is for local dev
JWT_ACCESS_SECRET=hagzak_access_secret_change_in_production
JWT_REFRESH_SECRET=hagzak_refresh_secret_change_in_production
JWT_REGISTRATION_SECRET=hagzak_registration_secret_change_in_production
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_DAYS=30

# Bcrypt
BCRYPT_SALT_ROUNDS=12

# OTP
OTP_EXPIRY_MINUTES=5
OTP_MAX_HOURLY_RESENDS=5
OTP_MAX_DAILY_RESENDS=10

# SMTP — use your Gmail or leave blank (OTP will print to console in dev)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_app_password
MAIL_FROM=Hagzak <noreply@hagzak.com>

# Account security
MAX_FAILED_LOGINS=5
LOCK_DURATION_MINUTES=15

# Google Sign-In (ask team lead for values)
GOOGLE_CLIENT_ID=
GOOGLE_ANDROID_CLIENT_ID=

# Brevo SMS (ask team lead for API key)
BREVO_API_KEY=
BREVO_SMS_FROM=Hagzak
```

> Ask the team lead for the real values of `GOOGLE_CLIENT_ID`, `GOOGLE_ANDROID_CLIENT_ID`, and `BREVO_API_KEY`.

---

## 5. Run Migrations

This creates all the database tables:

```bash
npx drizzle-kit migrate
```

You should see:
```
[✓] migrations applied successfully!
```

---

## 6. Start the Server

```bash
npm run dev
```

You should see:
```
✔ Database connected — PostgreSQL ...
Server running on port 3000 [development]
```

---

## 7. Verify It Works

Open Postman or your browser and hit:

```
GET http://localhost:3000/health
```

Expected response:
```json
{ "status": "ok" }
```

---

## 8. Test the APIs

### Register a new user

**Step 1 — Request OTP**
```
POST http://localhost:3000/api/v1/auth/register/request-otp
Content-Type: application/json

{ "email": "test@example.com" }
```
Copy the `registrationToken` from the response.

**Step 2 — Verify OTP**
```
POST http://localhost:3000/api/v1/auth/register/verify-otp
Authorization: Bearer <registrationToken>
Content-Type: application/json

{ "otp": "123456" }
```
> OTP is sent to email. If SMTP is not configured, check the backend console — the OTP is logged there in development.

Continue the remaining registration steps using the `registrationToken` returned at each step.

---

### Login

```
POST http://localhost:3000/api/v1/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "YourPassword1!",
  "deviceId": "my-laptop",
  "deviceName": "Dev Laptop"
}
```

Copy the `accessToken` for authenticated requests.

---

### Authenticated request example

```
GET http://localhost:3000/api/v1/users/me
Authorization: Bearer <accessToken>
```

---

### Google Sign-In (optional)

To test Google Sign-In you need a real Google ID token. Run:

```bash
node scripts/get-google-token.js
```

- Paste the Web Client Secret when prompted (ask team lead)
- Sign in via browser
- Copy the token from terminal
- Use it in:

```
POST http://localhost:3000/api/v1/auth/social/google
Content-Type: application/json

{
  "idToken": "<paste token here>",
  "deviceId": "my-laptop"
}
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `DATABASE_URL` connection error | Check PostgreSQL is running and credentials are correct |
| `migrations applied` but tables missing | Run `npx drizzle-kit migrate` again |
| OTP not received by email | Check SMTP credentials or read OTP from backend console |
| `Invalid Google token` | Token expired (1hr limit) — re-run `get-google-token.js` |
| Port 3000 already in use | Change `PORT` in `.env` or kill the process using that port |

---

## Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start dev server with hot reload |
| `npm run build` | Compile TypeScript |
| `npm run lint` | Run ESLint |
| `npx drizzle-kit migrate` | Apply database migrations |
| `npx drizzle-kit studio` | Open Drizzle Studio (DB browser) |
