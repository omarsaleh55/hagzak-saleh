// Unit tests — db is fully mocked, no real DB connection needed

const mockFindFirst = jest.fn();
const mockReturning = jest.fn();
const mockWhere = jest.fn().mockReturnValue({ returning: mockReturning });
const mockSet = jest.fn().mockReturnValue({ where: mockWhere });
const mockDeleteWhere = jest.fn();
const mockFrom = jest.fn();

jest.mock('../../../db', () => ({
  db: {
    query: { users: { findFirst: mockFindFirst } },
    insert: jest.fn().mockReturnValue({
      values: jest.fn().mockReturnValue({ returning: mockReturning }),
    }),
    update: jest.fn().mockReturnValue({ set: mockSet }),
    delete: jest.fn().mockReturnValue({ where: mockDeleteWhere }),
    select: jest.fn().mockReturnValue({ from: mockFrom }),
  },
}));

import { createUser, getAllUsers, getUserById, updateUser, deleteUser } from '../users.service';
import { ConflictError, NotFoundError } from '../../../shared/errors';
import type { NewUser } from '../../../db/schema';

// Minimal valid NewUser object matching all required columns
const validNewUser: NewUser = {
  fullName: 'Alice',
  email: 'alice@test.com',
  phoneNumber: '+201234567890',
  roleId: 1,
  accountStatusId: 1,
  preferredLanguageId: 1,
  referralCode: 'ABC123',
};

const mockUser = {
  id: 'uuid-1',
  ...validNewUser,
  emailVerified: false,
  phoneVerified: false,
  failedLoginAttempts: 0,
  twoFaEnabled: false,
  createdAt: new Date(),
  updatedAt: new Date(),
};

beforeEach(() => jest.clearAllMocks());

// ─── createUser ──────────────────────────────────────────────────────────────

describe('createUser', () => {
  it('creates a user when email is not taken', async () => {
    mockFindFirst.mockResolvedValueOnce(undefined);
    mockReturning.mockResolvedValueOnce([mockUser]);

    const result = await createUser(validNewUser);

    expect(result).toEqual(mockUser);
    expect(mockFindFirst).toHaveBeenCalledTimes(1);
    expect(mockReturning).toHaveBeenCalledTimes(1);
  });

  it('throws ConflictError when email is already taken', async () => {
    mockFindFirst.mockResolvedValueOnce(mockUser);

    await expect(createUser(validNewUser)).rejects.toThrow(ConflictError);
    expect(mockReturning).not.toHaveBeenCalled();
  });

  it('throws ConflictError with correct message', async () => {
    mockFindFirst.mockResolvedValueOnce(mockUser);

    await expect(createUser(validNewUser)).rejects.toThrow('Email already in use');
  });
});

// ─── getAllUsers ──────────────────────────────────────────────────────────────

describe('getAllUsers', () => {
  it('returns an array of users', async () => {
    mockFrom.mockResolvedValueOnce([mockUser]);

    const result = await getAllUsers();

    expect(result).toEqual([mockUser]);
    expect(mockFrom).toHaveBeenCalledTimes(1);
  });

  it('returns an empty array when no users exist', async () => {
    mockFrom.mockResolvedValueOnce([]);

    const result = await getAllUsers();

    expect(result).toEqual([]);
  });
});

// ─── getUserById ─────────────────────────────────────────────────────────────

describe('getUserById', () => {
  it('returns user when found', async () => {
    mockFindFirst.mockResolvedValueOnce(mockUser);

    const result = await getUserById('uuid-1');

    expect(result).toEqual(mockUser);
  });

  it('throws NotFoundError when user does not exist', async () => {
    mockFindFirst.mockResolvedValueOnce(undefined);

    await expect(getUserById('uuid-999')).rejects.toThrow(NotFoundError);
  });

  it('throws NotFoundError with "User" resource label', async () => {
    mockFindFirst.mockResolvedValueOnce(undefined);

    await expect(getUserById('uuid-999')).rejects.toThrow('User not found');
  });
});

// ─── updateUser ──────────────────────────────────────────────────────────────

describe('updateUser', () => {
  it('updates and returns the user', async () => {
    const updated = { ...mockUser, fullName: 'Alice Updated' };
    mockFindFirst.mockResolvedValueOnce(mockUser);
    mockReturning.mockResolvedValueOnce([updated]);

    const result = await updateUser('uuid-1', { fullName: 'Alice Updated' });

    expect(result).toEqual(updated);
    expect(mockSet).toHaveBeenCalledTimes(1);
  });

  it('throws NotFoundError when user does not exist', async () => {
    mockFindFirst.mockResolvedValueOnce(undefined);

    await expect(updateUser('uuid-999', { fullName: 'X' })).rejects.toThrow(NotFoundError);
  });

  it('passes updatedAt in the set call', async () => {
    const updated = { ...mockUser, fullName: 'Alice Updated' };
    mockFindFirst.mockResolvedValueOnce(mockUser);
    mockReturning.mockResolvedValueOnce([updated]);

    await updateUser('uuid-1', { fullName: 'Alice Updated' });

    const setArg = mockSet.mock.calls[0][0];
    expect(setArg).toHaveProperty('updatedAt');
    expect(setArg.updatedAt).toBeInstanceOf(Date);
    expect(setArg.fullName).toBe('Alice Updated');
  });
});

// ─── deleteUser ──────────────────────────────────────────────────────────────

describe('deleteUser', () => {
  it('deletes the user successfully', async () => {
    mockFindFirst.mockResolvedValueOnce(mockUser);
    mockDeleteWhere.mockResolvedValueOnce(undefined);

    await expect(deleteUser('uuid-1')).resolves.toBeUndefined();
    expect(mockDeleteWhere).toHaveBeenCalledTimes(1);
  });

  it('throws NotFoundError when user does not exist', async () => {
    mockFindFirst.mockResolvedValueOnce(undefined);

    await expect(deleteUser('uuid-999')).rejects.toThrow(NotFoundError);
  });

  it('returns undefined on successful delete', async () => {
    mockFindFirst.mockResolvedValueOnce(mockUser);
    mockDeleteWhere.mockResolvedValueOnce(undefined);

    const result = await deleteUser('uuid-1');

    expect(result).toBeUndefined();
  });
});
