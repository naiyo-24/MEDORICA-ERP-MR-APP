import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class ProfileOptionsCard extends StatelessWidget {
  final VoidCallback onUpdateProfile;
  final VoidCallback onAboutUs;
  final VoidCallback onContactSupport;
  final VoidCallback onNotifications;

  const ProfileOptionsCard({
    super.key,
    required this.onUpdateProfile,
    required this.onAboutUs,
    required this.onContactSupport,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildOption(
            icon: Iconsax.user_edit,
            title: 'Update Profile',
            subtitle: 'Modify your profile information',
            onTap: onUpdateProfile,
            isFirst: true,
          ),
          _buildDivider(),
          _buildOption(
            icon: Iconsax.information,
            title: 'About Us',
            subtitle: 'Learn about Medorica Pharma',
            onTap: onAboutUs,
          ),
          _buildDivider(),
          _buildOption(
            icon: Iconsax.headphone,
            title: 'Contact Support',
            subtitle: 'Get help and support',
            onTap: onContactSupport,
          ),
          _buildDivider(),
          _buildOption(
            icon: Iconsax.notification,
            title: 'Notifications',
            subtitle: 'Manage notification settings',
            onTap: onNotifications,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(AppBorderRadius.lg) : Radius.zero,
          topRight: isFirst ? Radius.circular(AppBorderRadius.lg) : Radius.zero,
          bottomLeft: isLast ? Radius.circular(AppBorderRadius.lg) : Radius.zero,
          bottomRight: isLast ? Radius.circular(AppBorderRadius.lg) : Radius.zero,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Iconsax.arrow_right, color: AppColors.quaternary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Divider(
        height: 1,
        color: AppColors.border,
      ),
    );
  }
}
