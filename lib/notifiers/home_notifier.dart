import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../models/target.dart';

class HomeNotifier extends StateNotifier<List<Attendance>> {
  HomeNotifier() : super([]);

  void addAttendance(Attendance a) {
    state = [...state, a];
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, List<Attendance>>((ref) {
  return HomeNotifier();
});

// Target notifier for monthly target state management
class TargetNotifier extends StateNotifier<({List<Target> targets, int selectedMonthIndex})> {
  TargetNotifier()
      : super((targets: [], selectedMonthIndex: 0)) {
    _loadTargets();
  }

  void _loadTargets() {
    // Generate sample targets for current and surrounding months
    final now = DateTime.now();
    final targets = <Target>[];
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    // Generate targets for previous 3 months, current month, and next 3 months
    for (int i = -3; i <= 3; i++) {
      final date = DateTime(now.year, now.month + i);
      final month = date.month;
      final year = date.year;

      // Generate different target amounts based on month
      double targetAmount = 500000.0;
      double achievedAmount;

      if (i < 0) {
        // Previous months - mostly achieved
        achievedAmount = targetAmount * (0.85 + (i * 0.05));
      } else if (i == 0) {
        // Current month
        achievedAmount = 350000.0;
      } else {
        // Future months - no achievement yet
        achievedAmount = 0.0;
      }

      targets.add(
        Target(
          id: '$year$month',
          month: monthNames[month - 1],
          year: year,
          targetAmount: targetAmount,
          achievedAmount: achievedAmount,
          createdAt: DateTime(year, month, 1),
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Set current month as selected (index 3 in the generated list)
    state = (targets: targets, selectedMonthIndex: 3);
  }

  void selectMonth(int index) {
    if (index >= 0 && index < state.targets.length) {
      state = (targets: state.targets, selectedMonthIndex: index);
    }
  }

  void updateTarget(double achievedAmount) {
    final targets = state.targets;
    final selectedIndex = state.selectedMonthIndex;

    if (selectedIndex >= 0 && selectedIndex < targets.length) {
      final updatedTarget = targets[selectedIndex].copyWith(
        achievedAmount: achievedAmount,
        updatedAt: DateTime.now(),
      );

      final newTargets = [...targets];
      newTargets[selectedIndex] = updatedTarget;

      state = (targets: newTargets, selectedMonthIndex: selectedIndex);
    }
  }

  void setTarget(Target target) {
    // Find and update target in list or add new one
    final targets = state.targets;
    final index = targets.indexWhere((t) =>
        t.month == target.month && t.year == target.year);

    if (index >= 0) {
      final newTargets = [...targets];
      newTargets[index] = target;
      state = (targets: newTargets, selectedMonthIndex: state.selectedMonthIndex);
    } else {
      state = (targets: [...targets, target], selectedMonthIndex: state.selectedMonthIndex);
    }
  }

  void refresh() {
    _loadTargets();
  }
}

final targetNotifierProvider =
    StateNotifierProvider<TargetNotifier, ({List<Target> targets, int selectedMonthIndex})>((ref) {
  return TargetNotifier();
});
