import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/chemist_shop/chemist_shop_card.dart';
import '../../cards/chemist_shop/chemist_shop_search_filter_card.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyChemistShopScreen extends ConsumerStatefulWidget {
  const MyChemistShopScreen({super.key});

  @override
  ConsumerState<MyChemistShopScreen> createState() =>
      _MyChemistShopScreenState();
}

class _MyChemistShopScreenState extends ConsumerState<MyChemistShopScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allShops = ref.watch(chemistShopProvider);
    final filteredShops = _searchQuery.isEmpty
        ? allShops
        : ref.watch(searchChemistShopProvider(_searchQuery));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go(AppRouter.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: const MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'My Chemist Shops',
          subtitleText: 'Manage your pharmacy network',
        ),
        body: Column(
        children: [
          // Search and Filter Card
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ChemistShopSearchFilterCard(
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
              },
              onFilterTapped: () {
                // TODO: Implement filter bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filter feature coming soon'),
                  ),
                );
              },
            ),
          ),
          // Shops List
          Expanded(
            child: filteredShops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.shop,
                          size: 80,
                          color: AppColors.quaternary.withAlpha(127),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No shops found'
                              : 'No shops match your search',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Add a new shop to get started'
                              : 'Try a different search term',
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = filteredShops[index];
                      return ChemistShopCard(shop: shop);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/mr/chemist/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: AppColors.white),
        label: Text(
          'Add Shop',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 4),
      ),
    );
  }
}
