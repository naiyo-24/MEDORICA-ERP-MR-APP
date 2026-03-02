import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../cards/home/attendance_card.dart';
import '../../cards/home/greeting_card.dart';
import '../../cards/home/home_footer.dart';
import '../../cards/home/quick_actions_card.dart';
import '../../widgets/ads_carousels.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MRAppBar(showBack: false),
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const MRBottomNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              SizedBox(height: AppSpacing.lg),
              MRGreetingCard(),
              SizedBox(height: AppSpacing.md),
              MRAttendanceCard(),
              SizedBox(height: AppSpacing.md),
              MRQuickActionsCard(),
              SizedBox(height: AppSpacing.md),
              AdsCarousel(height: 500),
              SizedBox(height: AppSpacing.xl),
              HomeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}