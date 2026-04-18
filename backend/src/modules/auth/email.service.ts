import { BrevoClient } from '@getbrevo/brevo';
import { transporter } from '../../config/mailer';
import { config } from '../../config';

// ── Internal send dispatcher ─────────────────────────────────────────────────

interface MailOptions {
  to: string;
  subject: string;
  html: string;
  text: string;
}

async function sendViaBrevo(options: MailOptions): Promise<void> {
  const client = new BrevoClient({ apiKey: config.brevo.apiKey });
  await client.transactionalEmails.sendTransacEmail({
    sender: { email: config.email.from.replace(/.*<(.+)>/, '$1').trim(), name: 'Hagzak' },
    to: [{ email: options.to }],
    subject: options.subject,
    htmlContent: options.html,
    textContent: options.text,
  });
}

async function sendViaSmtp(options: MailOptions): Promise<void> {
  await transporter.sendMail({
    from: config.email.from,
    to: options.to,
    subject: options.subject,
    html: options.html,
    text: options.text,
  });
}

async function send(options: MailOptions): Promise<void> {
  try {
    if (config.email.provider === 'brevo') {
      await sendViaBrevo(options);
    } else {
      await sendViaSmtp(options);
    }
  } catch (err) {
    console.error(`[email/${config.email.provider}] Failed to send email:`, (err as Error).message);
  }
}

// ── Public helpers ────────────────────────────────────────────────────────────

export function sendOtpEmail(
  to: string,
  otp: string,
  purpose: 'registration' | 'password_reset',
): void {
  const subject =
    purpose === 'registration'
      ? `Your Hagzak verification code: ${otp}`
      : `Your Hagzak password reset code: ${otp}`;

  const purposeLabel = purpose === 'registration' ? 'verify your email' : 'reset your password';

  const html = `
    <div style="font-family:sans-serif;max-width:480px;margin:auto">
      <h2 style="color:#1a1a2e">Hagzak — Email Verification</h2>
      <p>Use the code below to ${purposeLabel}. It expires in <strong>5 minutes</strong>.</p>
      <div style="font-size:36px;font-weight:bold;letter-spacing:8px;
                  background:#f4f4f8;padding:16px 24px;border-radius:8px;
                  text-align:center;margin:24px 0">${otp}</div>
      <p style="color:#666;font-size:13px">
        If you did not request this, you can safely ignore this email.
      </p>
    </div>
  `;
  const text = `Your Hagzak code: ${otp}\nExpires in 5 minutes.\nIf you did not request this, ignore this email.`;

  void send({ to, subject, html, text });
}

export function sendNewDeviceAlert(
  to: string,
  deviceName: string,
  ip: string,
  loginTime: Date,
): void {
  const timeStr = loginTime.toUTCString();
  const html = `
    <div style="font-family:sans-serif;max-width:480px;margin:auto">
      <h2 style="color:#1a1a2e">New login detected</h2>
      <p>We noticed a sign-in to your Hagzak account from a new device.</p>
      <table style="border-collapse:collapse;width:100%;margin:16px 0">
        <tr><td style="padding:6px 0;color:#666">Device</td><td><strong>${deviceName || 'Unknown'}</strong></td></tr>
        <tr><td style="padding:6px 0;color:#666">IP Address</td><td><strong>${ip}</strong></td></tr>
        <tr><td style="padding:6px 0;color:#666">Time</td><td><strong>${timeStr}</strong></td></tr>
      </table>
      <p style="color:#666;font-size:13px">
        If this was you, no action is needed. If you did not sign in, please change your
        password immediately.
      </p>
    </div>
  `;
  const text = `New login to your Hagzak account.\nDevice: ${deviceName || 'Unknown'}\nIP: ${ip}\nTime: ${timeStr}\nIf this wasn't you, change your password immediately.`;

  void send({ to, subject: 'New login to your Hagzak account', html, text });
}

export function sendAccountLockedEmail(to: string, unlockTime: Date): void {
  const timeStr = unlockTime.toUTCString();
  const html = `
    <div style="font-family:sans-serif;max-width:480px;margin:auto">
      <h2 style="color:#c0392b">Account temporarily locked</h2>
      <p>Your Hagzak account has been locked due to multiple failed login attempts.</p>
      <p>It will automatically unlock at <strong>${timeStr}</strong>.</p>
      <p style="color:#666;font-size:13px">
        If you did not attempt to log in, please contact support.
      </p>
    </div>
  `;
  const text = `Your Hagzak account is locked until ${timeStr}. Contact support if needed.`;

  void send({ to, subject: 'Your Hagzak account has been temporarily locked', html, text });
}

export function sendNewLocationAlert(to: string, ip: string, loginTime: Date): void {
  const timeStr = loginTime.toUTCString();
  const html = `
    <div style="font-family:sans-serif;max-width:480px;margin:auto">
      <h2 style="color:#1a1a2e">New sign-in location detected</h2>
      <p>We noticed a sign-in to your Hagzak account from an unrecognised IP address.</p>
      <table style="border-collapse:collapse;width:100%;margin:16px 0">
        <tr><td style="padding:6px 0;color:#666">IP Address</td><td><strong>${ip}</strong></td></tr>
        <tr><td style="padding:6px 0;color:#666">Time</td><td><strong>${timeStr}</strong></td></tr>
      </table>
      <p style="color:#666;font-size:13px">
        If this was you, no action is needed. If you did not sign in, please change your
        password immediately.
      </p>
    </div>
  `;
  const text = `New sign-in location on your Hagzak account.\nIP: ${ip}\nTime: ${timeStr}\nIf this wasn't you, change your password immediately.`;

  void send({ to, subject: 'New sign-in location on your Hagzak account', html, text });
}

export function sendPasswordChangedEmail(to: string): void {
  const html = `
    <div style="font-family:sans-serif;max-width:480px;margin:auto">
      <h2 style="color:#1a1a2e">Password changed</h2>
      <p>Your Hagzak account password was recently changed.</p>
      <p>All active sessions have been signed out for your security.</p>
      <p style="color:#666;font-size:13px">
        If you did not make this change, please contact support immediately.
      </p>
    </div>
  `;
  const text = `Your Hagzak password was changed. All sessions have been signed out. Contact support if this wasn't you.`;

  void send({ to, subject: 'Your Hagzak password has been changed', html, text });
}
