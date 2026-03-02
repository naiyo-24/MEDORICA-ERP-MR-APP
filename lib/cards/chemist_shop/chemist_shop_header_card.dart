import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/chemist_shop.dart';
import '../../theme/app_theme.dart';

class ChemistShopHeaderCard extends StatelessWidget {
  final ChemistShop shop;

  const ChemistShopHeaderCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Dark Overlay
        Container(
          height: 260,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppBorderRadius.xl),
              bottomRight: Radius.circular(AppBorderRadius.xl),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppBorderRadius.xl),
              bottomRight: Radius.circular(AppBorderRadius.xl),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                shop.photo.startsWith('http')
                    ? Image.network(
                        shop.photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Iconsax.shop,
                            size: 80,
                            color: AppColors.quaternary,
                          ),
                        ),
                      )
                    : Image.asset(
                        shop.photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Iconsax.shop,
                            size: 80,
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                // Dark Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Shop Name and Location
        Positioned(
          bottom: AppSpacing.xl,
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop Name
              Text(
                shop.name,
                style: AppTypography.h1.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Location
              Row(
                children: [
                  const Icon(
                    Iconsax.location,
                    size: 20,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      shop.location,
                      style: AppTypography.body.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
