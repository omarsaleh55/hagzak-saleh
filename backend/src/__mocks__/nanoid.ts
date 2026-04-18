// Manual CJS mock for nanoid (ESM-only package)
// This avoids the "Cannot use import statement outside a module" error in Jest

import { randomBytes } from 'node:crypto';

export function nanoid(size: number = 21): string {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-';
  const bytes = randomBytes(size);
  let id = '';
  for (let i = 0; i < size; i++) {
    id += alphabet[bytes[i] & 63];
  }
  return id;
}
