import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/month_plan/calendar_card.dart';
import '../../cards/month_plan/plan_card.dart';
import '../../theme/app_theme.dart';
import '../../provider/month_plan_provider.dart';

class MonthPlanScreen extends ConsumerStatefulWidget {
  const MonthPlanScreen({super.key});

  @override
  ConsumerState<MonthPlanScreen> createState() => _MonthPlanScreenState();
}

class _MonthPlanScreenState extends ConsumerState<MonthPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(monthPlanProvider.notifier).loadCurrentMrMonthPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final plans = ref.watch(monthPlanProvider);
    final isLoading = ref.watch(monthPlanLoadingProvider);
    final error = ref.watch(monthPlanErrorProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Monthly Planning',
        subtitleText: 'Organize your visits and tasks',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLoading && plans.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),

            if (error != null && plans.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    border: Border.all(color: AppColors.error.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          error,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(monthPlanProvider.notifier)
                              .loadCurrentMrMonthPlans();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),

            // Calendar Card
            const CalendarCard(),

            // Plan Card (shown when a date is selected)
            if (selectedDate != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PlanCard(date: selectedDate),
            ],

            // Instruction text when no date is selected
            if (selectedDate == null) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      size: 48,
                      color: AppColors.quaternary.withAlpha(150),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Select a date with a dot',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap on any date marked with a dot to view your planned activities for that day',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
