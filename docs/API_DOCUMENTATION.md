# API Documentation - Sahyān REST API

**Base URL**: `http://localhost:5000/api/v1` (Android Emulator: `http://10.0.2.2:5000/api/v1`)  
**Authentication**: JWT Bearer Token (`Authorization: Bearer <token>`)  
**Content-Type**: `application/json`

---

## Implemented Endpoint Quick Reference (Phase 2 Authentication)

| Method | Endpoint | Description | Auth Required | Status |
|--------|----------|-------------|---------------|--------|
| GET | /health | API Health Check | No | Implemented |
| POST | /v1/auth/register | Register new user & issue OTP | No | Implemented |
| POST | /v1/auth/login | Authenticate via email/phone + password | No | Implemented |
| POST | /v1/auth/send-otp | Request OTP code (Dev logger) | No | Implemented |
| POST | /v1/auth/verify-otp | Verify OTP code & activate user | No | Implemented |
| POST | /v1/auth/forgot-password | Request password reset token | No | Implemented |
| POST | /v1/auth/reset-password | Reset password using token | No | Implemented |
| GET | /v1/users/profile | Get authenticated user profile | Yes | Implemented |
| PATCH | /v1/users/profile | Update user profile details | Yes | Implemented |

---

## Authentication Endpoints Details

### 1. POST /api/v1/auth/register
```json
Request:
{
  "name": "Arjun Patel",
  "email": "arjun.patel@example.com",
  "phone": "9876543210",
  "password": "StrongPassword123"
}

Response (201 Created):
{
  "success": true,
  "message": "Registration successful. OTP sent.",
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "66d691...",
    "name": "Arjun Patel",
    "email": "arjun.patel@example.com",
    "phone": "+919876543210",
    "isVerified": false,
    "role": "user",
    "city": "Ahmedabad",
    "rating": { "average": 4.9, "count": 0 }
  },
  "devOtp": "1234"
}
```

### 2. POST /api/v1/auth/login
```json
Request:
{
  "identifier": "arjun.patel@example.com",
  "password": "StrongPassword123"
}

Response (200 OK):
{
  "success": true,
  "message": "Login successful",
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "66d691...",
    "name": "Arjun Patel",
    "email": "arjun.patel@example.com",
    "phone": "+919876543210",
    "isVerified": true,
    "role": "user"
  }
}
```

### 3. POST /api/v1/auth/send-otp
```json
Request:
{
  "phone": "9876543210"
}

Response (200 OK):
{
  "success": true,
  "message": "OTP sent successfully",
  "devOtp": "1234"
}
```

### 4. POST /api/v1/auth/verify-otp
```json
Request:
{
  "phone": "9876543210",
  "otp": "1234"
}

Response (200 OK):
{
  "success": true,
  "message": "Mobile number verified successfully",
  "accessToken": "eyJhbG...",
  "user": { "id": "...", "isVerified": true }
}
```

### 5. GET /api/v1/users/profile
```http
Headers:
Authorization: Bearer eyJhbG...
```
```json
Response (200 OK):
{
  "success": true,
  "data": {
    "id": "66d691...",
    "name": "Arjun Patel",
    "email": "arjun.patel@example.com",
    "phone": "+919876543210",
    "city": "Ahmedabad",
    "isVerified": true,
    "role": "user",
    "rating": { "average": 4.9, "count": 14 }
  }
}
```

---

**Document Version**: 2.0 (Phase 2 Authentication Complete)
