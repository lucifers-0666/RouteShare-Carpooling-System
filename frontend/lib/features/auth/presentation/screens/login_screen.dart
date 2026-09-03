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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
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
              const SizedBox(height: 32),

              Text('Welcome Back', style: AppTypography.screenTitle),
              const SizedBox(height: 6),
              Text(
                'Enter your credentials to sign in to your Sahyān account',
                style: AppTypography.secondary,
              ),
              const SizedBox(height: 32),

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
                    style: AppTypography.caption.copyWith(color: AppColors.primaryForest, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Sign In',
                isLoading: authState.isLoading,
                onPressed: _handleLogin,
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: AppTypography.secondary),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: Text(
                      'Register Now',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryForest, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
