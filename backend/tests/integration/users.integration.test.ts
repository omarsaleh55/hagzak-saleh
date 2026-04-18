// Integration tests — hits the real test database via HTTP (supertest)

import request from 'supertest';
import app from '../../src/app';
import { pool } from '../../src/config/database';
import { setupTestTable, clearUsersTable, testPool } from '../helpers/db.helper';

// Valid payload matching all required columns in the users schema
const validUser = {
  fullName: 'Alice',
  email: 'alice@test.com',
  phoneNumber: '+201234567890',
  roleId: 1,
  accountStatusId: 1,
  preferredLanguageId: 1,
  referralCode: 'REF001',
};

const validUser2 = {
  fullName: 'Bob',
  email: 'bob@test.com',
  phoneNumber: '+201234567891',
  roleId: 1,
  accountStatusId: 1,
  preferredLanguageId: 1,
  referralCode: 'REF002',
};

beforeAll(async () => {
  await setupTestTable();
});

afterEach(async () => {
  await clearUsersTable();
});

afterAll(async () => {
  await testPool.end();
  await pool.end();
});

// ─── POST /api/v1/users ───────────────────────────────────────────────────────

describe('POST /api/v1/users', () => {
  it('201 — creates a user and returns it', async () => {
    const res = await request(app).post('/api/v1/users').send(validUser);

    expect(res.status).toBe(201);
    expect(res.body.success).toBe(true);
    expect(res.body.data).toMatchObject({ fullName: 'Alice', email: 'alice@test.com' });
    expect(res.body.data.id).toBeDefined();
  });

  it('409 — returns conflict when email already exists', async () => {
    await request(app).post('/api/v1/users').send(validUser);

    const res = await request(app)
      .post('/api/v1/users')
      .send({
        ...validUser,
        fullName: 'Alice 2',
        phoneNumber: '+201111111111',
        referralCode: 'REF999',
      });

    expect(res.status).toBe(409);
    expect(res.body.success).toBe(false);
  });

  it('422 — returns validation error for missing fullName', async () => {
    const { fullName: _fullName, ...missingName } = validUser;
    const res = await request(app).post('/api/v1/users').send(missingName);

    expect(res.status).toBe(422);
    expect(res.body.success).toBe(false);
  });

  it('422 — returns validation error for invalid email', async () => {
    const res = await request(app)
      .post('/api/v1/users')
      .send({ ...validUser, email: 'not-an-email' });

    expect(res.status).toBe(422);
    expect(res.body.success).toBe(false);
  });

  it('422 — returns validation error for missing phoneNumber', async () => {
    const { phoneNumber: _phoneNumber, ...missingPhone } = validUser;
    const res = await request(app).post('/api/v1/users').send(missingPhone);

    expect(res.status).toBe(422);
    expect(res.body.success).toBe(false);
  });

  it('422 — returns validation error for missing roleId', async () => {
    const { roleId: _roleId, ...missingRole } = validUser;
    const res = await request(app).post('/api/v1/users').send(missingRole);

    expect(res.status).toBe(422);
    expect(res.body.success).toBe(false);
  });

  it('422 — returns validation error for missing referralCode', async () => {
    const { referralCode: _referralCode, ...missingCode } = validUser;
    const res = await request(app).post('/api/v1/users').send(missingCode);

    expect(res.status).toBe(422);
    expect(res.body.success).toBe(false);
  });
});

// ─── GET /api/v1/users ────────────────────────────────────────────────────────

describe('GET /api/v1/users', () => {
  it('200 — returns empty array when no users', async () => {
    const res = await request(app).get('/api/v1/users');

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data).toEqual([]);
  });

  it('200 — returns all users', async () => {
    await request(app).post('/api/v1/users').send(validUser);
    await request(app).post('/api/v1/users').send(validUser2);

    const res = await request(app).get('/api/v1/users');

    expect(res.status).toBe(200);
    expect(res.body.data).toHaveLength(2);
  });
});

// ─── GET /api/v1/users/:id ────────────────────────────────────────────────────

describe('GET /api/v1/users/:id', () => {
  it('200 — returns the user by id', async () => {
    const created = await request(app).post('/api/v1/users').send(validUser);

    const res = await request(app).get(`/api/v1/users/${created.body.data.id}`);

    expect(res.status).toBe(200);
    expect(res.body.data.id).toBe(created.body.data.id);
  });

  it('404 — returns not found for unknown id', async () => {
    const res = await request(app).get('/api/v1/users/00000000-0000-0000-0000-000000000000');

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

// ─── PUT /api/v1/users/:id ────────────────────────────────────────────────────

describe('PUT /api/v1/users/:id', () => {
  it('200 — updates the user fullName', async () => {
    const created = await request(app).post('/api/v1/users').send(validUser);

    const res = await request(app)
      .put(`/api/v1/users/${created.body.data.id}`)
      .send({ fullName: 'Alice Updated' });

    expect(res.status).toBe(200);
    expect(res.body.data.fullName).toBe('Alice Updated');
  });

  it('200 — updates the user email', async () => {
    const created = await request(app).post('/api/v1/users').send(validUser);

    const res = await request(app)
      .put(`/api/v1/users/${created.body.data.id}`)
      .send({ email: 'newalice@test.com' });

    expect(res.status).toBe(200);
    expect(res.body.data.email).toBe('newalice@test.com');
  });

  it('404 — returns not found for unknown id', async () => {
    const res = await request(app)
      .put('/api/v1/users/00000000-0000-0000-0000-000000000000')
      .send({ fullName: 'Ghost' });

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });

  it('422 — returns validation error for invalid email format', async () => {
    const created = await request(app).post('/api/v1/users').send(validUser);

    const res = await request(app)
      .put(`/api/v1/users/${created.body.data.id}`)
      .send({ email: 'bad-email' });

    expect(res.status).toBe(422);
  });
});

// ─── DELETE /api/v1/users/:id ─────────────────────────────────────────────────

describe('DELETE /api/v1/users/:id', () => {
  it('200 — deletes the user successfully', async () => {
    const created = await request(app).post('/api/v1/users').send(validUser);

    const res = await request(app).delete(`/api/v1/users/${created.body.data.id}`);

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
  });

  it('404 — verifies user no longer exists after deletion', async () => {
    const created = await request(app).post('/api/v1/users').send(validUser);

    await request(app).delete(`/api/v1/users/${created.body.data.id}`);

    const res = await request(app).get(`/api/v1/users/${created.body.data.id}`);
    expect(res.status).toBe(404);
  });

  it('404 — returns not found for unknown id', async () => {
    const res = await request(app).delete('/api/v1/users/00000000-0000-0000-0000-000000000000');

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});

// ─── Health check ─────────────────────────────────────────────────────────────

describe('GET /health', () => {
  it('200 — returns ok', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
  });
});

// ─── Unknown routes ───────────────────────────────────────────────────────────

describe('Unknown routes', () => {
  it('404 — returns not found for undefined route', async () => {
    const res = await request(app).get('/api/v1/unknown');
    expect(res.status).toBe(404);
  });
});
