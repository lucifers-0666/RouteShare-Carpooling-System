/**
 * Centralized JWT configuration and secret accessor.
 * Strictly enforces that JWT_SECRET comes from environment variables.
 * Fails fast with a clear error if JWT_SECRET is missing.
 */
const getJwtSecret = () => {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.trim() === '') {
    throw new Error('FATAL CONFIGURATION ERROR: JWT_SECRET environment variable is missing.');
  }
  return secret;
};

const getJwtExpiresIn = () => {
  return process.env.JWT_EXPIRES_IN || '7d';
};

module.exports = {
  getJwtSecret,
  getJwtExpiresIn,
};
