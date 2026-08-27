# System Architecture

## RouteShare - Smart Route-Based Carpooling System

---

## 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                            │
│  ┌─────────────────────┐         ┌─────────────────────┐       │
│  │   Flutter Mobile    │         │   Admin Dashboard   │       │
│  │   Application       │         │   (Web - React)     │       │
│  │   (Android/iOS)     │         │                     │       │
│  └──────────┬──────────┘         └──────────┬──────────┘       │
└─────────────┼────────────────────────────────┼──────────────────┘
              │                                │
              │ HTTPS/REST API                 │ HTTPS/REST API
              │                                │
┌─────────────┼────────────────────────────────┼──────────────────┐
│             ▼                                ▼                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              APPLICATION LAYER (Backend)                │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │           Node.js + Express.js Server           │   │   │
│  │  │  ┌─────────────┐ ┌─────────────┐ ┌───────────┐ │   │   │
│  │  │  │   Routes    │ │Controllers  │ │Middleware │ │   │   │
│  │  │  │  (endpoints)│ │(business    │ │(auth,     │ │   │   │
│  │  │  │             │ │  logic)     │ │validation)│ │   │   │
│  │  │  └─────────────┘ └─────────────┘ └───────────┘ │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
              │
              │ Mongoose ODM
              │
┌─────────────┼──────────────────────────────────────────────────┐
│             ▼                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    DATA LAYER                           │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │              MongoDB Database                   │   │   │
│  │  │  ┌──────┐ ┌──────┐ ┌────────┐ ┌────────┐       │   │   │
│  │  │  │Users │ │Vehicle│ │Journey │ │Booking │  ...  │   │   │
│  │  │  └──────┘ └──────┘ └────────┘ └────────┘       │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │              MongoDB Atlas (Cloud)                      │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   EXTERNAL SERVICES                             │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐           │
│  │  Google Maps │ │  Firebase    │ │  Payment     │           │
│  │  API         │ │  Cloud       │ │  Gateway     │           │
│  │  (Routes,    │ │  Messaging   │ │  (Razorpay/  │           │
│  │   Geocoding) │ │  (FCM)       │ │   Stripe)    │           │
│  └──────────────┘ └──────────────┘ └──────────────┘           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Architecture Pattern: 3-Tier Architecture

### 2.1 Presentation Tier (Frontend)
- **Technology**: Flutter (Dart)
- **Responsibilities**: UI rendering, state management, API calls, local caching

### 2.2 Application Tier (Backend)
- **Technology**: Node.js + Express.js
- **Responsibilities**: REST API, business logic, auth, validation, route matching

### 2.3 Data Tier (Database)
- **Technology**: MongoDB with Mongoose ODM
- **Responsibilities**: Data persistence, schema validation, geospatial queries

---

## 3. Component Architecture

### 3.1 Frontend Components (Flutter)

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models (User, Vehicle, Journey, Booking, Review)
├── screens/                     # UI screens (auth, home, journey, booking, profile)
├── widgets/                     # Reusable components
├── services/                    # API, auth, location, notifications, payment
├── providers/                   # State management (Provider/Riverpod)
└── utils/                       # Constants, validators, theme, helpers
```

### 3.2 Backend Components (Node.js + Express)

```
backend/
├── config/                      # Database, environment, passport config
├── controllers/                 # Business logic (auth, user, vehicle, journey, booking, review)
├── models/                      # Mongoose schemas (User, Vehicle, Journey, Booking, Review)
├── routes/                      # API routes (/api/auth, /api/users, /api/journeys, etc.)
├── middleware/                  # Auth, validation, error handling, rate limiting
├── utils/                       # Email, SMS, FCM, payment, Google Maps, token services
├── validators/                  # Request validation schemas
├── tests/                       # Unit and integration tests
└── server.js                    # Application entry point
```

---

## 4. Data Flow Architecture

### 4.1 User Registration Flow
```
User → Flutter App → POST /api/auth/register → Backend: Hash Password → Create User → Send OTP
→ MongoDB: Insert User → Return Success → App: Navigate to OTP Screen
```

### 4.2 Journey Creation Flow
```
Driver → App → POST /api/journeys → Backend: Verify Auth → Validate → Google Maps API
→ Get Route → Create Journey → MongoDB: Insert → Return Journey Data
```

### 4.3 Journey Search & Booking Flow
```
Passenger → App → GET /api/journeys/search → Backend: Geospatial Query → Route Matching
→ Return Matching Journeys → App: Display → POST /api/bookings → Driver Accepts
→ Payment → Confirm Booking → Notifications
```

---

## 5. Security Architecture

### 5.1 Authentication Flow
- Client sends login request → Server queries MongoDB → Verifies password → Generates JWT
- Client includes JWT in subsequent requests → Server verifies JWT → Processes request

### 5.2 Security Measures
- **Transport**: HTTPS with TLS 1.3
- **Authentication**: JWT with 7-day expiry + refresh tokens
- **Password**: bcrypt hashing (salt rounds: 10)
- **API**: Rate limiting, input validation, CORS
- **Data**: AES-256 encryption for sensitive data

---

## 6. Deployment Architecture

### 6.1 Production Deployment
```
┌─────────────────┐         ┌─────────────────────┐
│  Backend API    │         │  MongoDB Atlas      │
│  (Render/Railway)│        │  Cluster            │
│  - Auto-scaling │         │  - Primary Node     │
│  - Load Balancer│         │  - Replica Set      │
└─────────────────┘         └─────────────────────┘

┌─────────────────┐         ┌─────────────────────┐
│  CDN (Cloudflare)│        │  External Services  │
│  - Static Assets │        │  - Google Maps API  │
│  - Caching       │        │  - Firebase FCM     │
│  - DDoS Protection│       │  - Payment Gateway  │
└─────────────────┘         └─────────────────────┘

┌─────────────────┐
│  Mobile Apps    │
│  - Google Play  │
│  - Apple App    │
│    Store        │
└─────────────────┘
```

### 6.2 Environment Configuration

**Backend (.env):**
```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://...
JWT_SECRET=your-secret-key
JWT_EXPIRE=7d
GOOGLE_MAPS_API_KEY=...
FIREBASE_CREDENTIALS=...
RAZORPAY_KEY_ID=...
RAZORPAY_KEY_SECRET=...
```

**Frontend (constants.dart):**
```dart
const String API_BASE_URL = 'https://api.routeshare.com';
const String GOOGLE_MAPS_API_KEY = '...';
```

---

## 7. Scalability Considerations

### 7.1 Horizontal Scaling
- Backend: Multiple Node.js instances behind load balancer
- Database: MongoDB sharding for large datasets
- Caching: Redis for session management and frequently accessed data

### 7.2 Performance Optimization
- Database Indexing: Geospatial indexes on location fields
- Query Optimization: Aggregation pipelines for complex queries
- API Caching: Redis caching for journey search results
- CDN: Static assets served via CDN

### 7.3 Monitoring & Logging
- Application Monitoring: PM2, New Relic
- Error Tracking: Sentry
- Logging: Winston + MongoDB logging
- Analytics: Google Analytics, Mixpanel

---

**Document Version**: 1.0  
**Last Updated**: August 2026
