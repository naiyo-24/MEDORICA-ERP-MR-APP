import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/distributor/distributor_card.dart';
import '../../cards/distributor/distributor_search_filter_card.dart';
import '../../provider/distributor_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyDistributorScreen extends ConsumerStatefulWidget {
  const MyDistributorScreen({super.key});

  @override
  ConsumerState<MyDistributorScreen> createState() =>
      _MyDistributorScreenState();
}

class _MyDistributorScreenState extends ConsumerState<MyDistributorScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allDistributors = ref.watch(distributorProvider);
    final filteredDistributors = _searchQuery.isEmpty
        ? allDistributors
        : ref.watch(searchDistributorProvider(_searchQuery));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MRAppBar(
        showBack: false,
        showActions: false,
        titleText: 'My Distributors',
        subtitleText: 'Manage your supply network',
      ),
      body: Column(
        children: [
          // Search and Filter Card
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: DistributorSearchFilterCard(
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
          // Distributors List
          Expanded(
            child: filteredDistributors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.truck,
                          size: 80,
                          color: AppColors.quaternary.withOpacity(0.5),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No distributors found'
                              : 'No distributors match your search',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Add a new distributor to get started'
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
                    itemCount: filteredDistributors.length,
                    itemBuilder: (context, index) {
                      final distributor = filteredDistributors[index];
                      return DistributorCard(distributor: distributor);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 5),
    );
  }
}
