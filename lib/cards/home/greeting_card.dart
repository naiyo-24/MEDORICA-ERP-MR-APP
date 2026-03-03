import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';

class MRGreetingCard extends ConsumerWidget {
  const MRGreetingCard({super.key});

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning,';
    if (hour >= 12 && hour < 17) return 'Good afternoon,';
    if (hour >= 17 && hour < 21) return 'Good evening,';
    return 'Good night,';
  }

  IconData _greetingIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 17) return Iconsax.sun_1;
    return Iconsax.moon;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _timeBasedGreeting();
    final roleLabel = 'Medical Representative'; // This can be dynamic based on user role in a real app

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(_greetingIcon(), color: AppColors.secondary, size: AppSpacing.xxxl),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.tagline.copyWith(color: AppColors.quaternary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(roleLabel, style: AppTypography.h3.copyWith(color: AppColors.primary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Serving healthcare, one visit at a time.',
                    style: AppTypography.body.copyWith(color: AppColors.quaternary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Keep pushing — every call makes a difference.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}