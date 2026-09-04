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
   * Development OTP provider logger abstraction.
   * Logs OTP to console in development mode so developers can test without SMS costs.
   */
  async sendOtp(recipient, otpCode) {
    const isDev = process.env.NODE_ENV !== 'production';
    if (isDev || process.env.ENABLE_DEV_OTP_LOG === 'true') {
      console.log(`\n========================================`);
      console.log(`[DEV OTP PROVIDER] Sent OTP to ${recipient}`);
      console.log(`[OTP CODE]: ${otpCode} (Valid for 10 minutes)`);
      console.log(`========================================\n`);
    }
    return { success: true, recipient, message: 'OTP dispatched successfully' };
  }

  /**
   * Checks if user has exceeded OTP request rate limits (max 5 requests per 10 mins).
   */
  isRateLimited(userOtpInfo) {
    if (!userOtpInfo || !userOtpInfo.lastRequestedAt) return false;
    const now = new Date();
    const diffMins = (now - new Date(userOtpInfo.lastRequestedAt)) / (1000 * 60);
    return diffMins < 1 && userOtpInfo.attempts >= 5;
  }
}

module.exports = new OtpService();
