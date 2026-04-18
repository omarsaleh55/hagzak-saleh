import * as dotenv from 'dotenv';
dotenv.config();

export const config = {
  app: {
    env: process.env.NODE_ENV ?? 'development',
    port: parseInt(process.env.PORT ?? '3000', 10),
  },
  db: {
    url: process.env.DATABASE_URL!,
  },
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET ?? 'change-me-access',
    refreshSecret: process.env.JWT_REFRESH_SECRET ?? 'change-me-refresh',
    registrationSecret: process.env.JWT_REGISTRATION_SECRET ?? 'change-me-registration',
    accessExpiresIn: process.env.JWT_ACCESS_EXPIRES_IN ?? '1530m',
    refreshExpiresInDays: parseInt(process.env.JWT_REFRESH_EXPIRES_DAYS ?? '730', 10),
    registrationExpiresIn: '10m',
  },
  bcrypt: {
    saltRounds: parseInt(process.env.BCRYPT_SALT_ROUNDS ?? '12', 10),
  },
  otp: {
    expiryMinutes: parseInt(process.env.OTP_EXPIRY_MINUTES ?? '5', 10),
    maxHourlyResends: parseInt(process.env.OTP_MAX_HOURLY_RESENDS ?? '5', 10),
    maxDailyResends: parseInt(process.env.OTP_MAX_DAILY_RESENDS ?? '10', 10),
  },
  email: {
    // 'brevo' uses the Brevo Transactional Email API.
    // 'smtp'  uses nodemailer with the EMAIL_HOST/PORT/USER/PASSWORD vars.
    provider: (process.env.EMAIL_PROVIDER ?? 'smtp') as 'smtp' | 'brevo',
    host: process.env.EMAIL_HOST ?? 'localhost',
    port: parseInt(process.env.EMAIL_PORT ?? '1025', 10),
    secure: process.env.EMAIL_SECURE === 'true',
    user: process.env.EMAIL_USER ?? '',
    pass: process.env.EMAIL_PASSWORD ?? '',
    from: process.env.EMAIL_FROM ?? 'Hagzak <noreply@hagzak.com>',
  },
  security: {
    maxFailedLogins: parseInt(process.env.MAX_FAILED_LOGINS ?? '5', 10),
    lockDurationMinutes: parseInt(process.env.LOCK_DURATION_MINUTES ?? '15', 10),
  },
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID ?? '',
    androidClientId: process.env.GOOGLE_ANDROID_CLIENT_ID ?? '',
  },
  apple: {
    bundleId: process.env.APPLE_BUNDLE_ID ?? '',
  },
  brevo: {
    apiKey: process.env.BREVO_API_KEY ?? '',
    smsFrom: process.env.BREVO_SMS_FROM ?? 'Hagzak',
  },
};

const MIN_BCRYPT_ROUNDS = 12;
if (config.bcrypt.saltRounds < MIN_BCRYPT_ROUNDS) {
  throw new Error(
    `BCRYPT_SALT_ROUNDS must be >= ${MIN_BCRYPT_ROUNDS}, got ${config.bcrypt.saltRounds}`,
  );
}
