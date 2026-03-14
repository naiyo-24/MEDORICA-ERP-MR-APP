import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

import '../provider/auth_provider.dart';
import '../models/month_plan.dart';
import '../services/month_plan/month_plan_services.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);

class MonthPlanNotifier extends StateNotifier<List<MonthPlan>> {
  MonthPlanNotifier(this._monthPlanServices, this._read) : super([]);

  final MonthPlanServices _monthPlanServices;
  final Reader _read;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentMrMonthPlans() async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      _error = 'No logged in MR found';
      state = [];
      return;
    }

    await loadMonthPlansByMrId(mrId);
  }

  Future<void> loadMonthPlansByMrId(String mrId) async {
    _isLoading = true;
    _error = null;

    try {
      final List<MonthPlan> plans = await _monthPlanServices
          .fetchMonthPlansByMrId(mrId);
      state = plans;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      state = [];
    } finally {
      _isLoading = false;
    }
  }

  // Add a new plan
  void addPlan(MonthPlan plan) {
    state = [...state, plan.copyWith(id: DateTime.now().toString())];
  }

  // Update a plan
  void updatePlan(MonthPlan updatedPlan) {
    state = [
      for (final plan in state)
        if (plan.id == updatedPlan.id) updatedPlan else plan,
    ];
  }

  // Delete a plan
  void deletePlan(String id) {
    state = [
      for (final plan in state)
        if (plan.id != id) plan,
    ];
  }

  // Get plan by date
  MonthPlan? getPlanByDate(DateTime date) {
    try {
      return state.firstWhere(
        (plan) =>
            plan.date.year == date.year &&
            plan.date.month == date.month &&
            plan.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  // Get plans for a specific month
  List<MonthPlan> getPlansForMonth(DateTime month) {
    return state
        .where(
          (plan) =>
              plan.date.year == month.year && plan.date.month == month.month,
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get all dates that have plans in a specific month
  List<DateTime> getDatesWithPlans(DateTime month) {
    return getPlansForMonth(month).map((plan) => plan.date).toList();
  }

  // Toggle activity completion
  void toggleActivityCompletion(String planId, String activityId) {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          plan.copyWith(
            activities: [
              for (final activity in plan.activities)
                if (activity.id == activityId)
                  activity.copyWith(isCompleted: !activity.isCompleted)
                else
                  activity,
            ],
          )
        else
          plan,
    ];
  }

  // Add activity to plan
  void addActivityToPlan(String planId, PlanActivity activity) {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          plan.copyWith(activities: [...plan.activities, activity])
        else
          plan,
    ];
  }

  // Remove activity from plan
  void removeActivityFromPlan(String planId, String activityId) {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          plan.copyWith(
            activities: plan.activities
                .where((a) => a.id != activityId)
                .toList(),
          )
        else
          plan,
    ];
  }
}
