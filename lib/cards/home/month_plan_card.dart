import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';
import '../../router/app_router.dart';

class MonthPlanCard extends StatelessWidget {
  const MonthPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkSurface300
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Icon(
                    Iconsax.calendar_1,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkText
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Monthly Planning',
                  style: AppTypography.h3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Plan your month effectively by organizing daily visits, appointments, and tasks. Stay on top of your schedule and achieve your monthly targets.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.quaternary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push(AppRouter.monthPlan);
                    },
                    icon: Icon(Iconsax.eye, size: 18, color: AppColors.white),
                    label: Text(
                      'View Plan',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
