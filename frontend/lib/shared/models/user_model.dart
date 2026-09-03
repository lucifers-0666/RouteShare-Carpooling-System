import 'package:equatable/equatable.dart';

enum UserVerificationStatus { pending, verified, rejected }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profilePhoto;
  final String city;
  final UserVerificationStatus verificationStatus;
  final double rating;
  final int totalRides;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profilePhoto,
    required this.city,
    required this.verificationStatus,
    required this.rating,
    required this.totalRides,
  });

  bool get isVerified => verificationStatus == UserVerificationStatus.verified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profilePhoto'],
      city: json['city'] ?? '',
      verificationStatus: UserVerificationStatus.values.firstWhere(
        (e) => e.name == json['verificationStatus'],
        orElse: () => UserVerificationStatus.pending,
      ),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRides: json['totalRides'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profilePhoto': profilePhoto,
      'city': city,
      'verificationStatus': verificationStatus.name,
      'rating': rating,
      'totalRides': totalRides,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        profilePhoto,
        city,
        verificationStatus,
        rating,
        totalRides,
      ];
}
