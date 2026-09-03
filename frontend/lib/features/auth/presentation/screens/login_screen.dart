import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    await ref.read(authProvider.notifier).sendOtp('+91 $phone');
    if (mounted) {
      context.push('/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Brand Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.softForest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      color: AppColors.primaryForest,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sahyān',
                    style: AppTypography.screenTitle.copyWith(color: AppColors.deepForest),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              Text('Welcome to Sahyān', style: AppTypography.screenTitle),
              const SizedBox(height: 8),
              Text(
                'Enter your mobile number to get started with route-based carpooling',
                style: AppTypography.secondary,
              ),
              const SizedBox(height: 36),

              // Mobile Input
              AppTextField(
                label: 'Mobile Number',
                hint: '98765 43210',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Text(
                    '+91',
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Spacer(),

              PrimaryButton(
                text: 'Send OTP',
                isLoading: authState.isLoading,
                onPressed: _handleSendOtp,
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  'By continuing, you agree to Sahyān\'s Terms & Privacy Policy',
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
