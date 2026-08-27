# Software Requirements Specification (SRS)

## RouteShare - Smart Route-Based Carpooling System

### MCA Major Project Documentation

---

## 1. Introduction

### 1.1 Purpose
This document outlines the software requirements for RouteShare, a mobile-based carpooling platform that connects drivers and passengers travelling on similar routes to share transportation costs and reduce vehicle usage.

### 1.2 Scope
RouteShare enables vehicle owners to publish their planned journeys and allows passengers to search and book available seats based on route similarity, timing, and location preferences. The system is not a traditional taxi or on-demand cab service but a peer-to-peer ride-sharing platform.

### 1.3 Definitions and Acronyms
- **Driver**: A user who owns a vehicle and publishes journey information
- **Passenger**: A user who searches for and books available seats in journeys
- **Journey**: A planned trip from origin to destination with specific time and route
- **Booking**: A confirmed seat reservation by a passenger in a driver's journey
- **Route Matching**: Algorithm to find optimal journey matches based on pickup/drop locations

---

## 2. Overall Description

### 2.1 Product Perspective
RouteShare is a standalone mobile application with a cloud-based backend API and MongoDB database. The system consists of:
- Flutter mobile application (Android/iOS)
- Node.js + Express.js REST API
- MongoDB database with geospatial indexing
- Google Maps API for location and routing

### 2.2 Product Functions
- User registration and authentication
- Journey creation and management (drivers)
- Journey search and booking (passengers)
- Intelligent route matching algorithm
- Real-time notifications
- Ratings and reviews system
- Emergency contact integration
- Trip history and analytics

### 2.3 User Classes and Characteristics

**Primary Users:**
- **Drivers**: Vehicle owners aged 18+, tech-savvy, regular commuters
- **Passengers**: Individuals seeking cost-effective transportation, students, professionals

**Secondary Users:**
- **Administrators**: System monitoring, user verification, dispute resolution

### 2.4 Operating Environment
- **Mobile**: Android 8.0+ / iOS 12+, Flutter SDK 3.0+
- **Backend**: Node.js 18+, Express.js 4.x
- **Database**: MongoDB 6.0+ (Atlas cloud or local)
- **External Services**: Google Maps API, Firebase Cloud Messaging

### 2.5 Design and Implementation Constraints
- Must support offline mode for basic functionality
- Location services must be enabled for core features
- Real-time notifications require internet connectivity
- Payment integration must comply with PCI-DSS standards

### 2.6 Assumptions and Dependencies
- Users have valid mobile numbers for OTP verification
- Drivers have valid vehicle registration and driving licenses
- Google Maps API key is active and within quota limits
- MongoDB Atlas cluster is properly configured

---

## 3. System Features and Requirements

### 3.1 Functional Requirements

#### 3.1.1 User Authentication Module
- **FR1.1**: Users shall register with mobile number, name, email, and password
- **FR1.2**: System shall send OTP for mobile number verification
- **FR1.3**: Users shall log in with credentials or social authentication (Google)
- **FR1.4**: System shall maintain JWT-based session management
- **FR1.5**: Users shall update profile information and upload verification documents

#### 3.1.2 Vehicle Management Module
- **FR2.1**: Drivers shall add vehicle details (make, model, year, color, license plate)
- **FR2.2**: System shall validate vehicle registration number format
- **FR2.3**: Drivers shall upload vehicle photos and registration documents
- **FR2.4**: System shall verify vehicle documents before allowing journey creation
- **FR2.5**: Drivers shall manage multiple vehicles in their profile

#### 3.1.3 Journey Management Module (Driver)
- **FR3.1**: Drivers shall create journeys with origin, destination, date, time, and available seats
- **FR3.2**: System shall calculate estimated route using Google Maps API
- **FR3.3**: Drivers shall set contribution amount per seat
- **FR3.4**: Drivers shall view all active, upcoming, and past journeys
- **FR3.5**: Drivers shall edit or cancel journeys before start time
- **FR3.6**: System shall notify drivers of new booking requests

