# Database Schema Design — Sahyān

## MongoDB Collections & Schemas (Implemented Status)

---

## 1. Users Collection (Implemented)

```javascript
{
  _id: ObjectId,
  name: String,                   // Required, trimmed
  email: String,                  // Unique, lowercase, indexed
  phone: String,                  // Unique, +91 formatted, indexed
  password: String,               // Hashed with bcryptjs (select: false)
  profileImage: String,
  city: String,                   // Default: 'Ahmedabad'
  isVerified: Boolean,            // Default: false (set to true on OTP verification)
  role: String,                   // 'user' | 'admin' (default: 'user')
  rating: {
    average: Number,              // Default: 4.9
    count: Number                 // Default: 0
  },
  emergencyContacts: [{
    name: String,
    phone: String,
    relationship: String
  }],
  preferences: {
    notifications: Boolean,
    allowSmoking: Boolean,
    allowPets: Boolean
  },
  otpInfo: {
    code: String,                 // 4-digit OTP
    expiresAt: Date,              // 10 minutes expiry
    attempts: Number,
    lastRequestedAt: Date
  },
  resetPasswordInfo: {
    token: String,                // SHA256 hashed reset token
    expiresAt: Date               // 15 minutes expiry
  },
  createdAt: Date,
  updatedAt: Date
}
```

### Indexes:
- `{ email: 1 }` - Unique
- `{ phone: 1 }` - Unique

---

**Document Version**: 2.0 (Phase 2 Auth Implemented)
