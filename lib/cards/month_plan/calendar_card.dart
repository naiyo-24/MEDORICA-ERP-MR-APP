import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../provider/month_plan_provider.dart';

class CalendarCard extends ConsumerWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayedMonth = ref.watch(displayedMonthProvider);
    final datesWithPlans = ref.watch(datesWithPlansProvider(displayedMonth));
    final selectedDate = ref.watch(selectedDateProvider);
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
          children: [
            // Month header with navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Iconsax.arrow_circle_left),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: () {
                    final newMonth = DateTime(
                      displayedMonth.year,
                      displayedMonth.month - 1,
                    );
                    ref.read(displayedMonthProvider.notifier).state = newMonth;
                    ref.read(selectedDateProvider.notifier).state = null;
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(displayedMonth),
                  style: AppTypography.h3.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.arrow_circle_right),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: () {
                    final newMonth = DateTime(
                      displayedMonth.year,
                      displayedMonth.month + 1,
                    );
                    ref.read(displayedMonthProvider.notifier).state = newMonth;
                    ref.read(selectedDateProvider.notifier).state = null;
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Calendar grid
            _buildCalendarGrid(
              context,
              ref,
              displayedMonth,
              datesWithPlans,
              selectedDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    WidgetRef ref,
    DateTime displayedMonth,
    List<DateTime> datesWithPlans,
    DateTime? selectedDate,
  ) {
    final firstDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final rows = <Widget>[];
    var dayCounter = 1;

    for (var week = 0; week < 6; week++) {
      if (dayCounter > daysInMonth) break;

      final weekDays = <Widget>[];
      for (var weekday = 0; weekday < 7; weekday++) {
        if (week == 0 && weekday < firstWeekday) {
          // Empty cell before month starts
          weekDays.add(const Expanded(child: SizedBox()));
        } else if (dayCounter <= daysInMonth) {
          final date = DateTime(
            displayedMonth.year,
            displayedMonth.month,
            dayCounter,
          );
          final hasPlan = datesWithPlans.any(
            (d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day,
          );
          final isSelected =
              selectedDate != null &&
              selectedDate.year == date.year &&
              selectedDate.month == date.month &&
              selectedDate.day == date.day;
          final isToday =
              DateTime.now().year == date.year &&
              DateTime.now().month == date.month &&
              DateTime.now().day == date.day;

          weekDays.add(
            Expanded(
              child: _buildDayCell(
                context,
                ref,
                date,
                dayCounter,
                hasPlan,
                isSelected,
                isToday,
              ),
            ),
          );
          dayCounter++;
        } else {
          // Empty cell after month ends
          weekDays.add(const Expanded(child: SizedBox()));
        }
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays,
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    int day,
    bool hasPlan,
    bool isSelected,
    bool isToday,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: hasPlan
          ? () {
              ref.read(selectedDateProvider.notifier).state = date;
            }
          : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : isToday
              ? (isDarkMode ? AppColors.darkSurface300 : AppColors.primaryLight)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(
            color: isToday && !isSelected
                ? AppColors.primary
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  day.toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : hasPlan
                        ? (isDarkMode
                              ? AppColors.darkText
                              : colorScheme.primary)
                        : colorScheme.onSurfaceVariant,
                    fontWeight: hasPlan ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ),
              if (hasPlan)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.white : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
