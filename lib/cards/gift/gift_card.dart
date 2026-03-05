import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/gift.dart';
import '../../provider/doctor_provider.dart';
import '../../theme/app_theme.dart';

class GiftCard extends ConsumerWidget {
  final Gift gift;

  const GiftCard({
    super.key,
    required this.gift,
  });

  Color _getStatusColor(GiftStatus status) {
    switch (status) {
      case GiftStatus.pending:
        return AppColors.primary;
      case GiftStatus.sent:
        return AppColors.secondary;
      case GiftStatus.received:
        return AppColors.success;
      case GiftStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(doctorDetailProvider(gift.doctorId));

    if (doctor == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shadowColor: AppColors.shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.lgRadius,
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info and Edit Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.specialization,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit Icon Button
                IconButton(
                  icon: const Icon(Iconsax.edit, color: AppColors.primary, size: 20),
                  onPressed: () => context.push(
                    '/gifts/edit/${gift.id}',
                    extra: gift,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.divider),
            const SizedBox(height: AppSpacing.md),

            // Gift Item Row
            Row(
              children: [
                const Icon(
                  Iconsax.gift,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    gift.giftItem,
                    style: AppTypography.body.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Occasion Row
            Row(
              children: [
                const Icon(
                  Iconsax.star,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    gift.occasion,
                    style: AppTypography.body.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Date Row
            Row(
              children: [
                const Icon(
                  Iconsax.calendar,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  DateFormat('MMM dd, yyyy').format(gift.date),
                  style: AppTypography.body.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(gift.status).withAlpha(25),
                borderRadius: AppBorderRadius.smRadius,
              ),
              child: Text(
                gift.status.displayName,
                style: AppTypography.caption.copyWith(
                  color: _getStatusColor(gift.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
