import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class SeatSelector extends StatelessWidget {
  final int totalSeats;
  final int availableSeats;
  final List<String> selectedSeats;
  final ValueChanged<List<String>> onSeatsChanged;

  const SeatSelector({
    super.key,
    this.totalSeats = 4,
    required this.availableSeats,
    required this.selectedSeats,
    required this.onSeatsChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Generate seat labels (e.g., Driver: Front Right, Seats: A1 (Front Left), A2 (Back Left), A3 (Back Mid), A4 (Back Right))
    final List<Map<String, dynamic>> seats = [
      {'id': 'A1', 'label': 'Front Left', 'isAvailable': availableSeats >= 1},
      {'id': 'A2', 'label': 'Rear Left', 'isAvailable': availableSeats >= 2},
      {'id': 'A3', 'label': 'Rear Middle', 'isAvailable': availableSeats >= 3},
      {'id': 'A4', 'label': 'Rear Right', 'isAvailable': availableSeats >= 4},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Seat(s)', style: AppTypography.sectionHeader),
              Text(
                '${selectedSeats.length} seat(s) selected',
                style: AppTypography.secondary.copyWith(color: AppColors.primaryForest, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Front Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSeatItem(seats[0]), // Front Passenger (A1)
              // Driver seat representation
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.warmBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.airline_seat_recline_normal, color: AppColors.textSecondary),
                    const SizedBox(height: 4),
                    Text('Driver', style: AppTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          // Rear Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSeatItem(seats[1]),
              _buildSeatItem(seats[2]),
              _buildSeatItem(seats[3]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatItem(Map<String, dynamic> seat) {
    final String id = seat['id'];
    final bool isAvailable = seat['isAvailable'];
    final bool isSelected = selectedSeats.contains(id);

    Color bgColor = AppColors.warmBackground;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    Color iconColor = AppColors.textSecondary;

    if (!isAvailable) {
      bgColor = AppColors.border.withValues(alpha: 0.4);
      textColor = AppColors.textSecondary.withValues(alpha: 0.5);
      iconColor = AppColors.textSecondary.withValues(alpha: 0.4);
    } else if (isSelected) {
      bgColor = AppColors.softForest;
      borderColor = AppColors.primaryForest;
      textColor = AppColors.primaryForest;
      iconColor = AppColors.primaryForest;
    }

    return GestureDetector(
      onTap: isAvailable
          ? () {
              final newSelected = List<String>.from(selectedSeats);
              if (isSelected) {
                newSelected.remove(id);
              } else {
                newSelected.add(id);
              }
              onSeatsChanged(newSelected);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.airline_seat_recline_normal, color: iconColor, size: 22),
            const SizedBox(height: 2),
            Text(
              id,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
