import 'package:equatable/equatable.dart';
import 'location_model.dart';
import 'ride_model.dart';

enum BookingStatus { pending, confirmed, rejected, cancelled, completed }
enum PaymentStatus { pending, paid, refunded, failed }

class BookingModel extends Equatable {
  final String id;
  final String rideId;
  final String passengerId;
  final String passengerName;
  final int seatCount;
  final List<String> selectedSeats;
  final LocationModel pickupLocation;
  final LocationModel dropLocation;
  final double contributionAmount;
  final double platformFee;
  final double totalAmount;
  final BookingStatus bookingStatus;
  final PaymentStatus paymentStatus;
  final DateTime requestedAt;
  final RideModel? rideDetails;

  const BookingModel({
    required this.id,
    required this.rideId,
    required this.passengerId,
    required this.passengerName,
    required this.seatCount,
    required this.selectedSeats,
    required this.pickupLocation,
    required this.dropLocation,
    required this.contributionAmount,
    required this.platformFee,
    required this.totalAmount,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.requestedAt,
    this.rideDetails,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      rideId: json['rideId'] ?? '',
      passengerId: json['passengerId'] ?? '',
      passengerName: json['passengerName'] ?? '',
      seatCount: json['seatCount'] ?? 1,
      selectedSeats: List<String>.from(json['selectedSeats'] ?? []),
      pickupLocation: LocationModel.fromJson(json['pickupLocation'] ?? {}),
      dropLocation: LocationModel.fromJson(json['dropLocation'] ?? {}),
      contributionAmount: (json['contributionAmount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      bookingStatus: BookingStatus.values.firstWhere(
        (e) => e.name == json['bookingStatus'],
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      requestedAt: DateTime.tryParse(json['requestedAt'] ?? '') ?? DateTime.now(),
      rideDetails: json['rideDetails'] != null ? RideModel.fromJson(json['rideDetails']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rideId': rideId,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'seatCount': seatCount,
      'selectedSeats': selectedSeats,
      'pickupLocation': pickupLocation.toJson(),
      'dropLocation': dropLocation.toJson(),
      'contributionAmount': contributionAmount,
      'platformFee': platformFee,
      'totalAmount': totalAmount,
      'bookingStatus': bookingStatus.name,
      'paymentStatus': paymentStatus.name,
      'requestedAt': requestedAt.toIso8601String(),
      'rideDetails': rideDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        rideId,
        passengerId,
        passengerName,
        seatCount,
        selectedSeats,
        pickupLocation,
        dropLocation,
        contributionAmount,
        platformFee,
        totalAmount,
        bookingStatus,
        paymentStatus,
        requestedAt,
        rideDetails,
      ];
}
