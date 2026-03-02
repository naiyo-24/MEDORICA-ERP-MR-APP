import 'package:flutter_riverpod/legacy.dart';
import '../models/mr.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final MedicalRepresentative? mr;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.mr,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    MedicalRepresentative? mr,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      mr: mr ?? this.mr,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication - replace with actual API call
      if (phone.isNotEmpty && password.isNotEmpty) {
        final mr = MedicalRepresentative(
          id: '1',
          name: 'John Doe',
          phone: phone,
          email: 'john.doe@medorica.com',
          designation: 'Medical Representative',
          territory: 'North Delhi',
        );

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          mr: mr,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid phone number or password',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
    }
  }

  void logout() {
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
