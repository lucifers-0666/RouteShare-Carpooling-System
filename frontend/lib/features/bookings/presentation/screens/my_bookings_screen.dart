import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../bookings_provider.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Bookings', style: AppTypography.screenTitle),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No active bookings', style: AppTypography.sectionHeader),
                  const SizedBox(height: 8),
                  Text('Your confirmed & pending ride bookings will appear here', style: AppTypography.secondary),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.softBrass,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Pending Driver Approval',
                              style: AppTypography.caption.copyWith(color: AppColors.mutedBrass, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '₹${booking.totalAmount.toStringAsFixed(0)}',
                            style: AppTypography.sectionHeader.copyWith(color: AppColors.primaryForest),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${booking.rideDetails?.origin.city} → ${booking.rideDetails?.destination.city}',
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Driver: ${booking.rideDetails?.driverName}', style: AppTypography.secondary),
                      Text('Seats: ${booking.selectedSeats.join(', ')}', style: AppTypography.secondary),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryForest)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
