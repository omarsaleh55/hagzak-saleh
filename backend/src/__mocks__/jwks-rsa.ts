const mockGetSigningKey = jest.fn(
  (_kid: string, cb: (err: Error | null, key?: { getPublicKey: () => string }) => void) => {
    cb(null, { getPublicKey: () => 'mock-public-key' });
  },
);

const JwksClient = jest.fn().mockImplementation(() => ({
  getSigningKey: mockGetSigningKey,
}));

export default JwksClient;
module.exports = JwksClient;
