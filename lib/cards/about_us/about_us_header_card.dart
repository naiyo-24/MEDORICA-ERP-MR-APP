import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutUsHeaderCard extends StatelessWidget {
  final String companyName;

  const AboutUsHeaderCard({
    super.key,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(76),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          // Logo
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/logo/logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Company Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              companyName,
              style: AppTypography.h2.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Your Daily Dose of Healing',
              style: AppTypography.body.copyWith(
                color: AppColors.white.withAlpha(229),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
