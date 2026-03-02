import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class ChemistShopDescriptionCard extends StatelessWidget {
  final String description;

  const ChemistShopDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: const Icon(
                  Iconsax.document_text,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'About the Shop',
                style: AppTypography.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Description
          Text(
            description,
            style: AppTypography.body.copyWith(
              color: AppColors.quaternary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
