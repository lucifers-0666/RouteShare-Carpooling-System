import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgot() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).forgotPassword(email);
    if (success && mounted) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Reset Password', style: AppTypography.sectionHeader),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forgot Password?', style: AppTypography.screenTitle),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email address and we will send you password reset instructions.',
                style: AppTypography.secondary,
              ),
              const SizedBox(height: 32),

              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softForest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.primaryForest),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'If an account exists, a reset link has been dispatched to your email.',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryForest),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              AppTextField(
                label: 'Email Address',
                hint: 'arjun@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const Spacer(),

              PrimaryButton(
                text: _sent ? 'Resend Reset Link' : 'Send Reset Link',
                isLoading: authState.isLoading,
                onPressed: _handleForgot,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
