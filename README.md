# RouteShare - Smart Route-Based Carpooling and Ride Sharing System

## 🎓 MCA Major Project

**RouteShare** is a mobile-based carpooling platform that connects people travelling on the same or similar routes, allowing vehicle owners to share their unused seats with passengers travelling in the same direction.

---

## 📋 Project Overview

RouteShare intelligently matches drivers and passengers based on:
- Route similarity and overlap
- Pickup and drop-off locations
- Travel time preferences
- Available seats
- Contribution amount

**Main Objective**: Utilize empty vehicle seats, reduce individual transportation costs, and make daily travel more efficient and sustainable — without functioning as a traditional taxi or on-demand cab service.

---

## 🚀 Features

### For Drivers
- ✅ Publish planned journeys (start, destination, date, time, available seats)
- ✅ Manage vehicle information
- ✅ Accept/reject passenger requests
- ✅ View booking history and earnings
- ✅ Rate and review passengers
- ✅ Real-time trip tracking

### For Passengers
- ✅ Search journeys by pickup, destination, and preferred time
- ✅ Intelligent route matching
- ✅ Request bookings with drivers
- ✅ View booking history
- ✅ Rate and review drivers
- ✅ Share trip details with emergency contacts

### Safety Features
- 🔒 User verification and authentication
- 🆘 Emergency contact integration
- 📍 Trip sharing with trusted contacts
- ⭐ Ratings and reviews system
- 🛡️ Secure payment integration

### Additional Features
- 📱 User profiles with verification badges
- 🔔 Push notifications for bookings and updates
- 🗺️ Map-based route visualization (Google Maps API)
- 📊 Dashboard with travel statistics
- 💬 In-app messaging between driver and passenger

---

## 🛠️ Technology Stack

### Frontend (Mobile Application)
- **Framework**: Flutter (Dart)
- **State Management**: Provider / Riverpod
- **Maps Integration**: Google Maps API
- **Authentication**: JWT tokens

### Backend (REST API)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Authentication**: JWT, bcrypt
- **Validation**: Joi / express-validator

### Database
- **Primary Database**: MongoDB (with Mongoose ODM)
- **Geospatial Indexing**: For route and location queries
- **Cloud Hosting**: MongoDB Atlas

### DevOps & Deployment
- **Backend Hosting**: Render / Railway / AWS EC2
- **Mobile Distribution**: Google Play Store / APK
- **Version Control**: Git & GitHub
- **API Documentation**: Swagger / Postman

---

## 📁 Project Structure

```
RouteShare-Carpooling-System/
│
├── backend/                    # Node.js + Express.js API
│   ├── config/                 # Database and app configuration
│   ├── controllers/            # Route handlers and business logic
│   ├── models/                 # MongoDB schemas (Mongoose)
│   ├── routes/                 # API route definitions
│   ├── middleware/             # Auth, validation, error handling
│   ├── utils/                  # Helper functions, email, SMS
│   ├── .env.example            # Environment variables template
│   └── server.js               # Application entry point
│
├── frontend/                   # Flutter Mobile Application
│   ├── lib/
│   │   ├── models/             # Data models
│   │   ├── screens/            # UI screens
│   │   ├── widgets/            # Reusable components
│   │   ├── services/           # API calls, location, notifications
│   │   ├── providers/          # State management
│   │   ├── utils/              # Constants, validators, helpers
│   │   └── main.dart           # App entry point
│   ├── assets/                 # Images, fonts, icons
│   └── pubspec.yaml            # Flutter dependencies
│
├── docs/                       # Documentation
│   ├── SRS.md                  # Software Requirements Specification
│   ├── SYSTEM_ARCHITECTURE.md  # System design diagrams
│   ├── DATABASE_SCHEMA.md      # MongoDB collections and schema
│   ├── API_DOCUMENTATION.md    # REST API endpoints
│   └── PROJECT_REPORT.md       # MCA project report structure
│
├── .github/                    # GitHub templates
│   └── ISSUE_TEMPLATE.md
│
├── .gitignore
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## 🗄️ Database Schema (MongoDB)

### Collections

1. **Users** - User profiles, authentication, verification
2. **Vehicles** - Vehicle details, capacity, type
3. **Journeys** - Driver-published trips with routes
4. **Bookings** - Passenger requests and confirmations
5. **Reviews** - Ratings and feedback
6. **Notifications** - Push notification history
7. **EmergencyContacts** - User emergency contact information

*See `docs/DATABASE_SCHEMA.md` for detailed schema design*

---

## 🔌 API Endpoints (Key Routes)

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/verify-otp` - OTP verification

### Journeys
- `POST /api/journeys` - Create journey (Driver)
- `GET /api/journeys/search` - Search journeys (Passenger)
- `GET /api/journeys/:id` - Get journey details
- `PUT /api/journeys/:id` - Update journey
- `DELETE /api/journeys/:id` - Cancel journey

### Bookings
- `POST /api/bookings` - Request booking (Passenger)
- `PUT /api/bookings/:id/status` - Accept/reject booking (Driver)
- `GET /api/bookings/my-bookings` - Get user's bookings

### Reviews
- `POST /api/reviews` - Submit review
- `GET /api/reviews/user/:userId` - Get user's reviews

*See `docs/API_DOCUMENTATION.md` for complete API reference*

---

## 🚀 Getting Started

### Prerequisites
- Node.js (v18 or higher)
- MongoDB Atlas account or local MongoDB
- Flutter SDK (v3.0 or higher)
- Google Maps API key
- Git

### Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your MongoDB URI and JWT secret
npm run dev
```

### Frontend Setup

```bash
cd frontend
flutter pub get
# Update Google Maps API key in AndroidManifest.xml and Info.plist
flutter run
```

---

## 📚 Documentation

- [Software Requirements Specification (SRS)](docs/SRS.md)
- [System Architecture](docs/SYSTEM_ARCHITECTURE.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)
- [API Documentation](docs/API_DOCUMENTATION.md)
- [Project Report Structure](docs/PROJECT_REPORT.md)

---

## 👨‍💻 Development

### Backend Development
```bash
cd backend
npm run dev        # Development mode with hot reload
npm test           # Run tests
npm run lint       # Code linting
```

### Frontend Development
```bash
cd frontend
flutter run        # Run on connected device/emulator
flutter build apk  # Build release APK
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**MCA Major Project**  
Developed as part of Master of Computer Applications curriculum

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

---

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Email: [your-email@example.com]

---

**Made with ❤️ for sustainable transportation**
