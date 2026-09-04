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
  final String role;
  final bool canRide;
  final bool canDrive;
  final String driverOnboardingStatus;

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
    this.role = 'user',
    this.canRide = true,
    this.canDrive = false,
    this.driverOnboardingStatus = 'not_started',
  });

  bool get isVerified => verificationStatus == UserVerificationStatus.verified;
  bool get isDriverEligible => canDrive && driverOnboardingStatus == 'approved';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final capabilities = json['capabilities'] as Map<String, dynamic>?;
    final driverProfile = json['driverProfile'] as Map<String, dynamic>?;

    return UserModel(
      id: json['id'] ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profilePhoto'] ?? json['profileImage'],
      city: json['city'] ?? '',
      verificationStatus: UserVerificationStatus.values.firstWhere(
        (e) => e.name == json['verificationStatus'],
        orElse: () => json['isVerified'] == true
            ? UserVerificationStatus.verified
            : UserVerificationStatus.pending,
      ),
      rating: json['rating'] is Map
          ? ((json['rating']['average'] as num?)?.toDouble() ?? 4.9)
          : ((json['rating'] as num?)?.toDouble() ?? 4.9),
      totalRides: json['rating'] is Map
          ? ((json['rating']['count'] as num?)?.toInt() ?? 0)
          : (json['totalRides'] ?? 0),
      role: json['role'] ?? 'user',
      canRide: capabilities?['canRide'] ?? json['canRide'] ?? true,
      canDrive: capabilities?['canDrive'] ?? json['canDrive'] ?? false,
      driverOnboardingStatus:
          driverProfile?['onboardingStatus'] ??
          json['driverOnboardingStatus'] ??
          'not_started',
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
      'role': role,
      'canRide': canRide,
      'canDrive': canDrive,
      'driverOnboardingStatus': driverOnboardingStatus,
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
    role,
    canRide,
    canDrive,
    driverOnboardingStatus,
  ];
}
