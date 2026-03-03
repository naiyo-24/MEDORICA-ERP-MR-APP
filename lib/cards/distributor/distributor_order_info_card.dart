import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorOrderInfoCard extends StatelessWidget {
  final Distributor distributor;

  const DistributorOrderInfoCard({super.key, required this.distributor});

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
                  Iconsax.shopping_cart,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Order Information',
                style: AppTypography.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Minimum Order Value
          _InfoRow(
            icon: Iconsax.wallet,
            label: 'Minimum Order Value',
            value: distributor.minimumOrderValue,
            iconColor: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),
          // Delivery Time
          _InfoRow(
            icon: Iconsax.clock,
            label: 'Delivery Time',
            value: distributor.deliveryTime,
            iconColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.quaternary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
