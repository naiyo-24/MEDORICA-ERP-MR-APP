import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ads.dart';
import '../provider/ads_provider.dart';

class AdsState {
  final List<Ads> ads;
  final bool loading;

  const AdsState({this.ads = const [], this.loading = false});

  AdsState copyWith({List<Ads>? ads, bool? loading}) {
    return AdsState(ads: ads ?? this.ads, loading: loading ?? this.loading);
  }
}

class AdsNotifier extends Notifier<AdsState> {
  List<Ads> _all = [];

  @override
  AdsState build() {
    return const AdsState();
  }

  Future<void> loadAds() async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 250));
    _all = AdsRepository.loadSampleAds();
    state = state.copyWith(ads: List.of(_all), loading: false);
  }

  Future<void> refresh() async => loadAds();
}