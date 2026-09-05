import 'package:equatable/equatable.dart';
import 'package:sahyan/features/vehicles/domain/vehicle_model.dart';
import 'package:sahyan/shared/models/location_model.dart';

enum RideStatus { scheduled, inProgress, completed, cancelled }

class RideModel extends Equatable {
  final String id;
  final String driverId;
  final String driverName;
  final double driverRating;
  final String? driverPhoto;
  final bool isDriverVerified;
  final VehicleModel vehicle;
  final LocationModel origin;
  final LocationModel destination;
  final DateTime dateTime;
  final String departureTime;
  final String estimatedArrival;
  final int availableSeats;
  final int totalSeats;
  final double contributionPerSeat;
  final int matchPercentage;
  final double routeDistanceKm;
  final int durationMins;
  final RideStatus status;
  final List<String> amenities;

  const RideModel({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverRating,
    this.driverPhoto,
    required this.isDriverVerified,
    required this.vehicle,
    required this.origin,
    required this.destination,
    required this.dateTime,
    required this.departureTime,
    required this.estimatedArrival,
    required this.availableSeats,
    required this.totalSeats,
    required this.contributionPerSeat,
    required this.matchPercentage,
    required this.routeDistanceKm,
    required this.durationMins,
    required this.status,
    required this.amenities,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      driverRating: (json['driverRating'] as num?)?.toDouble() ?? 0.0,
      driverPhoto: json['driverPhoto'],
      isDriverVerified: json['isDriverVerified'] ?? false,
      vehicle: VehicleModel.fromJson(json['vehicle'] ?? {}),
      origin: LocationModel.fromJson(json['origin'] ?? {}),
      destination: LocationModel.fromJson(json['destination'] ?? {}),
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
      departureTime: json['departureTime'] ?? '',
      estimatedArrival: json['estimatedArrival'] ?? '',
      availableSeats: json['availableSeats'] ?? 0,
      totalSeats: json['totalSeats'] ?? 4,
      contributionPerSeat:
          (json['contributionPerSeat'] as num?)?.toDouble() ?? 0.0,
      matchPercentage: json['matchPercentage'] ?? 100,
      routeDistanceKm: (json['routeDistanceKm'] as num?)?.toDouble() ?? 0.0,
      durationMins: json['durationMins'] ?? 0,
      status: RideStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RideStatus.scheduled,
      ),
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'driverName': driverName,
      'driverRating': driverRating,
      'driverPhoto': driverPhoto,
      'isDriverVerified': isDriverVerified,
      'vehicle': vehicle.toJson(),
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'dateTime': dateTime.toIso8601String(),
      'departureTime': departureTime,
      'estimatedArrival': estimatedArrival,
      'availableSeats': availableSeats,
      'totalSeats': totalSeats,
      'contributionPerSeat': contributionPerSeat,
      'matchPercentage': matchPercentage,
      'routeDistanceKm': routeDistanceKm,
      'durationMins': durationMins,
      'status': status.name,
      'amenities': amenities,
    };
  }

  @override
  List<Object?> get props => [
    id,
    driverId,
    driverName,
    driverRating,
    driverPhoto,
    isDriverVerified,
    vehicle,
    origin,
    destination,
    dateTime,
    departureTime,
    estimatedArrival,
    availableSeats,
    totalSeats,
    contributionPerSeat,
    matchPercentage,
    routeDistanceKm,
    durationMins,
    status,
    amenities,
  ];
}
