import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/auth_notifier.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
