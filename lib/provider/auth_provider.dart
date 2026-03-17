import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/auth_notifier.dart';
import '../services/auth/auth_services.dart';
import 'gift_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Listen to AuthState and set currentMrIdProvider
final authMrIdListenerProvider = Provider<void>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final mrId = authState.mr?.mrId; // Assumes AuthState has mrId field
  ref.read(currentMrIdProvider.notifier).state = mrId;
});
