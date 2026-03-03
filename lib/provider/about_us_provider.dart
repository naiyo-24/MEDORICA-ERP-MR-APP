import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/about_us.dart';
import '../notifiers/about_us_notifier.dart';

final aboutUsNotifierProvider = ChangeNotifierProvider<AboutUsNotifier>((ref) {
  return AboutUsNotifier();
});

final aboutUsProvider = Provider<AboutUs?>((ref) {
  return ref.watch(aboutUsNotifierProvider).aboutUs;
});

final aboutUsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(aboutUsNotifierProvider).isLoading;
});

final aboutUsErrorProvider = Provider<String?>((ref) {
  return ref.watch(aboutUsNotifierProvider).error;
});
