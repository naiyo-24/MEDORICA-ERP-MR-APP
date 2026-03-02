import 'dart:math' as math;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ads.dart';
import '../provider/ads_provider.dart';
import '../theme/app_theme.dart';

class AdsCarousel extends ConsumerStatefulWidget {
  final double height;

  const AdsCarousel({super.key, this.height = 200});

  @override
  ConsumerState<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends ConsumerState<AdsCarousel> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    // load ads on widget init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adsNotifierProvider.notifier).loadAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adsNotifierProvider);

    if (state.loading) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final ads = state.ads;

    if (ads.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'No ads available',
            style: AppTypography.description.copyWith(color: AppColors.quaternary),
          ),
        ),
      );
    }

    // Reserve a small area for the indicator and spacing so the carousel
    // doesn't take the full height and cause overflow when placed inside
    // a constrained parent (like the sliver flexible space).
    final reservedForIndicator = 20.0; // includes spacer and dots
    final carouselHeight = math.max(56.0, widget.height - reservedForIndicator);

    return SizedBox(
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CarouselSlider.builder(
            itemCount: ads.length,
            options: CarouselOptions(
              height: carouselHeight,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) =>
                  setState(() => _current = index),
            ),
            itemBuilder: (context, index, realIdx) {
              final ad = ads[index];
              return _buildSlide(context, ad);
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ads.asMap().entries.map((entry) {
              final idx = entry.key;
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == idx
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(BuildContext context, Ads ad) {
    final isNetwork = ad.imageUrl.toLowerCase().startsWith('http');
    final image = isNetwork
        ? DecorationImage(image: NetworkImage(ad.imageUrl), fit: BoxFit.cover)
        : DecorationImage(image: AssetImage(ad.imageUrl), fit: BoxFit.cover);

    return ClipRRect(
      borderRadius: AppBorderRadius.lgRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(decoration: BoxDecoration(image: image)),
          // soft gradient overlay for readable text
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(140)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
              vertical: AppSpacing.screenPaddingVertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ad.tagline, style: AppTypography.h3.copyWith(color: AppColors.white)),
                const SizedBox(height: AppSpacing.sm),
                Text(ad.caption, style: AppTypography.description.copyWith(color: Colors.white70)),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: 140,
                  height: 40.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppBorderRadius.lgRadius,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _openLink(ad.link),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.lgRadius,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore',
                            style: AppTypography.tagline.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(
                            Icons.open_in_new,
                            size: 18.0,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLink(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // ignore: avoid_print
        print('Could not launch $url');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Invalid url: $url -> $e');
    }
  }
}