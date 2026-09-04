import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/ride_model.dart';
import '../data/mock_rides_repository.dart';

final ridesRepositoryProvider = Provider<RidesRepository>((ref) {
  return MockRidesRepository();
});

class RideSearchQuery {
  final String origin;
  final String destination;
  final DateTime date;
  final int seats;

  RideSearchQuery({
    required this.origin,
    required this.destination,
    required this.date,
    required this.seats,
  });
}

final rideSearchQueryProvider = StateProvider<RideSearchQuery>((ref) {
  return RideSearchQuery(
    origin: 'Ahmedabad',
    destination: 'Rajkot',
    date: DateTime.now(),
    seats: 1,
  );
});

final searchRidesProvider = FutureProvider.autoDispose<List<RideModel>>((
  ref,
) async {
  final repo = ref.watch(ridesRepositoryProvider);
  final query = ref.watch(rideSearchQueryProvider);
  return repo.searchRides(
    origin: query.origin,
    destination: query.destination,
    date: query.date,
    seats: query.seats,
  );
});

final selectedRideProvider = StateProvider<RideModel?>((ref) => null);
final selectedSeatsProvider = StateProvider<List<String>>((ref) => ['A1']);
