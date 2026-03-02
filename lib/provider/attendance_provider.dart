import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';
import '../notifiers/attendance_notifier.dart';

final todaysAttendanceProvider = Provider.autoDispose<Attendance?>((ref) {
  return ref.watch(attendanceNotifierProvider);
});