import 'package:equatable/equatable.dart';

class VehicleModel extends Equatable {
  final String id;
  final String ownerId;
  final String make;
  final String model;
  final String color;
  final String registrationNumber;
  final int capacity;
  final String vehicleType; // hatchback, sedan, suv
  final bool isVerified;

  const VehicleModel({
    required this.id,
    required this.ownerId,
    required this.make,
    required this.model,
    required this.color,
    required this.registrationNumber,
    required this.capacity,
    required this.vehicleType,
    required this.isVerified,
  });

  String get fullName => '$make $model ($color)';

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      color: json['color'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      capacity: json['capacity'] ?? 4,
      vehicleType: json['vehicleType'] ?? 'sedan',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'make': make,
      'model': model,
      'color': color,
      'registrationNumber': registrationNumber,
      'capacity': capacity,
      'vehicleType': vehicleType,
      'isVerified': isVerified,
    };
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    make,
    model,
    color,
    registrationNumber,
    capacity,
    vehicleType,
    isVerified,
  ];
}
