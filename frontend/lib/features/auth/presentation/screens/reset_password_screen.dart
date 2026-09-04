import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? initialToken;

  const ResetPasswordScreen({super.key, this.initialToken});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .resetPassword(
          token: _tokenController.text.trim(),
          newPassword: _passwordController.text.trim(),
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successful. Please sign in.'),
        ),
      );
      context.go('/login');
    } else if (mounted) {
      final errorMsg = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg ?? 'Failed to reset password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reset Password',
                      style: AppTypography.screenTitle.copyWith(
                        color: AppColors.deepForest,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your verification token and choose a secure new password.',
                      style: AppTypography.secondary.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 28),

                    AppTextField(
                      label: 'Reset Token',
                      hint: 'Paste your reset token',
                      controller: _tokenController,
                      prefixIcon: const Icon(
                        Icons.vpn_key_outlined,
                        color: AppColors.primaryForest,
                        size: 20,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Token is required'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    AppTextField(
                      label: 'New Password',
                      hint: 'Min. 8 characters with special character',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryForest,
                        size: 20,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'New password is required';
                        }
                        if (v.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(v)) {
                          return 'Must include at least one uppercase letter';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(v)) {
                          return 'Must include at least one lowercase letter';
                        }
                        if (!RegExp(r'\d').hasMatch(v)) {
                          return 'Must include at least one number';
                        }
                        if (!RegExp(r'[\W_]').hasMatch(v)) {
                          return 'Must include at least one special character';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    AppTextField(
                      label: 'Confirm New Password',
                      hint: 'Re-enter new password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.primaryForest,
                        size: 20,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (v != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    PrimaryButton(
                      text: 'Update Password',
                      isLoading: authState.isLoading,
                      onPressed: _handleReset,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
