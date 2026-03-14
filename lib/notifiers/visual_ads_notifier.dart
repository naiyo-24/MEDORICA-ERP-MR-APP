import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import '../models/visual_ads.dart';
import '../services/visual_ads/visual_ads_services.dart';

class VisualAdsState {
  final bool isLoading;
  final List<VisualAd> ads;
  final String? error;

  const VisualAdsState({
    this.isLoading = false,
    this.ads = const [],
    this.error,
  });

  VisualAdsState copyWith({
    bool? isLoading,
    List<VisualAd>? ads,
    String? error,
  }) {
    return VisualAdsState(
      isLoading: isLoading ?? this.isLoading,
      ads: ads ?? this.ads,
      error: error,
    );
  }
}

class VisualAdsNotifier extends StateNotifier<VisualAdsState> {
  VisualAdsNotifier(this._visualAdsServices) : super(const VisualAdsState());

  final VisualAdsServices _visualAdsServices;

  static const String _visualAdsCacheKey = 'visual_ads_cached_list';

  Future<void> loadVisualAds() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final onlineAds = await _visualAdsServices.fetchAllVisualAdsOneByOneAndCache();
      await _persistCache(onlineAds);
      state = state.copyWith(isLoading: false, ads: onlineAds, error: null);
    } catch (error) {
      final offlineAds = await _readCache();
      if (offlineAds.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          ads: offlineAds,
          error: 'Showing downloaded ads (offline mode).',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: _readError(error),
        );
      }
    }
  }

  Future<void> refreshVisualAds() async {
    await loadVisualAds();
  }

  Future<void> _persistCache(List<VisualAd> ads) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(ads.map((ad) => ad.toJson()).toList());
    await prefs.setString(_visualAdsCacheKey, encoded);
  }

  Future<List<VisualAd>> _readCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_visualAdsCacheKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(VisualAd.fromJson)
        .toList();
  }

  String _readError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  void removeVisualAd(String id) {
    state = state.copyWith(
      ads: state.ads.where((ad) => ad.adId != id).toList(),
    );
  }

  void updateVisualAd(VisualAd ad) {
    state = state.copyWith(
      ads: [
        for (final existingAd in state.ads)
          existingAd.adId == ad.adId ? ad : existingAd,
      ],
    );
  }
}