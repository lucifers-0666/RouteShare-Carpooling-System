import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/ride_card.dart';
import '../rides_provider.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(rideSearchQueryProvider);
    final ridesAsync = ref.watch(searchRidesProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${query.origin} → ${query.destination}',
              style: AppTypography.sectionHeader.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Today • ${query.seats} Seat(s)',
              style: AppTypography.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primaryForest),
            onPressed: () {},
          ),
        ],
      ),
      body: ridesAsync.when(
        data: (rides) {
          if (rides.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.no_drinks_rounded, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No matching rides found', style: AppTypography.sectionHeader),
                  const SizedBox(height: 8),
                  Text('Try adjusting your route or timing filter', style: AppTypography.secondary),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return RideCard(
                ride: ride,
                onTap: () {
                  ref.read(selectedRideProvider.notifier).state = ride;
                  context.push('/ride-details');
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryForest),
        ),
        error: (err, stack) => Center(
          child: Text('Error loading rides: $err', style: AppTypography.bodyMedium),
        ),
      ),
    );
  }
}
