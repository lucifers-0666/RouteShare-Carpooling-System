# Sahyān — Intelligent Route-Based Carpooling Platform

**Sahyān (सह्यान)** connects drivers travelling on planned routes with passengers travelling along the same or similar routes so available vehicle seats can be shared, reducing travel costs and improving vehicle utilization.

> **Note:** Sahyān is a **peer-to-peer route-based carpooling platform**, not an on-demand taxi or ride-hailing service.

---

## Tech Stack

- **Mobile Application**: Flutter (Dart) — Cross-platform iOS & Android mobile application.
- **Backend REST API**: Node.js + Express.js — Fast, non-blocking asynchronous RESTful server.
- **Database**: MongoDB (NoSQL) — Selected for built-in **GeoJSON 2dsphere geospatial indexing** (`$near`, `$geoWithin`) for efficient route & proximity matching.
- **Authentication**: JWT (JSON Web Tokens) + OTP Verification + bcryptjs password hashing.
- **Maps & Routing**: Google Maps API for geocoding, route calculation, and polyline visualization.

---

## Technical Architecture & Status

- **Frontend / Mobile Client**: Flutter 3 (Dart) application (`frontend/`) using Riverpod state management, GoRouter navigation, `flutter_secure_storage` session persistence, and `http` network client.
- **Backend API Server**: Node.js + Express.js REST API (`backend/`) with JWT Authentication, bcryptjs password hashing, development OTP abstraction, and centralized error handling.
- **Database**: MongoDB with Mongoose ODM (`User` model implemented).

---

## Phase 2 Completed Features (Authentication Vertical Slice)

- 🔐 **User Registration**: `POST /api/v1/auth/register` with input validation, duplicate email/phone checks, and password hashing.
- 🔑 **User Login**: `POST /api/v1/auth/login` credential validation supporting email or phone login + JWT access tokens.
- 📲 **Development OTP Provider**: `POST /api/v1/auth/send-otp` & `POST /api/v1/auth/verify-otp` with rate limiting and OTP expiration.
- 🔄 **Password Reset**: `POST /api/v1/auth/forgot-password` & `POST /api/v1/auth/reset-password` using crypto tokens.
- 👤 **Protected Profile API**: `GET /api/v1/users/profile` protected by `authenticate` JWT middleware.
- 💾 **Persistent Flutter Session**: Secure JWT storage using `flutter_secure_storage` and automatic session restoration on app launch.

---

## Local Development Instructions

### Backend Setup

```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

Run Backend Tests:
```bash
cd backend
npm test
```

### Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

Run Frontend Tests:
```bash
cd frontend
flutter test
```

---

**License**: MIT License - see [LICENSE](LICENSE) for details.
