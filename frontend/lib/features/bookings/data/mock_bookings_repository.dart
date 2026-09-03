import '../../../shared/models/booking_model.dart';
import '../../../shared/models/ride_model.dart';

abstract class BookingsRepository {
  Future<BookingModel> createBooking({
    required RideModel ride,
    required String passengerId,
    required String passengerName,
    required List<String> selectedSeats,
  });

  Future<List<BookingModel>> getMyBookings();
}

class MockBookingsRepository implements BookingsRepository {
  static final List<BookingModel> _mockBookings = [];

  @override
  Future<BookingModel> createBooking({
    required RideModel ride,
    required String passengerId,
    required String passengerName,
    required List<String> selectedSeats,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final contributionAmount = ride.contributionPerSeat * selectedSeats.length;
    final platformFee = 25.0;
    final totalAmount = contributionAmount + platformFee;

    final booking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      rideId: ride.id,
      passengerId: passengerId,
      passengerName: passengerName,
      seatCount: selectedSeats.length,
      selectedSeats: selectedSeats,
      pickupLocation: ride.origin,
      dropLocation: ride.destination,
      contributionAmount: contributionAmount,
      platformFee: platformFee,
      totalAmount: totalAmount,
      bookingStatus: BookingStatus.pending,
      paymentStatus: PaymentStatus.paid,
      requestedAt: DateTime.now(),
      rideDetails: ride,
    );

    _mockBookings.insert(0, booking);
    return booking;
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_mockBookings);
  }
}
