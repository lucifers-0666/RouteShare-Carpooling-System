import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/ride_model.dart';
import '../data/mock_bookings_repository.dart';

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return MockBookingsRepository();
});

class BookingsNotifier extends StateNotifier<AsyncValue<List<BookingModel>>> {
  final BookingsRepository repository;

  BookingsNotifier(this.repository) : super(const AsyncValue.data([]));

  Future<void> fetchMyBookings() async {
    state = const AsyncValue.loading();
    try {
      final bookings = await repository.getMyBookings();
      state = AsyncValue.data(bookings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<BookingModel> confirmBooking({
    required RideModel ride,
    required String passengerId,
    required String passengerName,
    required List<String> selectedSeats,
  }) async {
    final booking = await repository.createBooking(
      ride: ride,
      passengerId: passengerId,
      passengerName: passengerName,
      selectedSeats: selectedSeats,
    );
    await fetchMyBookings();
    return booking;
  }
}

final bookingsNotifierProvider =
    StateNotifierProvider<BookingsNotifier, AsyncValue<List<BookingModel>>>((
      ref,
    ) {
      final repo = ref.watch(bookingsRepositoryProvider);
      return BookingsNotifier(repo);
    });

final activeBookingProvider = StateProvider<BookingModel?>((ref) => null);
