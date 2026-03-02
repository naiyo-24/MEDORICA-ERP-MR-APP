import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/chemist_shop.dart';
import '../notifiers/chemist_shop_notifier.dart';

// Provider for the list of chemist shops
final chemistShopProvider =
    StateNotifierProvider<ChemistShopNotifier, List<ChemistShop>>((ref) {
  return ChemistShopNotifier();
});

// Provider for a single chemist shop by ID
final chemistShopDetailProvider =
    Provider.family<ChemistShop?, String>((ref, id) {
  final shops = ref.watch(chemistShopProvider);
  try {
    return shops.firstWhere((shop) => shop.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for searched chemist shops
final searchChemistShopProvider =
    Provider.family<List<ChemistShop>, String>((ref, query) {
  final shops = ref.watch(chemistShopProvider);
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
  final shops = ref.watch(chemistShopProvider);
  if (location.isEmpty) return shops;
  return shops
      .where((shop) => shop.location.toLowerCase().contains(location.toLowerCase()))
      .toList();
});
