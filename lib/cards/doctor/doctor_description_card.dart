import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class DoctorDescriptionCard extends StatelessWidget {
  final String description;

  const DoctorDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTypography.body.copyWith(
              color: AppColors.quaternary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
