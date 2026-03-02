import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/home_notifier.dart';

final homeProvider = Provider((ref) {
  return ref.watch(homeNotifierProvider);
});