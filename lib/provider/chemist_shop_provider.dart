import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/chemist_shop.dart';
import '../notifiers/chemist_shop_notifier.dart';
import '../services/chemist_shop/chemist_shop_services.dart';

// Service provider
final chemistShopServiceProvider = Provider<ChemistShopServices>((ref) {
  return ChemistShopServices();
});

// Main notifier provider — state is ChemistShopState
final chemistShopProvider =
    StateNotifierProvider<ChemistShopNotifier, ChemistShopState>((ref) {
  return ChemistShopNotifier(
    ref.read(chemistShopServiceProvider),
    ref.read,
  );
});

// Convenience: flat list of shops for widgets that only need the list
final chemistShopListProvider = Provider.autoDispose<List<ChemistShop>>((ref) {
  return ref.watch(chemistShopProvider).shops;
});

// Loading / submitting / error selectors
final chemistShopLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(chemistShopProvider).isLoading;
});

final chemistShopSubmittingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(chemistShopProvider).isSubmitting;
});

final chemistShopErrorProvider = Provider.autoDispose<String?>((ref) {
  return ref.watch(chemistShopProvider).error;
});

// Provider for a single chemist shop by shop_id
final chemistShopDetailProvider =
    Provider.family<ChemistShop?, String>((ref, shopId) {
  final shops = ref.watch(chemistShopListProvider);
  try {
    return shops.firstWhere((shop) => shop.id == shopId);
  } catch (e) {
    return null;
  }
});

// Provider for searched chemist shops
final searchChemistShopProvider =
    Provider.family<List<ChemistShop>, String>((ref, query) {
  final shops = ref.watch(chemistShopListProvider);
  if (query.isEmpty) return shops;
  final lowerQuery = query.toLowerCase();
  return shops
      .where((shop) =>
          shop.name.toLowerCase().contains(lowerQuery) ||
          shop.location.toLowerCase().contains(lowerQuery))
      .toList();
});

// Provider for filtered chemist shops by location
final filteredChemistShopProvider =
    Provider.family<List<ChemistShop>, String>((ref, location) {
  final shops = ref.watch(chemistShopListProvider);
  if (location.isEmpty) return shops;
  return shops
      .where((shop) =>
          shop.location.toLowerCase().contains(location.toLowerCase()))
      .toList();
});

