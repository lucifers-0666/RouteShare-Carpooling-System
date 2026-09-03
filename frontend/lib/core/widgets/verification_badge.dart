import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class VerificationBadge extends StatelessWidget {
  final bool isVerified;
  final String label;

  const VerificationBadge({
    super.key,
    required this.isVerified,
    this.label = 'Verified',
  });

  @override
  Widget build(BuildContext context) {
    if (!isVerified) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.softBrass,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.mutedBrass.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified,
            size: 14,
            color: AppColors.mutedBrass,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.deepForest,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
