import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sahyan/app/theme/app_colors.dart';
import 'package:sahyan/app/theme/app_typography.dart';
import 'package:sahyan/core/widgets/app_text_field.dart';
import 'package:sahyan/core/widgets/primary_button.dart';
import 'package:sahyan/features/vehicles/presentation/vehicle_provider.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  String _vehicleType = 'hatchback';
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _regController = TextEditingController();
  final _yearController = TextEditingController(text: '2023');
  final _colorController = TextEditingController();
  int _seatCapacity = 4;
  bool _isSubmitting = false;

  final List<Map<String, String>> _vehicleTypes = [
    {'value': 'hatchback', 'label': 'Hatchback'},
    {'value': 'sedan', 'label': 'Sedan'},
    {'value': 'suv', 'label': 'SUV'},
    {'value': 'motorcycle', 'label': 'Motorcycle'},
    {'value': 'other', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _regController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final parsedYear = int.parse(_yearController.text.trim());
      final normalizedReg = _regController.text
          .trim()
          .replaceAll(' ', '')
          .toUpperCase();

      await ref
          .read(vehiclesProvider.notifier)
          .addVehicle(
            registrationNumber: normalizedReg,
            vehicleType: _vehicleType,
            make: _makeController.text.trim(),
            model: _modelController.text.trim(),
            year: parsedYear,
            color: _colorController.text.trim(),
            seatCapacity: _seatCapacity,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Vehicle registered successfully! Driver capability enabled.',
            ),
            backgroundColor: AppColors.primaryForest,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('ApiException: ', '')),
            backgroundColor: AppColors.mutedRust,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Add Vehicle', style: AppTypography.screenTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border, width: 1),
                  ),
                  color: AppColors.cardBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Information',
                          style: AppTypography.cardTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Provide accurate details for route matching and rider trust.',
                          style: AppTypography.secondary.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // Vehicle Type Dropdown
                        Text(
                          'Vehicle Type',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.warmBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _vehicleType,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textPrimary,
                              ),
                              items: _vehicleTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type['value'],
                                  child: Text(
                                    type['label']!,
                                    style: AppTypography.bodyMedium,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _vehicleType = val;
                                    if (val == 'motorcycle' &&
                                        _seatCapacity > 1) {
                                      _seatCapacity = 1;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Make Field
                        AppTextField(
                          label: 'Make',
                          hint: 'e.g. Maruti Suzuki, Hyundai, Tata',
                          controller: _makeController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Make required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Model Field
                        AppTextField(
                          label: 'Model',
                          hint: 'e.g. Swift VXI, Creta, Nexon',
                          controller: _modelController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Model required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Registration Number
                        AppTextField(
                          label: 'Registration Number',
                          hint: 'e.g. GJ01AB1234',
                          controller: _regController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9\s]'),
                            ),
                            UpperCaseTextFormatter(),
                          ],
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Registration number is required';
                            }
                            final clean = val.replaceAll(' ', '');
                            if (clean.length < 4 || clean.length > 15) {
                              return 'Enter a valid registration number (4-15 chars)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Year Field
                        AppTextField(
                          label: 'Manufacturing Year',
                          hint: 'e.g. 2023',
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Year required';
                            }
                            final y = int.tryParse(val.trim());
                            final currentYear = DateTime.now().year;
                            if (y == null || y < 1990 || y > currentYear + 1) {
                              return 'Year must be between 1990 and ${currentYear + 1}';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Color Field
                        AppTextField(
                          label: 'Color',
                          hint: 'e.g. Arctic White, Silky Silver, Black',
                          controller: _colorController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Color required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Seat Capacity Counter
                        Text(
                          'Available Passenger Seat Capacity',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total seats available for co-commuters excluding the driver.',
                          style: AppTypography.secondary.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warmBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.airline_seat_recline_normal_rounded,
                                color: AppColors.primaryForest,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '$_seatCapacity ${_seatCapacity == 1 ? "Passenger Seat" : "Passenger Seats"}',
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline_rounded,
                                ),
                                color: _seatCapacity > 1
                                    ? AppColors.primaryForest
                                    : AppColors.textSecondary.withValues(
                                        alpha: 0.5,
                                      ),
                                onPressed: _seatCapacity > 1
                                    ? () => setState(() => _seatCapacity--)
                                    : null,
                              ),
                              Text(
                                '$_seatCapacity',
                                style: AppTypography.screenTitle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                ),
                                color:
                                    _seatCapacity <
                                        (_vehicleType == 'motorcycle' ? 1 : 8)
                                    ? AppColors.primaryForest
                                    : AppColors.textSecondary.withValues(
                                        alpha: 0.5,
                                      ),
                                onPressed:
                                    _seatCapacity <
                                        (_vehicleType == 'motorcycle' ? 1 : 8)
                                    ? () => setState(() => _seatCapacity++)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Register Vehicle',
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
