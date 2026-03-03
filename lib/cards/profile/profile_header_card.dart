import 'package:flutter/material.dart';
import '../../models/mr.dart';
import '../../theme/app_theme.dart';

class ProfileHeaderCard extends StatelessWidget {
  final MedicalRepresentative profile;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: profile.profileImage != null
                ? ClipOval(
                    child: Image.asset(
                      profile.profileImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Name
          Text(
            profile.name,
            style: AppTypography.h3.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Designation
          Text(
            profile.designation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.quaternary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),

          // Phone and Email
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Phone
              Column(
                children: [
                  const Icon(Icons.phone, color: AppColors.primary, size: 24),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    profile.phone,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.quaternary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              // Divider
              Container(
                width: 1,
                height: 50,
                color: AppColors.border,
              ),
              // Territory
              Column(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary, size: 24),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    profile.territory,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.quaternary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
