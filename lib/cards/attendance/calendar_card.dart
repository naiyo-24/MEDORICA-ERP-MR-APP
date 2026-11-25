import 'package:flutter/material.dart';
import '../../models/attendance.dart';
import '../../theme/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final List<Attendance> records;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarCard({
    super.key,
    required this.records,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Map<DateTime, Attendance> attendanceMap = {
      for (final record in records)
        DateTime(record.date.year, record.date.month, record.date.day): record,
    };

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Calendar',
            style: AppTypography.h3.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          TableCalendar(
            firstDay: DateTime(DateTime.now().year - 1, 1, 1),
            lastDay: DateTime(DateTime.now().year + 1, 12, 31),
            focusedDay: selectedDate ?? DateTime.now(),
            selectedDayPredicate: (day) =>
                selectedDate != null &&
                day.year == selectedDate!.year &&
                day.month == selectedDate!.month &&
                day.day == selectedDate!.day,
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selected, focused) {
              onDateSelected(selected);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final record =
                    attendanceMap[DateTime(date.year, date.month, date.day)];
                if (record == null) return null;
                final isPresent = record.status.toLowerCase() == 'present';
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.circle,
                    size: 8,
                    color: isPresent ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppTypography.h3.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
              ),
              weekendStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.error,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: AppTypography.body.copyWith(
                color: Colors.white,
              ),
              todayTextStyle: AppTypography.body.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
