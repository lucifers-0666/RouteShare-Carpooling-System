# API Documentation - RouteShare REST API

**Base URL**: `https://api.routeshare.com/api`  
**Authentication**: JWT Bearer Token  
**Content-Type**: `application/json`

---

## Quick Reference

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | /auth/register | Register new user | No |
| POST | /auth/login | User login | No |
| POST | /auth/verify-otp | Verify OTP | No |
| GET | /users/profile | Get profile | Yes |
| PUT | /users/profile | Update profile | Yes |
| POST | /vehicles | Add vehicle | Yes |
| GET | /vehicles | Get user vehicles | Yes |
| POST | /journeys | Create journey | Yes |
| GET | /journeys/search | Search journeys | Yes |
| GET | /journeys/:id | Get journey details | Yes |
| PUT | /journeys/:id | Update journey | Yes |
| DELETE | /journeys/:id | Cancel journey | Yes |
| POST | /bookings | Request booking | Yes |
| GET | /bookings/my-bookings | Get bookings | Yes |
| PUT | /bookings/:id/status | Update booking status | Yes |
| POST /reviews | Submit review | Yes |
| GET /notifications | Get notifications | Yes |

---

## Authentication Endpoints

### POST /auth/register
```json
Request: { "name": "John", "email": "john@example.com", "phone": "+919876543210", "password": "SecurePass123!" }
Response: { "success": true, "message": "Registration successful. OTP sent.", "data": { "userId": "...", "otpSent": true } }
```

### POST /auth/login
```json
Request: { "email": "john@example.com", "password": "SecurePass123!" }
Response: { "success": true, "data": { "token": "eyJhbG...", "user": { "id": "...", "name": "John", "email": "..." } } }
```

---

## Journey Endpoints

### POST /journeys (Driver)
```json
Request: {
  "vehicleId": "...",
  "origin": { "address": "Bhuj", "coordinates": [69.6667, 23.2500], "placeId": "ChIJ..." },
  "destination": { "address": "Ahmedabad", "coordinates": [72.5714, 23.0225], "placeId": "ChIJ..." },
  "dateTime": "2026-09-01T08:00:00Z",
  "availableSeats": 3,
  "contributionPerSeat": 500
}
Response: { "success": true, "data": { "id": "...", "status": "scheduled", "route": { "distanceKm": 340, "durationMins": 240 } } }
```

### GET /journeys/search (Passenger)
```
GET /journeys/search?origin=69.6667,23.2500&destination=72.5714,23.0225&date=2026-09-01&seats=2
```
```json
Response: {
  "success": true,
  "data": {
    "journeys": [{ "id": "...", "driver": { "name": "John", "rating": 4.5 }, "vehicle": { "make": "Maruti", "model": "Swift" }, "dateTime": "...", "availableSeats": 3, "contributionPerSeat": 500, "matchPercentage": 95 }],
    "pagination": { "currentPage": 1, "totalPages": 3, "totalResults": 25 }
  }
}
```

---

## Booking Endpoints

### POST /bookings (Passenger)
```json
Request: {
  "journeyId": "...",
  "pickupLocation": { "address": "City Center, Bhuj", "coordinates": [69.6700, 23.2550], "placeId": "..." },
  "dropLocation": { "address": "Satellite, Ahmedabad", "coordinates": [72.5800, 23.0300], "placeId": "..." },
  "seatsRequested": 2,
  "specialRequests": "Need luggage space"
}
Response: { "success": true, "message": "Booking request sent", "data": { "bookingId": "...", "status": "pending", "totalAmount": 1000 } }
```

### PUT /bookings/:id/status (Driver)
```json
Request: { "status": "confirmed" }
Response: { "success": true, "message": "Booking confirmed", "data": { "bookingId": "...", "status": "confirmed", "paymentLink": "https://razorpay.com/..." } }
```

---

## Error Responses

### 400 Bad Request
```json
{ "success": false, "message": "Validation error", "errors": [{ "field": "email", "message": "Invalid email format" }] }
```

### 401 Unauthorized
```json
{ "success": false, "message": "Authentication required" }
```

### 404 Not Found
```json
{ "success": false, "message": "Resource not found" }
```

### 500 Internal Server Error
```json
{ "success": false, "message": "Internal server error" }
```

---

## Rate Limiting
- Standard: 100 requests/minute
- Auth: 10 requests/minute
- Search: 30 requests/minute

---

**API Version**: 1.0 | **Last Updated**: August 2026
