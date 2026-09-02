# Sahyān — Intelligent Route-Based Carpooling Platform

**Sahyān** connects drivers travelling on planned routes with passengers travelling along the same or similar routes so available vehicle seats can be shared, reducing travel costs and improving vehicle utilization.

> **Note:** Sahyān is a **peer-to-peer carpooling platform**, not an on-demand taxi or ride-hailing service.

## Overview

Sahyān (सह्यान) means "shared journey". The platform enables cost-effective, eco-friendly commuting by matching drivers and passengers with overlapping routes.

### Key Features

- **Ride Creation:** Drivers post origin, destination, time, available seats, and optional price.
- **Smart Matching:** Passengers find rides by route, time, price, seats, and driver rating.
- **Booking Flow:** Request seats, driver approve/reject, real-time booking status.
- **In-App Chat:** Secure driver ↔ rider coordination before the ride.
- **Ratings & Reviews:** Post-ride feedback for both drivers and passengers.
- **Notifications:** Push/email alerts for requests, approvals, reminders.
- **Admin Dashboard:** User/ride moderation, reporting, and analytics.

## Tech Stack

- **Frontend:** React/Next.js (or Flutter mobile app)
- **Backend:** Node.js + Express
- **Database:** PostgreSQL
- **Authentication:** JWT + OTP verification
- **Maps & Routing:** Google Maps API / Mapbox

## Project Structure

```
RouteShare-Carpooling-System/
├── backend/          # API server, auth, ride/booking logic
├── frontend/         # Web/mobile UI
├── docs/             # SRS, architecture, DB schema, API docs
├── .github/          # CI/CD workflows
├── README.md
├── LICENSE
└── CONTRIBUTING.md
```

## Documentation

- [Software Requirements Specification (SRS)](docs/SRS.md)
- [System Architecture](docs/SYSTEM_ARCHITECTURE.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)
- [API Documentation](docs/API_DOCUMENTATION.md)
- [Project Report](docs/PROJECT_REPORT.md)

## Getting Started

### Prerequisites

- Node.js (v18+)
- PostgreSQL (v14+)
- npm or yarn
- (Optional) Flutter SDK for mobile app

### Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Configure DATABASE_URL, JWT_SECRET, MAPS_API_KEY
npm run dev
```

### Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting PRs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Sahyān** — Saath chalo, safar baanto. 🚗
