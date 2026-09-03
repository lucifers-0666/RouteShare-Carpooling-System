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
  final TextEditingController _identifierController = TextEditingController(text: '9876543210');
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile number or email')),
      );
      return;
    }

    if (password.isEmpty) {
      // If password is empty, attempt OTP login path
      await ref.read(authProvider.notifier).sendOtp(identifier);
      if (mounted) context.push('/otp');
      return;
    }

    final success = await ref.read(authProvider.notifier).login(
          identifier: identifier,
          password: password,
        );

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      final errorMsg = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg ?? 'Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stitch Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: const BoxDecoration(
                  color: AppColors.softForest,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryForest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.directions_car_filled_rounded,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sahyān',
                          style: AppTypography.screenTitle.copyWith(
                            color: AppColors.deepForest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Find people going\nyour way.',
                      style: AppTypography.screenTitle.copyWith(
                        color: AppColors.deepForest,
                        fontSize: 26,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Share your journey with verified people travelling along the same route.',
                      style: AppTypography.secondary.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign In',
                      style: AppTypography.screenTitle.copyWith(
                        color: AppColors.deepForest,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Identifier Input
                    AppTextField(
                      label: 'Mobile Number or Email',
                      hint: '98765 43210 or email@example.com',
                      controller: _identifierController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryForest, size: 20),
                    ),
                    const SizedBox(height: 14),

                    // Password Input
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryForest, size: 20),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primaryForest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    PrimaryButton(
                      text: 'Sign In',
                      isLoading: authState.isLoading,
                      onPressed: _handleLogin,
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: AppTypography.secondary),
                        TextButton(
                          onPressed: () => context.push('/register'),
                          child: Text(
                            'Register Now',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primaryForest,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),

                    // Stitch Trust Indicators
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _buildTrustBadge(Icons.check_circle_outline_rounded, 'Verified community'),
                        _buildTrustBadge(Icons.shield_outlined, 'Safe shared rides'),
                        _buildTrustBadge(Icons.payments_outlined, 'Fair contribution'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.mutedSage),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
