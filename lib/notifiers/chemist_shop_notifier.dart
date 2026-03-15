import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

import '../models/chemist_shop.dart';
import '../provider/auth_provider.dart';
import '../services/chemist_shop/chemist_shop_services.dart';

typedef _Reader = T Function<T>(ProviderListenable<T> provider);

class ChemistShopState {
  final List<ChemistShop> shops;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const ChemistShopState({
    this.shops = const <ChemistShop>[],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  ChemistShopState copyWith({
    List<ChemistShop>? shops,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return ChemistShopState(
      shops: shops ?? this.shops,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class ChemistShopNotifier extends StateNotifier<ChemistShopState> {
  ChemistShopNotifier(this._services, this._read)
      : super(const ChemistShopState());

  final ChemistShopServices _services;
  final _Reader _read;

  // ---------------------------------------------------------------------------
  // Fetch
  // ---------------------------------------------------------------------------

  Future<void> loadShopsForCurrentMr() async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'No logged in MR found',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final List<ChemistShop> shops = await _services.fetchShopsByMrId(mrId);
      state = state.copyWith(shops: shops, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  Future<void> addChemistShop(ChemistShop shop) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final ChemistShop created = await _services.createShop(
        mrId: mrId,
        shopName: shop.name,
        phoneNo: shop.phoneNumber,
        address: shop.location.isNotEmpty ? shop.location : null,
        email: shop.email.isNotEmpty ? shop.email : null,
        description: shop.description.isNotEmpty ? shop.description : null,
        photoPath: _isLocalPath(shop.photo) ? shop.photo : null,
      );

      state = state.copyWith(
        shops: <ChemistShop>[created, ...state.shops],
        isSubmitting: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  Future<void> updateChemistShop(ChemistShop updatedShop) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }

    if (updatedShop.id.isEmpty) {
      state = state.copyWith(error: 'Missing shop ID for update');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final ChemistShop saved = await _services.updateShop(
        mrId: mrId,
        shopId: updatedShop.id,
        shopName: updatedShop.name.isNotEmpty ? updatedShop.name : null,
        phoneNo: updatedShop.phoneNumber.isNotEmpty
            ? updatedShop.phoneNumber
            : null,
        address: updatedShop.location.isNotEmpty ? updatedShop.location : null,
        email: updatedShop.email.isNotEmpty ? updatedShop.email : null,
        description: updatedShop.description.isNotEmpty
            ? updatedShop.description
            : null,
        photoPath: _isLocalPath(updatedShop.photo) ? updatedShop.photo : null,
      );

      final List<ChemistShop> next = state.shops.map((ChemistShop item) {
        return item.id == saved.id ? saved : item;
      }).toList();

      state = state.copyWith(shops: next, isSubmitting: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------

  Future<void> deleteChemistShop(String shopId) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      await _services.deleteShop(mrId: mrId, shopId: shopId);

      final List<ChemistShop> remaining =
          state.shops.where((ChemistShop s) => s.id != shopId).toList();

      state = state.copyWith(
        shops: remaining,
        isSubmitting: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns true when [path] is a local file path (not a URL, not empty).
  bool _isLocalPath(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('http://') || path.startsWith('https://')) return false;
    return true;
  }
}