#### 3.1.4 Journey Search Module (Passenger)
- **FR4.1**: Passengers shall search journeys by origin, destination, and date
- **FR4.2**: System shall display matching journeys sorted by relevance (route overlap, time, price)
- **FR4.3**: Passengers shall filter results by time range, price, vehicle type, driver rating
- **FR4.4**: System shall show route visualization on map with pickup/drop points
- **FR4.5**: Passengers shall view journey details including driver info, vehicle, ratings, and reviews

#### 3.1.5 Booking Management Module
- **FR5.1**: Passengers shall request booking by selecting pickup and drop locations
- **FR5.2**: System shall calculate exact pickup/drop distance from main route
- **FR5.3**: Passengers shall specify number of seats and add special requests
- **FR5.4**: Drivers shall accept or reject booking requests
- **FR5.5**: System shall notify both parties of booking status changes
- **FR5.6**: Passengers shall cancel bookings before journey start time
- **FR5.7**: System shall update available seats count automatically

#### 3.1.6 Route Matching Algorithm
- **FR6.1**: System shall calculate route similarity using geospatial queries
- **FR6.2**: System shall prioritize journeys with minimal detour distance
- **FR6.3**: System shall consider time window compatibility ( ±30 minutes flexible)
- **FR6.4**: System shall factor in driver rating and vehicle type for ranking
- **FR6.5**: System shall display match percentage for each journey result

#### 3.1.7 Ratings and Reviews Module
- **FR7.1**: After journey completion, both driver and passenger shall rate each other (1-5 stars)
- **FR7.2**: Users shall write text reviews with optional photos
- **FR7.3**: System shall calculate average rating for each user
- **FR7.4**: System shall display recent reviews on user profiles
- **FR7.5**: System shall flag inappropriate reviews for admin moderation

#### 3.1.8 Notifications Module
- **FR8.1**: System shall send push notifications for booking requests, confirmations, cancellations
- **FR8.2**: System shall send reminder notifications 1 hour before journey start
- **FR8.3**: System shall send notifications for new reviews and ratings
- **FR8.4**: Users shall manage notification preferences in settings

#### 3.1.9 Safety Features Module
- **FR9.1**: Users shall add emergency contacts (name, mobile, relationship)
- **FR9.2**: Users shall share live trip details with emergency contacts via SMS/link
- **FR9.3**: System shall display verified badge for users with completed document verification
- **FR9.4**: System shall provide in-app emergency button to contact authorities
- **FR9.5**: System shall record journey GPS轨迹 for safety and dispute resolution

#### 3.1.10 Payment Module
- **FR10.1**: System shall integrate payment gateway (Razorpay/Stripe/Paytm)
- **FR10.2**: Passengers shall pay contribution amount at time of booking confirmation
- **FR10.3**: System shall hold payment in escrow until journey completion
- **FR10.4**: System shall transfer payment to driver after journey completion (minus platform fee)
- **FR10.5**: System shall generate payment receipts and transaction history

#### 3.1.11 Admin Dashboard
- **FR11.1**: Admins shall view system analytics (users, journeys, bookings, revenue)
- **FR11.2**: Admins shall verify user documents and approve/reject verification requests
- **FR11.3**: Admins shall manage reported users and reviews
- **FR11.4**: Admins shall resolve disputes between drivers and passengers
- **FR11.5**: Admins shall send system-wide announcements and notifications

### 3.2 Non-Functional Requirements

#### 3.2.1 Performance Requirements
- **NFR1**: Journey search results shall load within 2 seconds
- **NFR2**: Route matching algorithm shall process searches within 500ms
- **NFR3**: System shall support 1000+ concurrent users
- **NFR4**: Push notifications shall be delivered within 5 seconds

