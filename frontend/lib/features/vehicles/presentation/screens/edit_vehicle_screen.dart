import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sahyan/app/theme/app_colors.dart';
import 'package:sahyan/app/theme/app_typography.dart';
import 'package:sahyan/core/widgets/app_text_field.dart';
import 'package:sahyan/core/widgets/primary_button.dart';
import 'package:sahyan/features/vehicles/domain/vehicle_model.dart';
import 'package:sahyan/features/vehicles/presentation/vehicle_provider.dart';
import 'package:sahyan/features/vehicles/presentation/screens/add_vehicle_screen.dart';

class EditVehicleScreen extends ConsumerStatefulWidget {
  final VehicleModel vehicle;

  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  ConsumerState<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends ConsumerState<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _vehicleType;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _regController;
  late final TextEditingController _yearController;
  late final TextEditingController _colorController;
  late int _seatCapacity;
  late String _status;
  bool _isSubmitting = false;

  final List<Map<String, String>> _vehicleTypes = [
    {'value': 'hatchback', 'label': 'Hatchback'},
    {'value': 'sedan', 'label': 'Sedan'},
    {'value': 'suv', 'label': 'SUV'},
    {'value': 'motorcycle', 'label': 'Motorcycle'},
    {'value': 'other', 'label': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    _vehicleType = widget.vehicle.vehicleType;
    _makeController = TextEditingController(text: widget.vehicle.make);
    _modelController = TextEditingController(text: widget.vehicle.model);
    _regController = TextEditingController(
      text: widget.vehicle.registrationNumber,
    );
    _yearController = TextEditingController(
      text: widget.vehicle.year.toString(),
    );
    _colorController = TextEditingController(text: widget.vehicle.color);
    _seatCapacity = widget.vehicle.seatCapacity;
    _status = widget.vehicle.status;
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _regController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
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
          .updateVehicle(
            id: widget.vehicle.id,
            registrationNumber: normalizedReg,
            vehicleType: _vehicleType,
            make: _makeController.text.trim(),
            model: _modelController.text.trim(),
            year: parsedYear,
            color: _colorController.text.trim(),
            seatCapacity: _seatCapacity,
            status: _status,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle details updated successfully.'),
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
        title: Text('Edit Vehicle', style: AppTypography.screenTitle),
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
                          'Update Vehicle Details',
                          style: AppTypography.cardTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Modify specs, passenger capacity, or availability status.',
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
                        const SizedBox(height: 20),

                        // Vehicle Availability Status Switch
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warmBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Active for Carpooling',
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'When inactive, this vehicle will not be selectable for offering rides.',
                                      style: AppTypography.secondary.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _status == 'active',
                                activeTrackColor: AppColors.primaryForest,
                                onChanged: (val) {
                                  setState(() {
                                    _status = val ? 'active' : 'inactive';
                                  });
                                },
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
                  text: 'Save Changes',
                  isLoading: _isSubmitting,
                  onPressed: _save,
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
