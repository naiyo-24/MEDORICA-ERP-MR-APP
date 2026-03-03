import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class MRAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final bool showActions;
  final String? titleText;
  final String? subtitleText;
    final VoidCallback? onBack;

    const MRAppBar({super.key, this.showBack = false, this.showActions = true, this.titleText, this.subtitleText, this.onBack});

  
  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Iconsax.arrow_circle_left, color: AppColors.primary),
              onPressed: onBack ?? () => GoRouter.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          if (titleText == null) Image.asset('assets/logo/logo.png', width: 80, height: 100),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText ?? 'Medorica Pharma',
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
              Text(
                subtitleText ?? 'Your Daily Dose of Healing',
                style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary),
              ),
            ],
          ),
        ],
      ),
      actions: showActions ? [
        IconButton(
          icon: const Icon(Iconsax.notification, color: AppColors.primary),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Iconsax.user, color: AppColors.primary),
            ),
          ),
        ),
      ] : null,
    );
  }
}