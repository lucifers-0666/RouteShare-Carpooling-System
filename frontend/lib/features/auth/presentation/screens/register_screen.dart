import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Live password validation state
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  bool _isConfirmTouched = false;
  bool _doPasswordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(password);
      _hasNumber = RegExp(r'\d').hasMatch(password);
      _hasSpecialChar = RegExp(r'[\W_]').hasMatch(password);

      if (_isConfirmTouched) {
        _doPasswordsMatch =
            password.isNotEmpty && password == _confirmPasswordController.text;
      }
    });
  }

  void _onConfirmPasswordChanged() {
    final confirm = _confirmPasswordController.text;
    setState(() {
      _isConfirmTouched = confirm.isNotEmpty;
      _doPasswordsMatch =
          confirm.isNotEmpty && confirm == _passwordController.text;
    });
  }

  bool get _isPasswordFullyValid =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSpecialChar;

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isPasswordFullyValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please satisfy all password security requirements'),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final rawPhone = _phoneController.text.trim();
    final cleanDigits = rawPhone.replaceAll(RegExp(r'\D'), '');
    final localPhone = cleanDigits.length == 12 && cleanDigits.startsWith('91')
        ? cleanDigits.substring(2)
        : cleanDigits;

    final success = await ref
        .read(authProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim().toLowerCase(),
          phone: localPhone,
          password: _passwordController.text,
        );

    if (success && mounted) {
      context.push('/otp');
    } else if (mounted) {
      final errorMsg = ref.read(authProvider).errorMessage;
      if (errorMsg != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
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
        title: Text('Create Account', style: AppTypography.sectionHeader),
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
                      'Join Sahyān',
                      style: AppTypography.screenTitle.copyWith(
                        color: AppColors.deepForest,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create your account to start sharing routes and vehicle seats',
                      style: AppTypography.secondary.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    AppTextField(
                      label: 'Full Name',
                      hint: 'e.g. Arjun Patel',
                      controller: _nameController,
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: AppColors.primaryForest,
                        size: 20,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        if (v.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        if (v.trim().length > 50) {
                          return 'Name cannot exceed 50 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Email Address
                    AppTextField(
                      label: 'Email Address',
                      hint: 'arjun@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.alternate_email_rounded,
                        color: AppColors.primaryForest,
                        size: 20,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(v.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Mobile Number
                    AppTextField(
                      label: 'Mobile Number',
                      hint: '9876543210',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Text(
                          '+91',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Mobile number is required';
                        }
                        final clean = v.trim().replaceAll(RegExp(r'\D'), '');
                        final local =
                            clean.length == 12 && clean.startsWith('91')
                            ? clean.substring(2)
                            : clean;
                        if (local.length != 10) {
                          return 'Enter a valid 10-digit mobile number';
                        }
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(local)) {
                          return 'Enter a valid Indian mobile number starting with 6-9';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password
                    AppTextField(
                      label: 'Password',
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
                          return 'Password is required';
                        }
                        if (!_isPasswordFullyValid) {
                          return 'Password must satisfy all security rules below';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Live Password Security Checklist
                    _buildPasswordPolicyChecklist(),
                    const SizedBox(height: 14),

                    // Confirm Password
                    AppTextField(
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.primaryForest,
                        size: 20,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (v != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    // Real-time Confirm Password Match Feedback
                    if (_isConfirmTouched) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            _doPasswordsMatch
                                ? Icons.check_circle_rounded
                                : Icons.cancel_outlined,
                            size: 14,
                            color: _doPasswordsMatch
                                ? AppColors.primaryForest
                                : AppColors.mutedRust,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _doPasswordsMatch
                                ? 'Passwords match'
                                : 'Passwords do not match',
                            style: AppTypography.caption.copyWith(
                              color: _doPasswordsMatch
                                  ? AppColors.primaryForest
                                  : AppColors.mutedRust,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 28),

                    PrimaryButton(
                      text: 'Register & Verify OTP',
                      isLoading: authState.isLoading,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: AppTypography.secondary,
                          ),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              'Sign In',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primaryForest,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordPolicyChecklist() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.softForest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements:',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.deepForest,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _buildPolicyItem('8+ characters', _hasMinLength),
              _buildPolicyItem('Uppercase (A-Z)', _hasUppercase),
              _buildPolicyItem('Lowercase (a-z)', _hasLowercase),
              _buildPolicyItem('Number (0-9)', _hasNumber),
              _buildPolicyItem('Special character', _hasSpecialChar),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String label, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 13,
          color: isMet
              ? AppColors.primaryForest
              : AppColors.textSecondary.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            color: isMet ? AppColors.deepForest : AppColors.textSecondary,
            fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
