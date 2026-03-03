import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/profile_notifier.dart';
import '../models/mr.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, MedicalRepresentative?>((ref) {
  return ProfileNotifier();
});
