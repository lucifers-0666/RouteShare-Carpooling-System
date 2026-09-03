import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/user_mode_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/verification_badge.dart';
import '../../../../core/widgets/rating_display.dart';
import '../../../../shared/widgets/auth_gate_dialog.dart';
import '../rides_provider.dart';

class RideDetailsScreen extends ConsumerWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ride = ref.watch(selectedRideProvider);

    if (ride == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No ride selected')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Ride Overview', style: AppTypography.sectionHeader),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.softForest,
                      child: Text(
                        ride.driverName.substring(0, 1).toUpperCase(),
                        style: AppTypography.screenTitle.copyWith(color: AppColors.primaryForest),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ride.driverName,
                                  style: AppTypography.sectionHeader,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              VerificationBadge(isVerified: ride.isDriverVerified),
                            ],
                          ),
                          const SizedBox(height: 4),
                          RatingDisplay(rating: ride.driverRating, reviewCount: 42),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryForest),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Route Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Journey Route', style: AppTypography.sectionHeader),
                        Text(
                          '${ride.routeDistanceKm} km • ${ride.durationMins} mins',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.radio_button_checked, size: 18, color: AppColors.primaryForest),
                            Container(width: 2, height: 40, color: AppColors.border),
                            const Icon(Icons.location_on, size: 18, color: AppColors.mutedSage),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ride.departureTime, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                              Text(ride.origin.address, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                              Text(ride.origin.city, style: AppTypography.secondary),
                              const SizedBox(height: 16),
                              Text(ride.estimatedArrival, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                              Text(ride.destination.address, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                              Text(ride.destination.city, style: AppTypography.secondary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Vehicle Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warmBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_car_rounded, color: AppColors.primaryForest, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ride.vehicle.fullName, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('Plate: ${ride.vehicle.registrationNumber}', style: AppTypography.secondary),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.softForest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Verified Vehicle', style: AppTypography.caption.copyWith(color: AppColors.primaryForest)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Amenities
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ride Amenities & Preferences', style: AppTypography.sectionHeader),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ride.amenities.map((amenity) {
                        return Chip(
                          backgroundColor: AppColors.warmBackground,
                          side: const BorderSide(color: AppColors.border),
                          label: Text(amenity, style: AppTypography.bodyMedium),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seat Contribution', style: AppTypography.caption),
                Text(
                  '₹${ride.contributionPerSeat.toStringAsFixed(0)}',
                  style: AppTypography.screenTitle.copyWith(color: AppColors.primaryForest),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: PrimaryButton(
                text: 'Select Seats',
                onPressed: () {
                  final isGuest = ref.read(userModeProvider).isGuest;
                  if (isGuest) {
                    AuthGateDialog.show(
                      context,
                      title: 'Sign In to Book Seats',
                      message: 'To reserve seats and communicate with verified drivers, please sign in or register.',
                      intendedRoute: '/seat-selection',
                    );
                    return;
                  }
                  context.push('/seat-selection');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
