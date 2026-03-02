import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ads.dart';
import '../notifiers/ads_notifier.dart';

/// Small repository that returns sample ads used by `AdsNotifier`.
class AdsRepository {
  static List<Ads> loadSampleAds() {
    return [
      Ads(
        id: 'a1',
        imageUrl:
            'https://pbs.twimg.com/media/GsHO-fQXoAAVwlO.jpg',
        tagline: 'Summer Feast',
        caption: 'Exclusive deals on seasonal flavours.',
        link: 'https://example.com/summer-feast',
      ),
      Ads(
        id: 'a2',
        imageUrl: 'assets/images/home_footer.png',
        tagline: 'New Arrivals',
        caption: 'Discover the latest curated picks.',
        link: 'https://example.com/new',
      ),
      Ads(
        id: 'a3',
        imageUrl:
            'https://pbs.twimg.com/media/GsHO-fQXoAAVwlO.jpg',
        tagline: 'Limited Time',
        caption: 'Hurry — offers end soon.',
        link: 'https://example.com/limited',
      ),
    ];
  }
}

final adsNotifierProvider = NotifierProvider<AdsNotifier, AdsState>(
  AdsNotifier.new,
);