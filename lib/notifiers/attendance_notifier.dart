import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';

class AttendanceNotifier extends StateNotifier<Attendance?> {
  AttendanceNotifier() : super(null);

  void checkIn({required String photoPath}) {
    final now = DateTime.now();
    state = Attendance(
      date: DateTime(now.year, now.month, now.day),
      checkIn: now,
      checkInPhotoPath: photoPath,
    );
  }

  void checkOut({required String photoPath}) {
    if (state == null) return;
    state = Attendance(
      date: state!.date,
      checkIn: state!.checkIn,
      checkOut: DateTime.now(),
      checkInPhotoPath: state!.checkInPhotoPath,
      checkOutPhotoPath: photoPath,
    );
  }
}

final attendanceNotifierProvider = StateNotifierProvider<AttendanceNotifier, Attendance?>((ref) {
  return AttendanceNotifier();
});