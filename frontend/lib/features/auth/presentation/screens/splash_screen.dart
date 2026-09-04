import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_startup_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNavigation(AppStartupStatus status) {
    if (!mounted) return;
    switch (status) {
      case AppStartupStatus.onboardingRequired:
        context.go('/onboarding');
        break;
      case AppStartupStatus.authEntryRequired:
        context.go('/auth-entry');
        break;
      case AppStartupStatus.ready:
        context.go('/home');
        break;
      case AppStartupStatus.initializing:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppStartupState>(appStartupProvider, (previous, next) {
      if (next.status != AppStartupStatus.initializing) {
        _handleNavigation(next.status);
      }
    });

    final startupState = ref.watch(appStartupProvider);
    if (startupState.status != AppStartupStatus.initializing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNavigation(startupState.status);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryForest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryForest.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  size: 48,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Sahyān',
                style: AppTypography.screenTitle.copyWith(
                  fontSize: 34,
                  color: AppColors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Saath chalo, safar baanto',
                style: AppTypography.secondary.copyWith(
                  color: AppColors.softForest,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.mutedBrass,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
