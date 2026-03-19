import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mr_app/widgets/loader.dart';
import '../../models/attendance.dart';
import '../../provider/attendance_provider.dart';
import '../../cards/attendance/calendar_card.dart';
import '../../cards/attendance/report_card.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    // Removed unused variables: records, todayAttendance
    final selectedMonthRecords = ref.watch(selectedMonthAttendancesProvider);
    Attendance? selectedAttendance;
    if (_selectedDate != null) {
      try {
        selectedAttendance = selectedMonthRecords.firstWhere(
          (record) => record.date.year == _selectedDate!.year &&
              record.date.month == _selectedDate!.month &&
              record.date.day == _selectedDate!.day,
        );
      } catch (_) {
        selectedAttendance = null;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Attendance',
        subtitleText: 'View your attendance records',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: selectedMonthRecords.isEmpty
        ? const TransparentLoader(subtext: 'Loading attendance...')
        : Column(
            children: [
              CalendarCard(
                records: selectedMonthRecords,
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              if (_selectedDate != null && selectedAttendance != null)
                ReportCard(attendance: selectedAttendance),
            ],
          ),
    );
  }
}
