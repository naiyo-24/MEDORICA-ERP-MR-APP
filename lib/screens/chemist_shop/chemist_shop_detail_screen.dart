import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/chemist_shop/chemist_shop_contact_card.dart';
import '../../cards/chemist_shop/chemist_shop_description_caard.dart';
import '../../cards/chemist_shop/chemist_shop_doctors_card.dart';
import '../../cards/chemist_shop/chemist_shop_header_card.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../theme/app_theme.dart';

class ChemistShopDetailScreen extends ConsumerWidget {
  final String shopId;

  const ChemistShopDetailScreen({super.key, required this.shopId});

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Shop',
          style: AppTypography.h3.copyWith(color: AppColors.primary),
        ),
        content: Text(
          'Are you sure you want to delete this shop? This action cannot be undone.',
          style: AppTypography.body.copyWith(color: AppColors.quaternary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.quaternary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(chemistShopProvider.notifier).deleteChemistShop(shopId);
              Navigator.of(context).pop();
              context.go('/mr/chemist');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shop deleted successfully')),
              );
            },
            child: Text(
              'Delete',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(chemistShopDetailProvider(shopId));

    if (shop == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_circle_left,
                color: AppColors.primary),
            onPressed: () => context.go('/mr/chemist'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.info_circle,
                size: 80,
                color: AppColors.quaternary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Shop not found',
                style: AppTypography.h3.copyWith(
                  color: AppColors.quaternary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_circle_left,
                  color: AppColors.white),
              onPressed: () => context.go('/mr/chemist'),
            ),
            title: Text(
              'Shop Details',
              style: AppTypography.h3.copyWith(color: AppColors.white),
            ),
            actions: [
              // Edit Button
              IconButton(
                icon: const Icon(Iconsax.edit, color: AppColors.white),
                onPressed: () => context.push('/mr/chemist/edit/$shopId', extra: shop),
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Iconsax.trash, color: AppColors.white),
                onPressed: () => _showDeleteDialog(context, ref),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ChemistShopHeaderCard(shop: shop),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Card
                  ChemistShopDescriptionCard(
                    description: shop.description,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Doctors Card
                  ChemistShopDoctorsCard(
                    doctorIds: shop.doctorIds,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Contact Card
                  ChemistShopContactCard(shop: shop),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
