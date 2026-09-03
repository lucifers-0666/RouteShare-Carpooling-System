const jwt = require('jsonwebtoken');
const User = require('../models/User');
const otpService = require('../services/otpService');
const passwordService = require('../services/passwordService');

const { getJwtSecret, getJwtExpiresIn } = require('../config/jwt');

const generateAccessToken = (userId) => {
  const secret = getJwtSecret();
  return jwt.sign({ id: userId }, secret, {
    expiresIn: getJwtExpiresIn(),
  });
};

/**
 * POST /api/v1/auth/register
 */
const register = async (req, res, next) => {
  try {
    const { name, email, phone, password } = req.body;

    // Form Validations
    if (!name || name.trim().length === 0) {
      return res.status(400).json({ success: false, message: 'Name is required' });
    }
    if (!email || !/\S+@\S+\.\S+/.test(email)) {
      return res.status(400).json({ success: false, message: 'Please provide a valid email address' });
    }
    const cleanPhone = phone ? phone.toString().replace(/\D/g, '') : '';
    if (cleanPhone.length < 10) {
      return res.status(400).json({ success: false, message: 'Please provide a valid 10-digit mobile number' });
    }
    if (!password || password.length < 6) {
      return res.status(400).json({ success: false, message: 'Password must be at least 6 characters' });
    }

    // Check duplicate email
    const existingEmail = await User.findOne({ email: email.toLowerCase() });
    if (existingEmail) {
      return res.status(400).json({ success: false, message: 'An account with this email already exists' });
    }

    // Check duplicate phone
    const formattedPhone = cleanPhone.length === 10 ? `+91${cleanPhone}` : phone;
    const existingPhone = await User.findOne({ phone: formattedPhone });
    if (existingPhone) {
      return res.status(400).json({ success: false, message: 'An account with this mobile number already exists' });
    }

    // Generate initial OTP
    const otpCode = otpService.generateOtpCode(4);
    const otpExpires = new Date(Date.now() + 10 * 60 * 1000);

    const user = await User.create({
      name: name.trim(),
      email: email.toLowerCase().trim(),
      phone: formattedPhone,
      password,
      otpInfo: {
        code: otpCode,
        expiresAt: otpExpires,
        attempts: 0,
        lastRequestedAt: new Date(),
      },
    });

    await otpService.sendOtp(formattedPhone, otpCode);

    const token = generateAccessToken(user._id);

    return res.status(201).json({
      success: true,
      message: 'Registration successful. OTP sent.',
      accessToken: token,
      user: user.toJSON(),
      devOtp: process.env.NODE_ENV !== 'production' ? otpCode : undefined,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/v1/auth/login
 */
const login = async (req, res, next) => {
  try {
    const { emailOrPhone, identifier, password } = req.body;
    const targetIdentifier = identifier || emailOrPhone;

    if (!targetIdentifier || !password) {
      return res.status(400).json({ success: false, message: 'Please provide email/phone and password' });
    }

    const cleanInput = targetIdentifier.trim();
    let query = { email: cleanInput.toLowerCase() };

    if (!cleanInput.includes('@')) {
      const cleanPhone = cleanInput.replace(/\D/g, '');
      const formattedPhone = cleanPhone.length === 10 ? `+91${cleanPhone}` : cleanInput;
      query = { phone: formattedPhone };
    }

    const user = await User.findOne(query).select('+password');
    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const isMatch = await user.matchPassword(password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const token = generateAccessToken(user._id);

    return res.status(200).json({
      success: true,
      message: 'Login successful',
      accessToken: token,
      user: user.toJSON(),
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/v1/auth/send-otp
 */
const sendOtp = async (req, res, next) => {
  try {
    const { phone } = req.body;
    if (!phone) {
      return res.status(400).json({ success: false, message: 'Phone number is required' });
    }

    const cleanPhone = phone.toString().replace(/\D/g, '');
    const formattedPhone = cleanPhone.length === 10 ? `+91${cleanPhone}` : phone;

    const user = await User.findOne({ phone: formattedPhone });
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found with this mobile number' });
    }

    if (otpService.isRateLimited(user.otpInfo)) {
      return res.status(429).json({ success: false, message: 'Too many OTP requests. Please try again in a few minutes.' });
    }

    const otpCode = otpService.generateOtpCode(4);
    user.otpInfo = {
      code: otpCode,
      expiresAt: new Date(Date.now() + 10 * 60 * 1000),
      attempts: (user.otpInfo?.attempts || 0) + 1,
      lastRequestedAt: new Date(),
    };

    await user.save();
    await otpService.sendOtp(formattedPhone, otpCode);

    return res.status(200).json({
      success: true,
      message: 'OTP sent successfully',
      devOtp: process.env.NODE_ENV !== 'production' ? otpCode : undefined,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/v1/auth/verify-otp
 */
const verifyOtp = async (req, res, next) => {
  try {
    const { phone, otp } = req.body;
    if (!otp) {
      return res.status(400).json({ success: false, message: 'OTP is required' });
    }

    let user;
    if (req.user) {
      user = req.user;
    } else if (phone) {
      const cleanPhone = phone.toString().replace(/\D/g, '');
      const formattedPhone = cleanPhone.length === 10 ? `+91${cleanPhone}` : phone;
      user = await User.findOne({ phone: formattedPhone });
    }

    if (!user) {
      return res.status(400).json({ success: false, message: 'User account not found' });
    }

    if (!user.otpInfo || !user.otpInfo.code) {
      return res.status(400).json({ success: false, message: 'No active OTP request found. Please request a new OTP.' });
    }

    if (new Date() > new Date(user.otpInfo.expiresAt)) {
      return res.status(400).json({ success: false, message: 'OTP has expired. Please request a new OTP.' });
    }

    if (user.otpInfo.code !== otp.trim()) {
      return res.status(400).json({ success: false, message: 'Invalid OTP code' });
    }

    // Verify user and clear OTP
    user.isVerified = true;
    user.otpInfo = undefined;
    await user.save();

    const token = generateAccessToken(user._id);

    return res.status(200).json({
      success: true,
      message: 'Mobile number verified successfully',
      accessToken: token,
      user: user.toJSON(),
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/v1/auth/forgot-password
 */
const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ success: false, message: 'Email address is required' });
    }

    const user = await User.findOne({ email: email.toLowerCase().trim() });
    if (!user) {
      // Do not reveal user existence for security
      return res.status(200).json({
        success: true,
        message: 'If an account exists with this email, a reset token has been sent.',
      });
    }

    const { rawToken, hashedToken, expiresAt } = passwordService.generateResetToken();
    user.resetPasswordInfo = { token: hashedToken, expiresAt };
    await user.save();

    passwordService.logResetLink(user.email, rawToken);

    return res.status(200).json({
      success: true,
      message: 'If an account exists with this email, a reset token has been sent.',
      devResetToken: process.env.NODE_ENV !== 'production' ? rawToken : undefined,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/v1/auth/reset-password
 */
const resetPassword = async (req, res, next) => {
  try {
    const { token, newPassword } = req.body;
    if (!token || !newPassword || newPassword.length < 6) {
      return res.status(400).json({ success: false, message: 'Valid token and new password (min 6 chars) are required' });
    }

    const hashedToken = passwordService.hashToken(token);

    const user = await User.findOne({
      'resetPasswordInfo.token': hashedToken,
      'resetPasswordInfo.expiresAt': { $gt: new Date() },
    });

    if (!user) {
      return res.status(400).json({ success: false, message: 'Invalid or expired password reset token' });
    }

    user.password = newPassword;
    user.resetPasswordInfo = undefined;
    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Password reset successful. You can now log in with your new password.',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  sendOtp,
  verifyOtp,
  forgotPassword,
  resetPassword,
};
