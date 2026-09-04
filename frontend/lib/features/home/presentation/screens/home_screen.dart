import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/user_mode_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../rides/presentation/rides_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _originController = TextEditingController(text: 'Ahmedabad');
  final TextEditingController _destinationController = TextEditingController(text: 'Rajkot');
  int _selectedSeats = 1;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    ref.read(rideSearchQueryProvider.notifier).state = RideSearchQuery(
      origin: _originController.text.trim(),
      destination: _destinationController.text.trim(),
      date: _selectedDate,
      seats: _selectedSeats,
    );

    context.push('/search-results');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isGuest = ref.watch(userModeProvider).isGuest;
    final displayName = isGuest
        ? 'Guest Traveler'
        : (authState.user?.name.split(' ').first ?? 'Member');

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.softForest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                color: AppColors.primaryForest,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Sahyān',
              style: AppTypography.sectionHeader.copyWith(
                color: AppColors.deepForest,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.deepForest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Namaste, $displayName',
                              style: AppTypography.screenTitle.copyWith(color: AppColors.white),
                            ),
                        const SizedBox(height: 6),
                        Text(
                          'Where are you travelling today?',
                          style: AppTypography.secondary.copyWith(color: AppColors.softForest),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryForest,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.route_rounded, color: AppColors.white, size: 28),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Card Form
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Find a Shared Ride', style: AppTypography.sectionHeader),
                    const SizedBox(height: 16),

                    // Pickup
                    AppTextField(
                      label: 'Pickup City / Landmark',
                      hint: 'Enter origin city',
                      controller: _originController,
                      prefixIcon: const Icon(Icons.my_location, color: AppColors.primaryForest, size: 20),
                    ),

                    const SizedBox(height: 14),

                    // Destination
                    AppTextField(
                      label: 'Drop Location',
                      hint: 'Enter destination city',
                      controller: _destinationController,
                      prefixIcon: const Icon(Icons.location_on, color: AppColors.mutedSage, size: 20),
                    ),

                    const SizedBox(height: 14),

                    // Date & Seats selector row
                    Row(
                      children: [
                        // Date Picker
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                              );
                              if (picked != null) {
                                setState(() => _selectedDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Date', style: AppTypography.caption),
                                        Text(
                                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Seat Count
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                _selectedSeats = (_selectedSeats % 4) + 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.airline_seat_recline_normal_rounded, size: 20, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Passengers', style: AppTypography.caption),
                                        Text(
                                          '$_selectedSeats Seat${_selectedSeats > 1 ? 's' : ''}',
                                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    PrimaryButton(
                      text: 'Search Rides',
                      icon: Icons.search_rounded,
                      onPressed: _handleSearch,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text('Popular Routes in Gujarat', style: AppTypography.sectionHeader),
            const SizedBox(height: 12),

            // Quick Route Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickRouteChip('Ahmedabad → Rajkot', '₹350'),
                  const SizedBox(width: 10),
                  _buildQuickRouteChip('Vadodara → Surat', '₹280'),
                  const SizedBox(width: 10),
                  _buildQuickRouteChip('Gandhinagar → Bhavnagar', '₹400'),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildQuickRouteChip(String route, String price) {
    return ActionChip(
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      label: Row(
        children: [
          Text(route, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(price, style: AppTypography.caption.copyWith(color: AppColors.primaryForest, fontWeight: FontWeight.bold)),
        ],
      ),
      onPressed: () {
        _originController.text = route.split(' → ').first;
        _destinationController.text = route.split(' → ').last;
        _handleSearch();
      },
    );
  }
}
