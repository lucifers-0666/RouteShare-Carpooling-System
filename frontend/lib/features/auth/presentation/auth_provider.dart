import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;
  final String? otpSentToPhone;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.otpSentToPhone,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    bool? isLoading,
    String? otpSentToPhone,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      otpSentToPhone: otpSentToPhone ?? this.otpSentToPhone,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      isLoading: false,
      otpSentToPhone: phone,
    );
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock successful OTP verification
    const mockUser = UserModel(
      id: 'usr_arjun_99',
      name: 'Arjun Patel',
      phone: '+91 9876543210',
      email: 'arjun.patel@example.com',
      city: 'Ahmedabad',
      verificationStatus: UserVerificationStatus.verified,
      rating: 4.9,
      totalRides: 14,
    );

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: mockUser,
    );

    return true;
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
