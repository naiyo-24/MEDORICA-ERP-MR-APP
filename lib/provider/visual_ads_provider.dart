import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/visual_ads.dart';
import '../notifiers/visual_ads_notifier.dart';
import '../services/visual_ads/visual_ads_services.dart';

final visualAdsServicesProvider = Provider<VisualAdsServices>((ref) {
  return VisualAdsServices();
});

final visualAdsProvider =
    StateNotifierProvider<VisualAdsNotifier, VisualAdsState>(
  (ref) => VisualAdsNotifier(ref.read(visualAdsServicesProvider)),
);

final visualAdsSearchQueryProvider = StateProvider<String>((ref) => '');

final visualAdsFilteredProvider = Provider<List<VisualAd>>((ref) {
  final ads = ref.watch(visualAdsProvider).ads;
  final query = ref.watch(visualAdsSearchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) {
    return ads;
  }

  return ads.where((ad) => ad.medicineName.toLowerCase().contains(query)).toList();
});

final visualAdsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(visualAdsProvider).isLoading;
});

final visualAdsErrorProvider = Provider<String?>((ref) {
  return ref.watch(visualAdsProvider).error;
});