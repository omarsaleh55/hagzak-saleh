import { BrevoClient, Brevo } from '@getbrevo/brevo';
import { config } from '../../config';

function createClient() {
  return new BrevoClient({ apiKey: config.brevo.apiKey });
}

/**
 * Send OTP via Brevo transactional SMS.
 * Fire-and-forget — never throws to caller.
 *
 * In development the OTP is printed to the terminal instead of calling
 * Brevo, so the feature works without SMS credits.
 */
export function sendOtpToPhone(to: string, otp: string): void {
  if (config.app.env === 'development') {
    console.info(`\n┌─ [SMS DEV] ──────────────────────────┐`);
    console.info(`│  To  : ${to}`);
    console.info(`│  OTP : ${otp}`);
    console.info(`└──────────────────────────────────────┘\n`);
    return;
  }

  void (async () => {
    try {
      const client = createClient();
      await client.transactionalSms.sendAsyncTransactionalSms({
        sender: config.brevo.smsFrom,
        recipient: to,
        content: `Your Hagzak verification code: ${otp}\nExpires in 5 minutes. Do not share this code.`,
        type: Brevo.SendTransacSms.Type.Transactional,
      });
    } catch (err) {
      console.error('[sms] Brevo SMS delivery failed:', (err as Error).message);
    }
  })();
}
