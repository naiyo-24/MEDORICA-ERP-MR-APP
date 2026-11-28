import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/chemist_shop.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class ChemistShopCard extends StatelessWidget {
  final ChemistShop shop;

  const ChemistShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/mr/chemist/${shop.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF3A3A3A)
    : AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.lg),
                topRight: Radius.circular(AppBorderRadius.lg),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: shop.photo.isNotEmpty
                    ? Image.network(
                        ApiUrl.getFullUrl(shop.photo),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Iconsax.shop,
                            size: 64,
                            color: AppColors.quaternary,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Iconsax.shop,
                          size: 64,
                          color: AppColors.quaternary,
                        ),
                      ),
              ),
            ),
            // Shop Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name
                  Text(
                    shop.name,
                    style: AppTypography.h3.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Iconsax.location,
                        size: 16,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          shop.location,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Phone Number
                  Row(
                    children: [
                      const Icon(
                        Iconsax.call,
                        size: 16,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        shop.phoneNumber,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // View Details Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push('/mr/chemist/${shop.id}'),
                      icon: Icon(
                        Iconsax.eye,
                        size: 16,
                        color: colorScheme.onSurface,
                      ),
                      label: Text(
                        'View Details',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
