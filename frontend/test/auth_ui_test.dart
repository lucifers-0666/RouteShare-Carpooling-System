import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahyan/app/theme/app_theme.dart';
import 'package:sahyan/features/auth/presentation/screens/login_screen.dart';
import 'package:sahyan/features/auth/presentation/screens/register_screen.dart';
import 'package:sahyan/features/auth/presentation/screens/otp_screen.dart';
import 'package:sahyan/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sahyan/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:sahyan/features/auth/presentation/auth_provider.dart';
import 'package:sahyan/features/auth/data/auth_repository.dart';
import 'package:sahyan/core/storage/secure_storage_service.dart';
import 'package:sahyan/core/network/api_client.dart';
import 'package:sahyan/shared/models/user_model.dart';
import 'package:sahyan/core/widgets/app_text_field.dart';

class MockSecureStorageService implements SecureStorageService {
  @override
  Future<void> saveToken(String token) async {}
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> deleteToken() async {}
  @override
  Future<void> saveUser(UserModel user) async {}
  @override
  Future<UserModel?> getUser() async => null;
  @override
  Future<void> deleteUser() async {}
  @override
  Future<void> clearSession() async {}
  @override
  Future<void> setCompletedOnboarding(bool completed) async {}
  @override
  Future<bool> hasCompletedOnboarding() async => true;
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async => {};
  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async => {};
  @override
  Future<Map<String, dynamic>> sendOtp(String phone) async => {};
  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async => {};
  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async => {};
  @override
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async => {};
  @override
  Future<UserModel> getProfile() async => UserModel(
    id: 'usr_1',
    name: 'Test',
    email: 'test@example.com',
    phone: '+919876543210',
    city: 'Ahmedabad',
    verificationStatus: UserVerificationStatus.verified,
    rating: 5.0,
    totalRides: 0,
  );
}

class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier()
    : super(
        repository: MockAuthRepository(),
        storageService: MockSecureStorageService(),
        apiClient: ApiClient(),
      ) {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

Widget createTestApp(Widget child, {double width = 390, double height = 844}) {
  return ProviderScope(
    overrides: [authProvider.overrideWith((ref) => TestAuthNotifier())],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Responsive LoginScreen UI Tests', () {
    for (final width in [320.0, 390.0, 600.0]) {
      testWidgets(
        'LoginScreen renders without overflow on width ${width.toInt()}dp',
        (tester) async {
          tester.view.physicalSize = Size(width, 844);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            createTestApp(const LoginScreen(), width: width),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.text('Sign In'), findsWidgets);
          expect(find.text('Password'), findsWidgets);
          expect(find.text('Phone OTP'), findsOneWidget);

          // Switch to OTP tab
          await tester.tap(find.text('Phone OTP'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 250));

          expect(find.text('Send OTP'), findsOneWidget);
          expect(find.text('+91'), findsOneWidget);

          // Switch back to Password tab
          await tester.tap(find.text('Password').first);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 250));

          expect(find.text('Forgot Password?'), findsOneWidget);
        },
      );
    }

    testWidgets('AppTextField password visibility toggle functions correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const Scaffold(
            body: AppTextField(hint: 'Enter password', isPassword: true),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final toggleFinder = find.byType(IconButton);
      expect(toggleFinder, findsOneWidget);

      // Verify eye icon exists
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap toggle to show password
      await tester.tap(toggleFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  group('Responsive RegisterScreen UI Tests', () {
    for (final width in [320.0, 390.0, 600.0]) {
      testWidgets(
        'RegisterScreen renders without overflow on width ${width.toInt()}dp',
        (tester) async {
          tester.view.physicalSize = Size(width, 844);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            createTestApp(const RegisterScreen(), width: width),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.text('Join Sahyān'), findsOneWidget);
          expect(find.text('Register & Verify OTP'), findsOneWidget);
          expect(find.text('8+ characters'), findsOneWidget);
          expect(find.text('Special character'), findsOneWidget);
        },
      );
    }

    testWidgets('RegisterScreen live password checklist updates on input', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const RegisterScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final passwordFields = find.byType(TextFormField);
      // Field indices: 0: Name, 1: Email, 2: Phone, 3: Password, 4: Confirm
      final passwordInput = passwordFields.at(3);

      // Enter full conforming password
      await tester.enterText(passwordInput, 'StrongPassword123!');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check for green check icons in policy items
      expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
    });
  });

  group('Responsive OtpScreen UI Tests', () {
    for (final width in [320.0, 390.0, 600.0]) {
      testWidgets(
        'OtpScreen renders 6 digits without overflow on width ${width.toInt()}dp',
        (tester) async {
          tester.view.physicalSize = Size(width, 844);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            createTestApp(const OtpScreen(), width: width),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.text('Verify your phone'), findsOneWidget);
          expect(find.text('Verify & Proceed'), findsOneWidget);
          expect(find.text('Resend Code'), findsOneWidget);
        },
      );
    }
  });

  group('Responsive Forgot and Reset Password UI Tests', () {
    for (final width in [320.0, 390.0]) {
      testWidgets(
        'ForgotPasswordScreen and ResetPasswordScreen on width ${width.toInt()}dp',
        (tester) async {
          tester.view.physicalSize = Size(width, 844);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            createTestApp(const ForgotPasswordScreen(), width: width),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          expect(find.text('Forgot Password?'), findsOneWidget);

          await tester.pumpWidget(
            createTestApp(
              const ResetPasswordScreen(initialToken: 'test-token'),
              width: width,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          expect(find.text('Reset Password'), findsOneWidget);
        },
      );
    }
  });
}
