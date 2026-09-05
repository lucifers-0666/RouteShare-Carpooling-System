import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sahyan/app/theme/app_colors.dart';
import 'package:sahyan/app/theme/app_typography.dart';
import 'package:sahyan/core/widgets/primary_button.dart';
import 'package:sahyan/features/vehicles/domain/vehicle_model.dart';
import 'package:sahyan/features/vehicles/presentation/vehicle_provider.dart';

class MyVehiclesScreen extends ConsumerWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: AppColors.warmBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('My Vehicles', style: AppTypography.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primaryForest),
            tooltip: 'Add Vehicle',
            onPressed: () => context.push('/vehicles/add'),
          ),
        ],
      ),
      body: SafeArea(
        child: vehiclesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryForest),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.mutedRust,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to Load Vehicles',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: AppTypography.secondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Try Again',
                    onPressed: () =>
                        ref.read(vehiclesProvider.notifier).refresh(),
                  ),
                ],
              ),
            ),
          ),
          data: (vehicles) {
            if (vehicles.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildVehicleList(context, ref, vehicles);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.softForest,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                size: 44,
                color: AppColors.primaryForest,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Vehicles Registered',
              style: AppTypography.screenTitle.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Register your vehicle to unlock driver privileges, offer rides along your commute route, and share travel costs.',
              style: AppTypography.secondary.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Add Your First Vehicle',
              onPressed: () => context.push('/vehicles/add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList(
    BuildContext context,
    WidgetRef ref,
    List<VehicleModel> vehicles,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Registered Fleet (${vehicles.length})',
            style: AppTypography.cardTitle,
          ),
          const SizedBox(height: 4),
          Text(
            'Active vehicles eligible for route pooling and ride offerings.',
            style: AppTypography.secondary.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 16),
          ...vehicles.map(
            (vehicle) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildVehicleCard(context, ref, vehicle),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.primaryForest),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.primaryForest,
              size: 20,
            ),
            label: Text(
              'Add Another Vehicle',
              style: AppTypography.button.copyWith(
                color: AppColors.primaryForest,
              ),
            ),
            onPressed: () => context.push('/vehicles/add'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context,
    WidgetRef ref,
    VehicleModel vehicle,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.softForest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    vehicle.vehicleType == 'motorcycle'
                        ? Icons.two_wheeler_rounded
                        : Icons.directions_car_rounded,
                    color: AppColors.primaryForest,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.displayName,
                        style: AppTypography.screenTitle.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warmBackground,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          vehicle.registrationNumber,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: vehicle.status == 'active'
                        ? AppColors.softForest
                        : AppColors.warmBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    vehicle.status == 'active' ? 'Active' : 'Inactive',
                    style: AppTypography.caption.copyWith(
                      color: vehicle.status == 'active'
                          ? AppColors.primaryForest
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildDetailChip(
                  icon: Icons.category_outlined,
                  label: vehicle.typeDisplay,
                ),
                _buildDetailChip(
                  icon: Icons.calendar_today_outlined,
                  label: '${vehicle.year}',
                ),
                _buildDetailChip(
                  icon: Icons.palette_outlined,
                  label: vehicle.color,
                ),
                _buildDetailChip(
                  icon: Icons.airline_seat_recline_normal_rounded,
                  label: '${vehicle.seatCapacity} Seats',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.mutedRust,
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Delete'),
                  onPressed: () => _confirmDelete(context, ref, vehicle),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  label: Text(
                    'Edit',
                    style: AppTypography.button.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () {
                    context.push('/vehicles/edit', extra: vehicle);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.secondary.copyWith(fontSize: 13)),
      ],
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    VehicleModel vehicle,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Vehicle', style: AppTypography.cardTitle),
        content: Text(
          'Are you sure you want to delete ${vehicle.displayName} (${vehicle.registrationNumber})? This will remove the vehicle from your fleet.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mutedRust,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(vehiclesProvider.notifier)
                    .deleteVehicle(vehicle.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${vehicle.displayName} deleted successfully',
                      ),
                      backgroundColor: AppColors.primaryForest,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: ${e.toString()}'),
                      backgroundColor: AppColors.mutedRust,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: AppTypography.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
