import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';
import '../../provider/home_provider.dart';
import '../../notifiers/home_notifier.dart';

class MonthlyTargetCard extends ConsumerWidget {
  const MonthlyTargetCard({super.key});

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _currency(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(homeSelectedMonthProvider);
    final monthlyTarget = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeNotifierProvider.notifier);

    final currentYear = DateTime.now().year;
    final years = List<int>.generate(7, (index) => currentYear - 3 + index);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -34,
            right: -28,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(22),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            left: -16,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.wallet_2, color: AppColors.white),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Monthly Target',
                      style: AppTypography.tagline.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _selectorContainer(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedMonth.month,
                            dropdownColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSurface
                                : AppColors.white,
                            icon: const Icon(
                              Iconsax.arrow_down_1,
                              color: AppColors.white,
                              size: 18,
                            ),
                            style: AppTypography.body.copyWith(
                              color: AppColors.white,
                            ),
                            items: List.generate(12, (index) {
                              final monthNumber = index + 1;
                              return DropdownMenuItem<int>(
                                value: monthNumber,
                                child: Text(
                                  _months[index],
                                  style: AppTypography.body.copyWith(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.darkText
                                        : AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                            selectedItemBuilder: (context) {
                              return List.generate(12, (index) {
                                return Text(
                                  _months[index],
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              });
                            },
                            onChanged: (month) {
                              if (month == null) return;
                              homeNotifier.setSelectedMonthYear(
                                year: selectedMonth.year,
                                month: month,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _selectorContainer(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedMonth.year,
                            dropdownColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSurface
                                : AppColors.white,
                            icon: const Icon(
                              Iconsax.arrow_down_1,
                              color: AppColors.white,
                              size: 18,
                            ),
                            style: AppTypography.body.copyWith(
                              color: AppColors.white,
                            ),
                            items: years.map((year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(
                                  year.toString(),
                                  style: AppTypography.body.copyWith(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.darkText
                                        : AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            selectedItemBuilder: (context) {
                              return years.map((year) {
                                return Text(
                                  year.toString(),
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }).toList();
                            },
                            onChanged: (year) {
                              if (year == null) return;
                              homeNotifier.setSelectedMonthYear(
                                year: year,
                                month: selectedMonth.month,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _amountTile(
                  title: 'Target Amount',
                  value: _currency(monthlyTarget.targetAmount),
                ),
                const SizedBox(height: AppSpacing.sm),
                _amountTile(
                  title: 'Target Achieved',
                  value: _currency(monthlyTarget.achievedAmount),
                ),
                const SizedBox(height: AppSpacing.sm),
                _amountTile(
                  title: 'Yet to Achieve',
                  value: _currency(monthlyTarget.remainingAmount),
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: AppBorderRadius.maxRadius,
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: monthlyTarget.achievedPercentage,
                    backgroundColor: AppColors.white.withAlpha(45),
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(32),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.white.withAlpha(68)),
      ),
      child: child,
    );
  }

  Widget _amountTile({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.white.withAlpha(220),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
