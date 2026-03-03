import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/home_notifier.dart';
import '../models/target.dart';

final homeProvider = Provider((ref) {
  return ref.watch(homeNotifierProvider);
});

// Provider to watch all targets
final allTargetsProvider = Provider<List<Target>>((ref) {
  final targetData = ref.watch(targetNotifierProvider);
  return targetData.targets;
});

// Provider to get selected month target
final selectedMonthTargetProvider = Provider<Target?>((ref) {
  final targetData = ref.watch(targetNotifierProvider);
  final targets = targetData.targets;
  final selectedIndex = targetData.selectedMonthIndex;

  if (selectedIndex >= 0 && selectedIndex < targets.length) {
    return targets[selectedIndex];
  }
  return null;
});

// Provider to get target percentage
final targetPercentageProvider = Provider<double>((ref) {
  final target = ref.watch(selectedMonthTargetProvider);
  return target?.percentageAchieved ?? 0;
});

// Provider to get target status with color
final targetStatusProvider = Provider<({TargetStatus status, String label, String description})>((ref) {
  final target = ref.watch(selectedMonthTargetProvider);
  if (target == null) {
    return (status: TargetStatus.veryFarAway, label: 'No Data', description: '');
  }

  switch (target.status) {
    case TargetStatus.achieved:
      return (
        status: TargetStatus.achieved,
        label: 'Target Achieved! 🎉',
        description: 'You have exceeded your monthly target'
      );
    case TargetStatus.closeToTarget:
      return (
        status: TargetStatus.closeToTarget,
        label: 'Close to Target',
        description: 'Keep pushing to reach your goal'
      );
    case TargetStatus.onTrack:
      return (
        status: TargetStatus.onTrack,
        label: 'On Track',
        description: 'Good progress towards target'
      );
    case TargetStatus.veryFarAway:
      return (
        status: TargetStatus.veryFarAway,
        label: 'Far from Target',
        description: 'Need to increase sales efforts'
      );
  }
});

// Provider to get current selected month index
final selectedMonthIndexProvider = Provider<int>((ref) {
  return ref.watch(targetNotifierProvider).selectedMonthIndex;
});