#### 3.2.2 Security Requirements
- **NFR5**: All API communications shall use HTTPS with TLS 1.3
- **NFR6**: Passwords shall be hashed using bcrypt with salt rounds ≥10
- **NFR7**: JWT tokens shall expire after 7 days with refresh token mechanism
- **NFR8**: Sensitive data (payment info, personal details) shall be encrypted at rest
- **NFR9**: API endpoints shall implement rate limiting to prevent abuse

#### 3.2.3 Reliability Requirements
- **NFR10**: System shall maintain 99.5% uptime
- **NFR11**: Database shall perform automated backups every 24 hours
- **NFR12**: System shall handle network failures gracefully with retry mechanisms

#### 3.2.4 Usability Requirements
- **NFR13**: App shall achieve 4.0+ rating on app stores
- **NFR14**: New users shall complete onboarding within 3 minutes
- **NFR15**: Core booking flow shall require maximum 5 taps

#### 3.2.5 Scalability Requirements
- **NFR16**: System shall scale horizontally to handle 10x traffic during peak hours
- **NFR17**: Database shall support sharding for geographical distribution

---

## 4. Use Case Diagrams

### 4.1 Driver Use Cases
- Register/Login
- Create/Update Profile
- Add/Manage Vehicles
- Create Journey
- View Booking Requests
- Accept/Reject Bookings
- Start/Complete Journey
- Rate Passenger
- View Earnings

### 4.2 Passenger Use Cases
- Register/Login
- Create/Update Profile
- Search Journeys
- View Journey Details
- Request Booking
- Cancel Booking
- Complete Journey
- Rate Driver
- Share Trip with Emergency Contact

---

## 5. Data Flow Diagrams

### 5.1 Level 0 DFD
User → Mobile App → API Server → MongoDB
External Services: Google Maps API, Payment Gateway, SMS Gateway, FCM

### 5.2 Level 1 DFD (Journey Creation)
Driver → App → Validate Input → Calculate Route (Google Maps) → Store Journey (MongoDB) → Notify Potential Passengers

---

## 6. Entity Relationship Diagram

### Entities:
- User (1) ←→ (M) Vehicle
- User (1) ←→ (M) Journey
- User (1) ←→ (M) Booking
- User (1) ←→ (M) Review
- Journey (1) ←→ (M) Booking
- Vehicle (1) ←→ (M) Journey

---

## 7. Interface Requirements

### 7.1 User Interfaces
- **Mobile App**: Flutter-based UI with Material Design 3
- **Admin Dashboard**: Web-based React/Vue.js dashboard

### 7.2 Hardware Interfaces
- GPS receiver for location tracking
- Camera for document and profile photo uploads
- Internet connectivity (WiFi/4G/5G)

### 7.3 Software Interfaces
- **Google Maps API**: Route calculation, geocoding, distance matrix
- **Firebase Cloud Messaging**: Push notifications
- **Payment Gateway API**: Razorpay/Stripe integration
- **SMS Gateway**: OTP and transactional SMS

### 7.4 Communication Interfaces
- REST API over HTTPS
- WebSocket for real-time updates (optional)
- JSON for data interchange

---

## 8. Appendix

### 8.1 Technology Stack Summary
- Frontend: Flutter 3.x, Dart
- Backend: Node.js 18+, Express.js 4.x
- Database: MongoDB 6.0+, Mongoose 7.x
- Authentication: JWT, bcrypt
- Maps: Google Maps Platform
- Notifications: Firebase Cloud Messaging
- Payments: Razorpay/Stripe
- Hosting: MongoDB Atlas, Render/Railway

### 8.2 Testing Strategy
- Unit Testing: Jest (backend), Flutter Test (frontend)
- Integration Testing: Postman, Supertest
- End-to-End Testing: Flutter Integration Test
- Performance Testing: Apache JMeter

---

**Document Version**: 1.0  
**Last Updated**: August 2026  
**Prepared By**: MCA Project Team
