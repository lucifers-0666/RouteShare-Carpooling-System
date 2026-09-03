const test = require('node:test');
const assert = require('node:assert');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const app = require('../src/app');
const User = require('../src/models/User');
const jwt = require('jsonwebtoken');
const { getJwtSecret } = require('../src/config/jwt');

let mongoServer;
let server;
let baseUrl;

test.before(async () => {
  try {
    mongoServer = await MongoMemoryServer.create();
    const mongoUri = mongoServer.getUri();
    await mongoose.connect(mongoUri);
  } catch (err) {
    console.log('MongoMemoryServer fallback connecting to local MongoDB...');
    const mongoUri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/sahyan_test';
    await mongoose.connect(mongoUri);
  }

  await User.deleteMany({}); // Clean test db

  server = app.listen(0);
  baseUrl = `http://localhost:${server.address().port}/api/v1`;
});

test.after(async () => {
  await User.deleteMany({});
  await mongoose.connection.close();
  if (mongoServer) {
    await mongoServer.stop();
  }
  server.close();
});

test('REGISTRATION: Should register a valid user successfully', async () => {
  const payload = {
    name: 'Test Arjun',
    email: 'arjun.test@example.com',
    phone: '9876543210',
    password: 'StrongPassword123',
  };

  const res = await fetch(`${baseUrl}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 201);
  assert.strictEqual(data.success, true);
  assert.ok(data.accessToken);
  assert.strictEqual(data.user.email, 'arjun.test@example.com');
  assert.strictEqual(data.user.phone, '+919876543210');
  assert.ok(data.devOtp); // Dev OTP returned for testing
});

test('REGISTRATION: Should reject duplicate email', async () => {
  const payload = {
    name: 'Duplicate User',
    email: 'arjun.test@example.com',
    phone: '9123456789',
    password: 'StrongPassword123',
  };

  const res = await fetch(`${baseUrl}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 400);
  assert.strictEqual(data.success, false);
  assert.match(data.message, /email already exists/i);
});

test('REGISTRATION: Should reject duplicate phone', async () => {
  const payload = {
    name: 'Duplicate Phone User',
    email: 'newemail@example.com',
    phone: '9876543210',
    password: 'StrongPassword123',
  };

  const res = await fetch(`${baseUrl}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 400);
  assert.strictEqual(data.success, false);
  assert.match(data.message, /mobile number already exists/i);
});

test('REGISTRATION: Should reject invalid email format', async () => {
  const payload = {
    name: 'Invalid Email',
    email: 'notanemail',
    phone: '9988776655',
    password: 'StrongPassword123',
  };

  const res = await fetch(`${baseUrl}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 400);
  assert.strictEqual(data.success, false);
});

