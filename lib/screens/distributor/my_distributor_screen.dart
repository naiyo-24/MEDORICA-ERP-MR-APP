import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/distributor/distributor_card.dart';
import '../../cards/distributor/distributor_search_filter_card.dart';
import '../../provider/distributor_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class DistributorScreen extends ConsumerStatefulWidget {
  const DistributorScreen({super.key});

  @override
  ConsumerState<DistributorScreen> createState() => _DistributorScreenState();
}

class _DistributorScreenState extends ConsumerState<DistributorScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final distributors = ref.watch(distributorListProvider);
    final isLoading = ref.watch(distributorLoadingProvider);
    final error = ref.watch(distributorErrorProvider);
    final filteredDistributors = _searchQuery.isEmpty
        ? distributors
        : distributors
              .where(
                (d) =>
                    d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    (d.location ?? '').toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRouter.home);
        }
      },
      child: Scaffold(
        appBar: const MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'Distributors',
          subtitleText: 'Manage your distributors',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingHorizontal,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              // Search and Filter
              DistributorSearchFilterCard(
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Distributor List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null && distributors.isEmpty
                    ? _DistributorErrorState(
                        message: error,
                        onRetry: () {
                          ref
                              .read(distributorNotifierProvider.notifier)
                              .loadDistributors(forceRefresh: true);
                        },
                      )
                    : filteredDistributors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.box,
                              size: 80,
                              color: AppColors.primaryLight,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No Distributors Found',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.quaternary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Distributors will appear here once available',
                              style: AppTypography.body.copyWith(
                                color: AppColors.quaternary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredDistributors.length,
                        itemBuilder: (context, index) {
                          final distributor = filteredDistributors[index];
                          return DistributorCard(
                            distributor: distributor,
                            onTap: () {
                              context.push(
                                '${AppRouter.distributor}/${distributor.id}',
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 5),
      ),
    );
  }
}

class _DistributorErrorState extends StatelessWidget {
  const _DistributorErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.warning_2, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.body.copyWith(color: AppColors.quaternary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
