import 'package:sahyan/features/vehicles/domain/vehicle_model.dart';
import 'package:sahyan/shared/models/location_model.dart';
import 'package:sahyan/shared/models/ride_model.dart';

abstract class RidesRepository {
  Future<List<RideModel>> searchRides({
    required String origin,
    required String destination,
    required DateTime date,
    required int seats,
  });

  Future<RideModel?> getRideById(String id);
}

class MockRidesRepository implements RidesRepository {
  static final List<RideModel> _mockRides = [
    RideModel(
      id: 'ride_101',
      driverId: 'driver_rohit',
      driverName: 'Rohit Patel',
      driverRating: 4.9,
      isDriverVerified: true,
      vehicle: const VehicleModel(
        id: 'veh_01',
        ownerId: 'driver_rohit',
        make: 'Honda',
        model: 'City',
        year: 2022,
        color: 'White',
        registrationNumber: 'GJ-01-AB-1234',
        seatCapacity: 4,
        vehicleType: 'Sedan',
        status: 'active',
      ),
      origin: const LocationModel(
        address: 'ISCON Cross Road, SG Highway',
        city: 'Ahmedabad',
        latitude: 23.0225,
        longitude: 72.5714,
      ),
      destination: const LocationModel(
        address: 'Trikon Baug, Yagnik Road',
        city: 'Rajkot',
        latitude: 22.3039,
        longitude: 70.8022,
      ),
      dateTime: DateTime.now().add(const Duration(hours: 4)),
      departureTime: '08:30 AM',
      estimatedArrival: '12:15 PM',
      availableSeats: 3,
      totalSeats: 4,
      contributionPerSeat: 350.0,
      matchPercentage: 98,
      routeDistanceKm: 215.0,
      durationMins: 225,
      status: RideStatus.scheduled,
      amenities: const ['AC', 'Music', 'No Smoking', 'Luggage Space'],
    ),
    RideModel(
      id: 'ride_102',
      driverId: 'driver_neha',
      driverName: 'Neha Sharma',
      driverRating: 4.8,
      isDriverVerified: true,
      vehicle: const VehicleModel(
        id: 'veh_02',
        ownerId: 'driver_neha',
        make: 'Maruti',
        model: 'Swift Dzire',
        year: 2021,
        color: 'Silver',
        registrationNumber: 'GJ-03-CD-5678',
        seatCapacity: 4,
        vehicleType: 'Sedan',
        status: 'active',
      ),
      origin: const LocationModel(
        address: 'Prahlad Nagar',
        city: 'Ahmedabad',
        latitude: 23.0120,
        longitude: 72.5100,
      ),
      destination: const LocationModel(
        address: 'KKV Hall Circle',
        city: 'Rajkot',
        latitude: 22.2900,
        longitude: 70.7900,
      ),
      dateTime: DateTime.now().add(const Duration(hours: 6)),
      departureTime: '10:00 AM',
      estimatedArrival: '01:45 PM',
      availableSeats: 2,
      totalSeats: 4,
      contributionPerSeat: 320.0,
      matchPercentage: 92,
      routeDistanceKm: 218.0,
      durationMins: 225,
      status: RideStatus.scheduled,
      amenities: const ['AC', 'Women Passengers Preferred', 'Quiet Ride'],
    ),
    RideModel(
      id: 'ride_103',
      driverId: 'driver_amit',
      driverName: 'Amit Shah',
      driverRating: 4.6,
      isDriverVerified: false,
      vehicle: const VehicleModel(
        id: 'veh_03',
        ownerId: 'driver_amit',
        make: 'Hyundai',
        model: 'Creta',
        year: 2023,
        color: 'Black',
        registrationNumber: 'GJ-05-EF-9012',
        seatCapacity: 4,
        vehicleType: 'SUV',
        status: 'active',
      ),
      origin: const LocationModel(
        address: 'Buldana Expressway Interchange',
        city: 'Ahmedabad',
        latitude: 23.0400,
        longitude: 72.5500,
      ),
      destination: const LocationModel(
        address: 'Kalawad Road',
        city: 'Rajkot',
        latitude: 22.2800,
        longitude: 70.7700,
      ),
      dateTime: DateTime.now().add(const Duration(hours: 8)),
      departureTime: '02:00 PM',
      estimatedArrival: '05:30 PM',
      availableSeats: 4,
      totalSeats: 4,
      contributionPerSeat: 380.0,
      matchPercentage: 88,
      routeDistanceKm: 210.0,
      durationMins: 210,
      status: RideStatus.scheduled,
      amenities: const ['AC', 'Music', 'Spacious SUV'],
    ),
  ];

  @override
  Future<List<RideModel>> searchRides({
    required String origin,
    required String destination,
    required DateTime date,
    required int seats,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // Simulate network latency
    return _mockRides;
  }

  @override
  Future<RideModel?> getRideById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockRides.firstWhere((r) => r.id == id);
    } catch (_) {
      return _mockRides.first;
    }
  }
}
