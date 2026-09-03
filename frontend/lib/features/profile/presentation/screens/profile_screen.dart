import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/verification_badge.dart';
import '../../../../core/widgets/rating_display.dart';
import '../../../auth/presentation/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Account Profile', style: AppTypography.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.softForest,
                      child: Text(
                        (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'A',
                        style: AppTypography.screenTitle.copyWith(fontSize: 32, color: AppColors.primaryForest),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user?.name ?? 'Arjun Patel', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
                        const SizedBox(width: 6),
                        VerificationBadge(isVerified: user?.isVerified ?? true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(user?.email ?? 'arjun.patel@example.com', style: AppTypography.secondary),
                    Text(user?.phone ?? '+91 9876543210', style: AppTypography.secondary),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingDisplay(rating: user?.rating ?? 4.9, reviewCount: user?.totalRides ?? 14),
                        const SizedBox(width: 16),
                        Text('•  ${user?.city ?? "Ahmedabad"}', style: AppTypography.secondary),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Actions
            Card(
              child: Column(
                children: [
                  _buildListTile(Icons.directions_car_outlined, 'My Vehicles & Registration', () {}),
                  const Divider(color: AppColors.border, height: 1),
                  _buildListTile(Icons.verified_user_outlined, 'Government Identity Verification', () {}),
                  const Divider(color: AppColors.border, height: 1),
                  _buildListTile(Icons.payment_outlined, 'Payment Methods & Escrow Wallet', () {}),
                  const Divider(color: AppColors.border, height: 1),
                  _buildListTile(Icons.health_and_safety_outlined, 'Safety Center & Emergency Contacts', () {}),
                  const Divider(color: AppColors.border, height: 1),
                  _buildListTile(Icons.help_outline_rounded, 'Help & Support', () {}),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextButton.icon(
              icon: const Icon(Icons.logout_rounded, color: AppColors.mutedRust),
              label: Text('Log Out', style: AppTypography.button.copyWith(color: AppColors.mutedRust)),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryForest),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
