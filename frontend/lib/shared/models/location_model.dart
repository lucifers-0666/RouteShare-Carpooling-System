import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String? placeId;

  const LocationModel({
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.placeId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      placeId: json['placeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }

  @override
  List<Object?> get props => [address, city, latitude, longitude, placeId];
}
