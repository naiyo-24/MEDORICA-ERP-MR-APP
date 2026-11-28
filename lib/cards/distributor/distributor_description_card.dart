import 'package:flutter/material.dart';
import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorDescriptionCard extends StatelessWidget {
  final Distributor distributor;

  const DistributorDescriptionCard({super.key, required this.distributor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final description = distributor.description?.trim();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: AppTypography.h3.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description == null || description.isEmpty
                  ? 'No distributor description available.'
                  : description,
              style: AppTypography.body.copyWith(
                color: colorScheme.onSurface,
                height: 1.6,
                fontSize: 13,
              ),
              textAlign: TextAlign.justify,
            ),
            if (distributor.products.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Products',
                style: AppTypography.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: distributor.products
                    .map(
                      (product) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withAlpha(110),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          product,
                          style: AppTypography.caption.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}