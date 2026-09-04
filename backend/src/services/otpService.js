const crypto = require('crypto');

class OtpService {
  /**
   * Generates a 6-digit cryptographically secure numeric OTP code.
   */
  generateOtpCode(length = 6) {
    if (length === 6) {
      return crypto.randomInt(100000, 1000000).toString();
    }
    const min = Math.pow(10, length - 1);
    const max = Math.pow(10, length) - 1;
    return crypto.randomInt(min, max + 1).toString();
  }

  /**
   * Dispatches OTP to recipient without logging sensitive secrets.
   */
  async sendOtp(recipient, otpCode) {
    // In production this connects to SMS gateway (e.g. Twilio / Fast2SMS)
    // Never log raw OTP secrets in application logs
    return { success: true, recipient, message: 'OTP dispatched successfully' };
  }

  /**
   * Checks if user has exceeded OTP request rate limits:
   * - Enforces 60-second cooldown between consecutive requests
   * - Enforces maximum 5 requests within a 10-minute rolling window
   */
  isRateLimited(userOtpInfo) {
    if (!userOtpInfo || !userOtpInfo.lastRequestedAt) return false;
    const now = new Date();
    const diffSeconds = (now - new Date(userOtpInfo.lastRequestedAt)) / 1000;

    // Cooldown: at least 60 seconds between requests
    if (diffSeconds < 60) {
      return true;
    }

    // Max 5 attempts within 10 minutes window
    const diffMins = diffSeconds / 60;
    if (diffMins < 10 && userOtpInfo.attempts >= 5) {
      return true;
    }

    return false;
  }
}

module.exports = new OtpService();
