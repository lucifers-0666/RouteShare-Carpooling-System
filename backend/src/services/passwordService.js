const crypto = require('crypto');

class PasswordService {
  /**
   * Generates a random crypto reset token and its hashed counterpart.
   */
  generateResetToken() {
    const rawToken = crypto.randomBytes(20).toString('hex');
    const hashedToken = crypto.createHash('sha256').update(rawToken).digest('hex');
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 mins expiry
    return { rawToken, hashedToken, expiresAt };
  }

  /**
   * Hashes a token to compare with stored hash.
   */
  hashToken(token) {
    return crypto.createHash('sha256').update(token).digest('hex');
  }
}

module.exports = new PasswordService();
