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
  final List<Widget>? actions;

  const MRAppBar({
    super.key,
    this.showBack = false,
    this.showActions = true,
    this.titleText,
    this.subtitleText,
    this.onBack,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      titleSpacing: titleText == null ? 0 : 16,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Iconsax.arrow_circle_left,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: onBack ?? () => GoRouter.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          if (titleText == null)
            Image.asset('assets/logo/logo.png', width: 80, height: 100),
          const SizedBox(width: 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText ?? 'Medorica Pharma',
                style: AppTypography.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                subtitleText ?? 'Your Daily Dose of Healing',
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (showActions) ...[
          IconButton(
            icon: Icon(
              Iconsax.notification,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.push('/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => context.push('/profile'),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(Iconsax.user, color: Theme.of(context).colorScheme.onSurface,),
              ),
            ),
          ),
        ],
        ...?actions,
      ],
    );
  }
}
