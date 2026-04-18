/**
 * Dev helper: gets a real Google id_token via OAuth2 flow.
 * Run: node scripts/get-google-token.js
 *
 * Before running:
 *   1. Go to Google Cloud Console → your Web OAuth client
 *   2. Add  http://localhost:9999/callback  to Authorized redirect URIs
 *   3. Paste your Client Secret when prompted
 */

const http = require('http');
const fs = require('fs');
const readline = require('readline');
const { execSync } = require('child_process');
require('dotenv').config();

const CLIENT_ID = process.env.GOOGLE_CLIENT_ID?.trim();
const REDIRECT_URI = 'http://localhost:9999/callback';
const SCOPES = 'openid email profile';

if (!CLIENT_ID) {
  console.error('GOOGLE_CLIENT_ID not set in .env');
  process.exit(1);
}

const rl = readline.createInterface({ input: process.stdin, output: process.stdout });

rl.question('Paste your Google OAuth Client Secret: ', (CLIENT_SECRET) => {
  rl.close();
  CLIENT_SECRET = CLIENT_SECRET.trim();

  const authUrl =
    `https://accounts.google.com/o/oauth2/v2/auth` +
    `?client_id=${encodeURIComponent(CLIENT_ID)}` +
    `&redirect_uri=${encodeURIComponent(REDIRECT_URI)}` +
    `&response_type=code` +
    `&scope=${encodeURIComponent(SCOPES)}` +
    `&access_type=offline`;

  console.log('\nOpening browser...');
  console.log('If it does not open, paste this URL manually:\n');
  console.log(authUrl + '\n');

  try {
    execSync(`start "" "${authUrl}"`);
  } catch (_) {}

  const server = http.createServer(async (req, res) => {
    const url = new URL(req.url, 'http://localhost:9999');
    const code = url.searchParams.get('code');

    if (!code) {
      res.end('No code received.');
      server.close();
      return;
    }

    res.end('<h2>Done! Check your terminal for the id_token.</h2>');
    server.close();

    const params = new URLSearchParams({
      code,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      redirect_uri: REDIRECT_URI,
      grant_type: 'authorization_code',
    });

    const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: params.toString(),
    });

    const tokens = await tokenRes.json();

    if (!tokens.id_token) {
      console.error('\nFailed to get id_token:', JSON.stringify(tokens, null, 2));
      process.exit(1);
    }

    const outFile = 'google-id-token.txt';
    fs.writeFileSync(outFile, tokens.id_token, 'utf8');
    console.log(`\n✓ Token saved to: ${outFile}`);
    console.log('Open that file, select ALL text, copy it into Postman.');
    console.log('\nToken expires in ~1 hour.\n');
  });

  server.listen(9999, () => {
    console.log('Waiting for Google callback on http://localhost:9999/callback ...');
  });
});
