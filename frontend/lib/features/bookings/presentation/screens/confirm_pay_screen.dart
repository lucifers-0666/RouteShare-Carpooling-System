import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../rides/presentation/rides_provider.dart';
import '../bookings_provider.dart';

class ConfirmPayScreen extends ConsumerStatefulWidget {
  const ConfirmPayScreen({super.key});

  @override
  ConsumerState<ConfirmPayScreen> createState() => _ConfirmPayScreenState();
}

class _ConfirmPayScreenState extends ConsumerState<ConfirmPayScreen> {
  bool _isProcessing = false;

  void _handleConfirmBooking() async {
    setState(() => _isProcessing = true);

    final ride = ref.read(selectedRideProvider);
    final selectedSeats = ref.read(selectedSeatsProvider);
    final authState = ref.read(authProvider);

    if (ride == null) return;

    final booking = await ref.read(bookingsNotifierProvider.notifier).confirmBooking(
          ride: ride,
          passengerId: authState.user?.id ?? 'usr_arjun_99',
          passengerName: authState.user?.name ?? 'Arjun Patel',
          selectedSeats: selectedSeats,
        );

    ref.read(activeBookingProvider.notifier).state = booking;

    setState(() => _isProcessing = false);

    if (mounted) {
      context.go('/booking-confirmation');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = ref.watch(selectedRideProvider);
    final selectedSeats = ref.watch(selectedSeatsProvider);

    if (ride == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No ride selected')),
      );
    }

    final contribution = ride.contributionPerSeat * selectedSeats.length;
    const platformFee = 25.0;
    final total = contribution + platformFee;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Booking Summary', style: AppTypography.sectionHeader),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Journey Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Journey Details', style: AppTypography.sectionHeader),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.directions_car_filled, color: AppColors.primaryForest),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${ride.origin.city} → ${ride.destination.city}',
                            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Driver: ${ride.driverName} (${ride.vehicle.fullName})', style: AppTypography.secondary),
                    Text('Seats: ${selectedSeats.join(', ')}', style: AppTypography.secondary),
                    Text('Departure: ${ride.departureTime}', style: AppTypography.secondary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Price Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price Breakdown', style: AppTypography.sectionHeader),
                    const SizedBox(height: 16),
                    _buildPriceRow('Seat Contribution (${selectedSeats.length} seat)', '₹${contribution.toStringAsFixed(0)}'),
                    const SizedBox(height: 8),
                    _buildPriceRow('Platform & Escrow Fee', '₹${platformFee.toStringAsFixed(0)}'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: AppColors.border),
                    ),
                    _buildPriceRow('Total Payable', '₹${total.toStringAsFixed(0)}', isTotal: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Payment Escrow Note Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softBrass,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.mutedBrass.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.mutedBrass, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sahyān Escrow Protection', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          'Payment is held securely in escrow and released to the driver only after journey completion.',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ],
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
        child: PrimaryButton(
          text: 'Request Booking & Pay ₹${total.toStringAsFixed(0)}',
          isLoading: _isProcessing,
          onPressed: _handleConfirmBooking,
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? AppTypography.sectionHeader
              : AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          amount,
          style: isTotal
              ? AppTypography.screenTitle.copyWith(color: AppColors.primaryForest)
              : AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