test('REGISTRATION: Should reject weak password (< 6 chars)', async () => {
  const payload = {
    name: 'Short Pass',
    email: 'shortpass@example.com',
    phone: '9988776655',
    password: '123',
  };

  const res = await fetch(`${baseUrl}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 400);
  assert.strictEqual(data.success, false);
});

test('LOGIN: Should log in successfully with valid credentials', async () => {
  const payload = {
    identifier: 'arjun.test@example.com',
    password: 'StrongPassword123',
  };

  const res = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 200);
  assert.strictEqual(data.success, true);
  assert.ok(data.accessToken);
  assert.strictEqual(data.user.email, 'arjun.test@example.com');
});

test('LOGIN: Should reject invalid password', async () => {
  const payload = {
    identifier: 'arjun.test@example.com',
    password: 'WrongPassword999',
  };

  const res = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 401);
  assert.strictEqual(data.success, false);
});

test('LOGIN: Should reject non-existent user', async () => {
  const payload = {
    identifier: 'nobody@example.com',
    password: 'Password123',
  };

  const res = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  const data = await res.json();
  assert.strictEqual(res.status, 401);
  assert.strictEqual(data.success, false);
});

test('PROFILE & JWT: Should fetch profile with valid JWT bearer token', async () => {
  // Login first to get token
  const loginRes = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      identifier: 'arjun.test@example.com',
      password: 'StrongPassword123',
    }),
  });

  const loginData = await loginRes.json();
  const token = loginData.accessToken;

  // Request Profile
  const profileRes = await fetch(`${baseUrl}/users/profile`, {
    headers: { Authorization: `Bearer ${token}` },
  });

  const profileData = await profileRes.json();
  assert.strictEqual(profileRes.status, 200);
  assert.strictEqual(profileData.success, true);
  assert.strictEqual(profileData.data.email, 'arjun.test@example.com');
});

test('PROFILE & JWT: Should reject unauthenticated request missing token', async () => {
  const profileRes = await fetch(`${baseUrl}/users/profile`);
  const profileData = await profileRes.json();
  assert.strictEqual(profileRes.status, 401);
  assert.strictEqual(profileData.success, false);
});

test('PROFILE & JWT: Should reject invalid JWT token', async () => {
  const profileRes = await fetch(`${baseUrl}/users/profile`, {
    headers: { Authorization: 'Bearer fake_invalid_jwt_token_123' },
  });
  const profileData = await profileRes.json();
  assert.strictEqual(profileRes.status, 401);
  assert.strictEqual(profileData.success, false);
});

test('PROFILE & JWT: Should reject expired JWT token', async () => {
  const expiredToken = jwt.sign({ id: new mongoose.Types.ObjectId() }, getJwtSecret(), {
    expiresIn: '0s',
  });

  const profileRes = await fetch(`${baseUrl}/users/profile`, {
    headers: { Authorization: `Bearer ${expiredToken}` },
  });
  const profileData = await profileRes.json();
  assert.strictEqual(profileRes.status, 401);
  assert.strictEqual(profileData.success, false);
  assert.strictEqual(profileData.message, 'Invalid or expired token.');
});

test('JWT CONFIG: Should throw clear error if JWT_SECRET environment variable is missing', () => {
  const originalSecret = process.env.JWT_SECRET;
  try {
    delete process.env.JWT_SECRET;
    assert.throws(
      () => getJwtSecret(),
      /FATAL CONFIGURATION ERROR: JWT_SECRET environment variable is missing\./
    );
  } finally {
    process.env.JWT_SECRET = originalSecret;
  }
});

test('OTP: Should send and verify OTP successfully', async () => {
  // Request OTP
  const sendRes = await fetch(`${baseUrl}/auth/send-otp`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phone: '9876543210' }),
  });

  const sendData = await sendRes.json();
  assert.strictEqual(sendRes.status, 200);
  assert.ok(sendData.devOtp);

  // Verify OTP
  const verifyRes = await fetch(`${baseUrl}/auth/verify-otp`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phone: '9876543210', otp: sendData.devOtp }),
  });

  const verifyData = await verifyRes.json();
  assert.strictEqual(verifyRes.status, 200);
  assert.strictEqual(verifyData.success, true);
  assert.strictEqual(verifyData.user.isVerified, true);
});

test('OTP: Should reject incorrect OTP code', async () => {
  const verifyRes = await fetch(`${baseUrl}/auth/verify-otp`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phone: '9876543210', otp: '0000' }),
  });

  const verifyData = await verifyRes.json();
  assert.strictEqual(verifyRes.status, 400);
  assert.strictEqual(verifyData.success, false);
});

test('PASSWORD RESET: Should execute forgot password and reset password flow', async () => {
  // Forgot password
  const forgotRes = await fetch(`${baseUrl}/auth/forgot-password`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'arjun.test@example.com' }),
  });

  const forgotData = await forgotRes.json();
  assert.strictEqual(forgotRes.status, 200);
  assert.ok(forgotData.devResetToken);

  // Reset password
  const resetRes = await fetch(`${baseUrl}/auth/reset-password`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      token: forgotData.devResetToken,
      newPassword: 'BrandNewPassword123',
    }),
  });

  const resetData = await resetRes.json();
  assert.strictEqual(resetRes.status, 200);
  assert.strictEqual(resetData.success, true);

  // Login with new password
  const newLoginRes = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      identifier: 'arjun.test@example.com',
      password: 'BrandNewPassword123',
    }),
  });

  const newLoginData = await newLoginRes.json();
  assert.strictEqual(newLoginRes.status, 200);
  assert.strictEqual(newLoginData.success, true);
});
