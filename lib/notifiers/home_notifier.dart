import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';

class HomeNotifier extends StateNotifier<List<Attendance>> {
  HomeNotifier() : super([]);

  void addAttendance(Attendance a) {
    state = [...state, a];
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, List<Attendance>>((ref) {
  return HomeNotifier();
});