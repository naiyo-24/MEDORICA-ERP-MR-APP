
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef, ConsumerWidget;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mr_app/models/month_plan.dart';

import '../../provider/month_plan_provider.dart';
import '../../theme/app_theme.dart';

class PlanCard extends ConsumerWidget {
  final DateTime date;
  const PlanCard({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(monthPlanByDateProvider(date));
    if (plan == null) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Icon(
                    Iconsax.note,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM d').format(date),
                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                      ),
                      // Completion feature removed
                    ],
                  ),
                ),
              ],
            ),
            if (plan.notes != null && plan.notes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.information,
                      size: 16,
                      color: AppColors.quaternary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        plan.notes!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            // Activities
            if (plan.activities.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    'No activities planned',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.quaternary,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: plan.activities.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final activity = plan.activities[index];
                  return _buildActivityItem(context, ref, activity);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    WidgetRef ref,
    PlanActivity activity,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.divider,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Iconsax.activity,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: AppSpacing.md),
            // Activity details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        activity.type.isNotEmpty ? activity.type : 'Activity',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (activity.slot != null && activity.slot!.isNotEmpty) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.access_time, size: 16, color: AppColors.quaternary),
                        const SizedBox(width: 2),
                        Text(
                          activity.slot!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (activity.notes != null && activity.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      activity.notes!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                  if (activity.location != null && activity.location!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.quaternary),
                        const SizedBox(width: 2),
                        Text(
                          activity.location!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}