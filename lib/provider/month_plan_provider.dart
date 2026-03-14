import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/month_plan.dart';
import '../notifiers/month_plan_notifier.dart';
import '../services/month_plan/month_plan_services.dart';

final monthPlanServicesProvider = Provider<MonthPlanServices>((ref) {
  return MonthPlanServices();
});

// Provider for the list of month plans
final monthPlanProvider =
    StateNotifierProvider<MonthPlanNotifier, List<MonthPlan>>((ref) {
      return MonthPlanNotifier(ref.read(monthPlanServicesProvider), ref.read);
    });

final monthPlanLoadingProvider = Provider<bool>((ref) {
  return ref.read(monthPlanProvider.notifier).isLoading;
});

final monthPlanErrorProvider = Provider<String?>((ref) {
  return ref.read(monthPlanProvider.notifier).error;
});

// Provider for a plan by date
final monthPlanByDateProvider = Provider.family<MonthPlan?, DateTime>((
  ref,
  date,
) {
  final plans = ref.watch(monthPlanProvider);
  try {
    return plans.firstWhere(
      (plan) =>
          plan.date.year == date.year &&
          plan.date.month == date.month &&
          plan.date.day == date.day,
    );
  } catch (e) {
    return null;
  }
});

// Provider for plans in a specific month
final monthPlansForMonthProvider = Provider.family<List<MonthPlan>, DateTime>((
  ref,
  month,
) {
  final plans = ref.watch(monthPlanProvider);
  return plans
      .where(
        (plan) =>
            plan.date.year == month.year && plan.date.month == month.month,
      )
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});

// Provider for dates with plans in a specific month
final datesWithPlansProvider = Provider.family<List<DateTime>, DateTime>((
  ref,
  month,
) {
  final plans = ref.watch(monthPlansForMonthProvider(month));
  return plans.map((plan) => plan.date).toList();
});

// Provider for current selected date (for calendar interaction)
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

// Provider for current displayed month
final displayedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});
