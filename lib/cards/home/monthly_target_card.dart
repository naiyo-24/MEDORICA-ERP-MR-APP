import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../provider/home_provider.dart';
import '../../notifiers/home_notifier.dart';
import '../../theme/app_theme.dart';
import '../../models/target.dart';

class MonthlyTargetCard extends ConsumerWidget {
  const MonthlyTargetCard({super.key});

  Color _getStatusColor(TargetStatus status) {
    switch (status) {
      case TargetStatus.achieved:
        return const Color(0xFF4CAF50); // Green
      case TargetStatus.closeToTarget:
        return const Color(0xFFFFC107); // Amber/Yellow
      case TargetStatus.onTrack:
        return const Color(0xFF2196F3); // Blue
      case TargetStatus.veryFarAway:
        return const Color(0xFFFF6B6B); // Red
    }
  }

  IconData _getStatusIcon(TargetStatus status) {
    switch (status) {
      case TargetStatus.achieved:
        return Iconsax.tick_circle;
      case TargetStatus.closeToTarget:
        return Iconsax.warning_2;
      case TargetStatus.onTrack:
        return Iconsax.arrow_up;
      case TargetStatus.veryFarAway:
        return Iconsax.arrow_down_1;
    }
  }

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTargets = ref.watch(allTargetsProvider);
    final target = ref.watch(selectedMonthTargetProvider);
    final selectedMonthIndex = ref.watch(selectedMonthIndexProvider);
    final statusInfo = ref.watch(targetStatusProvider);
    final percentage = ref.watch(targetPercentageProvider);

    if (target == null || allTargets.isEmpty) {
      return const SizedBox.shrink();
    }

    final statusColor = _getStatusColor(statusInfo.status);
    final statusIcon = _getStatusIcon(statusInfo.status);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
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
            // Header with month selector
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Target',
                        style: AppTypography.tagline.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Month selector dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: DropdownButton<int>(
                          value: selectedMonthIndex,
                          onChanged: (newIndex) {
                            if (newIndex != null) {
                              ref
                                  .read(targetNotifierProvider.notifier)
                                  .selectMonth(newIndex);
                            }
                          },
                          isDense: true,
                          isExpanded: false,
                          underline: const SizedBox.shrink(),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          iconEnabledColor: AppColors.primary,
                          items: List.generate(
                            allTargets.length,
                            (index) => DropdownMenuItem<int>(
                              value: index,
                              child: Text('${allTargets[index].month} ${allTargets[index].year}'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Status message
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusInfo.label,
                    style: AppTypography.body.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    statusInfo.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: statusColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: AppTypography.body.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  child: LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Target breakdown
            Row(
              children: [
                Expanded(
                  child: _buildTargetMetric(
                    title: 'Target',
                    amount: target.targetAmount,
                    icon: Iconsax.flag,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildTargetMetric(
                    title: 'Achieved',
                    amount: target.achievedAmount,
                    icon: Iconsax.tick_square,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildTargetMetric(
                    title: 'Left',
                    amount: target.remainingAmount,
                    icon: Iconsax.clipboard,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetMetric({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _formatCurrency(amount),
            style: AppTypography.body.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
