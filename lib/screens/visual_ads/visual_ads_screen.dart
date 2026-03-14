import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/visual_ads.dart';
import '../../provider/visual_ads_provider.dart';
import '../../theme/app_theme.dart';

class VisualAdsScreen extends ConsumerStatefulWidget {
  final Set<String>? onlyAdIds;

  const VisualAdsScreen({super.key, this.onlyAdIds});

  @override
  ConsumerState<VisualAdsScreen> createState() => _VisualAdsScreenState();
}

class _VisualAdsScreenState extends ConsumerState<VisualAdsScreen> {
  late PageController _pageController;
  late TransformationController _transformationController;
  late TextEditingController _searchController;
  int _currentIndex = 0;
  bool _isTransitioning = false;
  bool _showSearchField = false;
  double _currentScale = 1.0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _transformationController = TransformationController();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(visualAdsProvider.notifier).loadVisualAds();
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _searchController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() => _currentScale = 1.0);
  }

  void _zoomIn() {
    final next = (_currentScale + 0.25).clamp(1.0, 4.0);
    _transformationController.value = Matrix4.identity()..scale(next);
    setState(() => _currentScale = next);
  }

  void _zoomOut() {
    final next = (_currentScale - 0.25).clamp(1.0, 4.0);
    _transformationController.value = Matrix4.identity()..scale(next);
    setState(() => _currentScale = next);
  }

  Widget _buildAdImage(VisualAd ad) {
    final imagePath = ad.displayImagePath;

    if (imagePath.isEmpty) {
      return _buildImageFallback('Image unavailable');
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildImageFallback('Image not found'),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildImageFallback('Image not found'),
      );
    }

    final file = File(imagePath);
    if (!file.existsSync()) {
      return _buildImageFallback('Downloaded image missing');
    }

    return Image.file(
      file,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _buildImageFallback('Image not found'),
    );
  }

  Widget _buildImageFallback(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 48, color: AppColors.quaternary),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.quaternary),
          ),
        ],
      ),
    );
  }

  void _nextImage() {
    if (_isTransitioning || _currentIndex >= _filteredAds.length - 1) return;
    setState(() => _isTransitioning = true);
    _pageController
        .nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        )
        .then((_) {
          setState(() => _isTransitioning = false);
        })
        .catchError((_) {
          setState(() => _isTransitioning = false);
        });
  }

  void _previousImage() {
    if (_isTransitioning || _currentIndex <= 0) return;
    setState(() => _isTransitioning = true);
    _pageController
        .previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        )
        .then((_) {
          setState(() => _isTransitioning = false);
        })
        .catchError((_) {
          setState(() => _isTransitioning = false);
        });
  }

  List<VisualAd> get _filteredAds {
    final allAds = ref.watch(visualAdsProvider).ads;
    Iterable<VisualAd> scoped = allAds;

    final onlyIds = widget.onlyAdIds;
    if (onlyIds != null && onlyIds.isNotEmpty) {
      scoped = scoped.where(
        (ad) => onlyIds.contains(ad.id.toString()) || onlyIds.contains(ad.adId),
      );
    }

    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      scoped = scoped.where(
        (ad) => ad.medicineName.toLowerCase().contains(query),
      );
    }

    return scoped.toList();
  }

  @override
  Widget build(BuildContext context) {
    final ads = _filteredAds;
    final visualAdsState = ref.watch(visualAdsProvider);
    final isLoading = visualAdsState.isLoading;
    final error = visualAdsState.error;

    if (isLoading && ads.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (ads.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_circle_left, color: AppColors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error ?? 'No visual ads available',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () =>
                    ref.read(visualAdsProvider.notifier).refreshVisualAds(),
                style: AppButtonStyles.primaryButton(height: 44),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Image Carousel with Zoom
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              _resetZoom();
              setState(() => _currentIndex = index);
            },
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              return InteractiveViewer(
                transformationController: _transformationController,
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Container(
                  color: AppColors.black,
                  child: _buildAdImage(ad),
                ),
              );
            },
          ),

          // Top Bar: Back and Search
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withAlpha(200),
                    AppColors.black.withAlpha(0),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.arrow_circle_left,
                        color: AppColors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),

                  // Search area
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(color: AppColors.white.withAlpha(50)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Iconsax.search_normal_1,
                            color: AppColors.white,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(
                              () => _showSearchField = !_showSearchField,
                            );
                            if (!_showSearchField) {
                              _searchController.clear();
                              _searchQuery = '';
                              _pageController.jumpToPage(0);
                              setState(() => _currentIndex = 0);
                            }
                          },
                        ),
                        if (_showSearchField)
                          SizedBox(
                            width: 220,
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search medicine name',
                                hintStyle: AppTypography.bodySmall.copyWith(
                                  color: AppColors.white.withAlpha(170),
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                _searchQuery = value;
                                _pageController.jumpToPage(0);
                                setState(() => _currentIndex = 0);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            right: AppSpacing.lg,
            top: 90,
            child: Column(
              children: [
                _ZoomButton(icon: Iconsax.add, onTap: _zoomIn),
                const SizedBox(height: AppSpacing.sm),
                _ZoomButton(icon: Iconsax.minus, onTap: _zoomOut),
                const SizedBox(height: AppSpacing.sm),
                _ZoomButton(icon: Iconsax.refresh, onTap: _resetZoom),
              ],
            ),
          ),

          // Navigation Buttons (Previous/Next)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.black.withAlpha(200),
                    AppColors.black.withAlpha(0),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info Text
                  Text(
                    '${_currentIndex + 1} / ${ads.length}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    ads[_currentIndex].medicineName,
                    style: AppTypography.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous Button
                      Container(
                        decoration: BoxDecoration(
                          color: (_currentIndex > 0 && !_isTransitioning)
                              ? AppColors.white.withAlpha(30)
                              : AppColors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.md,
                          ),
                          border: Border.all(
                            color: (_currentIndex > 0 && !_isTransitioning)
                                ? AppColors.white.withAlpha(50)
                                : AppColors.white.withAlpha(20),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.arrow_left_3,
                            color: AppColors.white,
                          ),
                          onPressed: (_currentIndex > 0 && !_isTransitioning)
                              ? _previousImage
                              : null,
                        ),
                      ),

                      // Indicator Dots
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            ads.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentIndex
                                    ? AppColors.white
                                    : AppColors.white.withAlpha(100),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Next Button
                      Container(
                        decoration: BoxDecoration(
                          color:
                              (_currentIndex < ads.length - 1 &&
                                  !_isTransitioning)
                              ? AppColors.white.withAlpha(30)
                              : AppColors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.md,
                          ),
                          border: Border.all(
                            color:
                                (_currentIndex < ads.length - 1 &&
                                    !_isTransitioning)
                                ? AppColors.white.withAlpha(50)
                                : AppColors.white.withAlpha(20),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.white,
                          ),
                          onPressed:
                              (_currentIndex < ads.length - 1 &&
                                  !_isTransitioning)
                              ? _nextImage
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withAlpha(30),
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: AppColors.white, size: 18),
        ),
      ),
    );
  }
}