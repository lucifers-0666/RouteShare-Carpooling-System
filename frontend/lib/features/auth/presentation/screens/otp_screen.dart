import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-fill devOtp if present for quick testing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final devOtp = ref.read(authProvider).devOtp;
      if (devOtp != null && devOtp.isNotEmpty) {
        _otpController.text = devOtp;
      }
    });
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 4-digit OTP')),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).verifyOtp(otp);
    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      final errorMsg = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg ?? 'Invalid OTP')),
      );
    }
  }

  void _handleResend() async {
    if (!_canResend) return;
    final phone = ref.read(authProvider).otpSentToPhone;
    if (phone != null) {
      await ref.read(authProvider.notifier).sendOtp(phone);
      _startTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final phoneDisplay = authState.otpSentToPhone ?? '+91 98765 43210';

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your phone',
                style: AppTypography.screenTitle.copyWith(color: AppColors.deepForest),
              ),
              const SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('We sent a verification code to ', style: AppTypography.secondary),
                  Text(
                    phoneDisplay,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primaryForest,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Edit',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryForest,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Dev OTP banner if in dev mode
              if (authState.devOtp != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.softBrass,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.mutedBrass),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.developer_mode, size: 16, color: AppColors.deepForest),
                      const SizedBox(width: 8),
                      Text(
                        'Dev OTP: ${authState.devOtp}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.deepForest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  final hasChar = _otpController.text.length > index;
                  final isCurrent = _otpController.text.length == index;

                  return Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primaryForest
                            : (hasChar ? AppColors.primaryForest : AppColors.border),
                        width: isCurrent ? 2.0 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryForest.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      hasChar ? _otpController.text[index] : '',
                      style: AppTypography.screenTitle.copyWith(
                        color: AppColors.primaryForest,
                        fontSize: 26,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Hidden text field for keyboard input
              Opacity(
                opacity: 0.0,
                child: SizedBox(
                  height: 1,
                  child: TextField(
                    controller: _otpController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (val) {
                      setState(() {});
                      if (val.length == 4) {
                        _handleVerify();
                      }
                    },
                  ),
                ),
              ),

              // Countdown & Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        _canResend
                            ? 'Code expired'
                            : 'Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _canResend ? _handleResend : null,
                    child: Text(
                      'Resend SMS',
                      style: AppTypography.caption.copyWith(
                        color: _canResend ? AppColors.primaryForest : AppColors.mutedSage,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Verify & Continue',
                isLoading: authState.isLoading,
                onPressed: _handleVerify,
              ),

              const SizedBox(height: 28),

              // Stitch Community Trust Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softForest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: AppColors.primaryForest,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy First Mobility',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepForest,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your phone number is masked and stored securely. It is only shared for coordinate boarding verification and critical trip alerts.',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
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
}
