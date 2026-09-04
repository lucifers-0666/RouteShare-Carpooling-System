import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../bookings_provider.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(activeBookingProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon Animation
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.softForest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: AppColors.primaryForest,
                ),
              ),
              const SizedBox(height: 24),
              Text('Booking Requested!', style: AppTypography.screenTitle),
              const SizedBox(height: 8),
              Text(
                'Your booking request has been sent to ${booking?.rideDetails?.driverName ?? "the driver"}. You will receive a notification as soon as they confirm.',
                style: AppTypography.secondary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Summary Card
              if (booking != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking Reference',
                              style: AppTypography.caption,
                            ),
                            Text(
                              booking.id.substring(0, 10),
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.border, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Route', style: AppTypography.bodyMedium),
                            Text(
                              '${booking.rideDetails?.origin.city} → ${booking.rideDetails?.destination.city}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Selected Seats',
                              style: AppTypography.secondary,
                            ),
                            Text(
                              booking.selectedSeats.join(', '),
                              style: AppTypography.secondary.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status', style: AppTypography.secondary),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.softBrass,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Pending Driver Approval',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.mutedBrass,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(),

              PrimaryButton(
                text: 'View My Bookings',
                onPressed: () {
                  context.go('/my-bookings');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Back to Home',
                onPressed: () {
                  context.go('/home');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
