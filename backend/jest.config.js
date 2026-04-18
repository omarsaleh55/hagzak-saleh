/** @type {import('jest').Config} */
const config = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  testMatch: ['**/__tests__/**/*.test.ts', '**/tests/**/*.test.ts'],
  setupFiles: ['<rootDir>/jest.setup.ts'],
  // Map ESM-only packages to CJS-compatible mocks
  moduleNameMapper: {
    '^nanoid$': '<rootDir>/src/__mocks__/nanoid.ts',
    '^jwks-rsa$': '<rootDir>/src/__mocks__/jwks-rsa.ts',
  },
  collectCoverageFrom: [
    'src/app.ts',
    'src/config/database.ts',
    'src/config/index.ts',
    'src/db/**/*.ts',
    'src/modules/users/**/*.ts',
    'src/shared/errors/**/*.ts',
    'src/shared/middleware/errorHandler.middleware.ts',
    'src/shared/utils/response.ts',
    '!src/**/*.types.ts',
    '!src/**/*.d.ts',
    '!src/db/migrations/**',
    '!src/db/seeds/**',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['html', 'text', 'lcov'],
  testTimeout: 30000,
};

module.exports = config;

