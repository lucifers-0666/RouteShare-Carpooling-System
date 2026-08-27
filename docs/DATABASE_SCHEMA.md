# Database Schema Design

## RouteShare - MongoDB Collections

---

## 1. Users Collection

```javascript
{
  _id: ObjectId,
  name: String,
  email: String,                   // Unique, indexed
  phone: String,                   // Unique, indexed
  password: String,                // Hashed with bcrypt
  profileImage: String,
  isVerified: Boolean,
  verificationDocuments: {
    aadharCard: String,
    drivingLicense: String,
    status: String                 // 'pending' | 'approved' | 'rejected'
  },
  rating: {
    average: Number,               // 0-5
    count: Number
  },
  emergencyContacts: [{
    name: String,
    phone: String,
    relationship: String,
    isPrimary: Boolean
  }],
  preferences: {
    notifications: Boolean,
    language: String,
    currency: String
  },
  createdAt: Date,
  updatedAt: Date,
  lastLogin: Date
}
```

### Indexes:
- `{ email: 1 }` - Unique
- `{ phone: 1 }` - Unique
- `{ name: 'text' }` - Text search

---

## 2. Vehicles Collection

```javascript
{
  _id: ObjectId,
  userId: ObjectId,                // Reference to Users
  make: String,
  model: String,
  year: Number,
  color: String,
  licensePlate: String,            // Unique
  capacity: Number,
  vehicleType: String,             // 'hatchback', 'sedan', 'suv'
  photos: [String],
  registrationDocument: String,
  insuranceDocument: String,
  isVerified: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### Indexes:
- `{ userId: 1 }`
- `{ licensePlate: 1 }` - Unique

---

## 3. Journeys Collection

```javascript
{
  _id: ObjectId,
  driverId: ObjectId,
  vehicleId: ObjectId,
  origin: {
    address: String,
    coordinates: [Number],         // [longitude, latitude]
    placeId: String
  },
  destination: {
    address: String,
    coordinates: [Number],
    placeId: String
  },
  route: {
    polyline: String,
    distanceKm: Number,
    durationMins: Number
  },
  dateTime: Date,
  availableSeats: Number,
  totalSeats: Number,
  contributionPerSeat: Number,
  status: String,                  // 'scheduled', 'in_progress', 'completed', 'cancelled'
  amenities: [String],
  preferences: {
    allowPets: Boolean,
    allowLuggage: Boolean,
    smokingAllowed: Boolean
  },
  bookings: [ObjectId],
  createdAt: Date,
  updatedAt: Date
}
```

### Indexes:
- `{ driverId: 1 }`
- `{ 'origin.coordinates': '2dsphere' }` - Geospatial
- `{ 'destination.coordinates': '2dsphere' }` - Geospatial
- `{ dateTime: 1 }`
- `{ status: 1 }`

---

## 4. Bookings Collection

```javascript
{
  _id: ObjectId,
  journeyId: ObjectId,
  passengerId: ObjectId,
  driverId: ObjectId,
  pickupLocation: {
    address: String,
    coordinates: [Number],
    placeId: String
  },
  dropLocation: {
    address: String,
    coordinates: [Number],
    placeId: String
  },
  seatsRequested: Number,
  totalAmount: Number,
  status: String,                  // 'pending', 'confirmed', 'rejected', 'cancelled', 'completed'
  paymentStatus: String,           // 'pending', 'paid', 'refunded', 'failed'
  paymentId: String,
  specialRequests: String,
  pickupDistanceFromRoute: Number,
  dropDistanceFromRoute: Number,
  rating: {
    passengerRating: Number,
    driverRating: Number,
    passengerReview: String,
    driverReview: String
  },
  createdAt: Date,
  updatedAt: Date
}
```

### Indexes:
- `{ journeyId: 1 }`
- `{ passengerId: 1 }`
- `{ driverId: 1 }`
- `{ status: 1 }`
- `{ createdAt: -1 }`

---

## 5. Reviews Collection

```javascript
{
  _id: ObjectId,
  bookingId: ObjectId,
  reviewerId: ObjectId,
  revieweeId: ObjectId,
  journeyId: ObjectId,
  rating: Number,                  // 1-5
  reviewText: String,
  reviewType: String,              // 'passenger_to_driver', 'driver_to_passenger'
  photos: [String],
  isReported: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### Indexes:
- `{ revieweeId: 1 }`
- `{ reviewerId: 1 }`
- `{ bookingId: 1 }` - Unique
- `{ journeyId: 1 }`

---

## 6. Notifications Collection

```javascript
{
  _id: ObjectId,
  userId: ObjectId,
  title: String,
  message: String,
  type: String,                    // 'booking', 'journey', 'payment', 'system'
  data: Object,
  isRead: Boolean,
  sentAt: Date,
  readAt: Date,
  createdAt: Date
}
```

### Indexes:
- `{ userId: 1 }`
- `{ isRead: 1 }`
- `{ createdAt: -1 }`

---

## 7. PaymentTransactions Collection

```javascript
{
  _id: ObjectId,
  bookingId: ObjectId,
  userId: ObjectId,
  amount: Number,
  currency: String,
  paymentMethod: String,
  paymentId: String,
  orderId: String,
  signature: String,
  status: String,                  // 'initiated', 'success', 'failed', 'refunded'
  platformFee: Number,
  driverAmount: Number,
  transactionType: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Indexes:
- `{ bookingId: 1 }`
- `{ userId: 1 }`
- `{ paymentId: 1 }` - Unique
- `{ status: 1 }`

---

## Entity Relationships

```
Users (1) ──────< Vehicles (M)
Users (1) ──────< Journeys (M)
Users (1) ──────< Bookings (M)
Users (1) ──────< Reviews (M)
Users (1) ──────< Notifications (M)

Journeys (1) ──────< Bookings (M)
Bookings (1) ──────< Reviews (M)
Bookings (1) ──────< PaymentTransactions (M)
```

---

## Geospatial Query Example

```javascript
// Find journeys near a location (5km radius)
db.journeys.find({
  'origin.coordinates': {
    $near: {
      $geometry: { type: 'Point', coordinates: [longitude, latitude] },
      $maxDistance: 5000
    }
  }
})
```

---

**Document Version**: 1.0  
**Last Updated**: August 2026
