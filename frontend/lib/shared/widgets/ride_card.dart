import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../models/ride_model.dart';
import '../../core/widgets/verification_badge.dart';
import '../../core/widgets/rating_display.dart';

class RideCard extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onTap;

  const RideCard({
    super.key,
    required this.ride,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Match Badge & Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.softForest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryForest),
                        const SizedBox(width: 4),
                        Text(
                          '${ride.matchPercentage}% Route Match',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primaryForest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${ride.contributionPerSeat.toStringAsFixed(0)} / seat',
                    style: AppTypography.sectionHeader.copyWith(
                      color: AppColors.primaryForest,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Journey Route Timeline
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline graphic
                  Column(
                    children: [
                      const Icon(Icons.radio_button_checked, size: 16, color: AppColors.primaryForest),
                      Container(
                        width: 2,
                        height: 32,
                        color: AppColors.border,
                      ),
                      const Icon(Icons.location_on, size: 16, color: AppColors.mutedSage),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Route details text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                ride.origin.city.isNotEmpty ? ride.origin.city : ride.origin.address,
                                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(ride.departureTime, style: AppTypography.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                ride.destination.city.isNotEmpty ? ride.destination.city : ride.destination.address,
                                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(ride.estimatedArrival, style: AppTypography.secondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),

              // Footer: Driver Info & Seats Available
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.softForest,
                    child: Text(
                      ride.driverName.substring(0, 1).toUpperCase(),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryForest,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ride.driverName,
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 6),
                            VerificationBadge(isVerified: ride.isDriverVerified),
                          ],
                        ),
                        Row(
                          children: [
                            RatingDisplay(rating: ride.driverRating),
                            const SizedBox(width: 8),
                            Text('•  ${ride.vehicle.fullName}', style: AppTypography.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warmBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '${ride.availableSeats} seat(s) left',
                      style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
