import 'package:flutter/material.dart';
import '../../models/mr.dart';
import '../../theme/app_theme.dart';

class ProfileHeaderCard extends StatelessWidget {
  final MedicalRepresentative profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
  color: colorScheme.surface,
  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
  border: Border.all(color: colorScheme.outlineVariant),
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
            child:
                (profile.profileImage != null &&
                    profile.profileImage!.trim().isNotEmpty)
                ? ClipOval(child: _buildProfileImage(profile.profileImage!))
                : const Icon(Icons.person, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Name
          Text(
            profile.name,
            style: AppTypography.h3.copyWith(
  color: colorScheme.onSurface,
),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Designation
          Text(
            profile.designation,
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          Divider(height: 1, color: colorScheme.onSurface),
          const SizedBox(height: AppSpacing.lg),

          // MR ID and Territories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // MR ID
              Column(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    profile.mrId,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurface,
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

  Widget _buildProfileImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 50, color: AppColors.primary);
        },
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 50, color: AppColors.primary);
        },
      );
    }

    return const Icon(Icons.person, size: 50, color: AppColors.primary);
  }

}
