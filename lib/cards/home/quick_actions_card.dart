import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../theme/app_theme.dart';

class MRQuickActionsCard extends StatelessWidget {
  const MRQuickActionsCard({super.key});

  Widget _actionTile(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label tapped')));
      },
      borderRadius: AppBorderRadius.lgRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: AppCardStyles.minimalCard(backgroundColor: AppColors.primaryLight),
            child: Center(child: Icon(icon, color: AppColors.primary, size: 20)),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      [Iconsax.chart, 'Analytics'],
      [Iconsax.shopping_cart, 'My Orders'],
      [FontAwesomeIcons.userDoctor, 'My Doctors'],
      [Iconsax.calendar_tick, 'Appointments'],
      [Iconsax.truck, 'Distributors'],
      [Iconsax.wallet, 'Salary Slip'],
      [Iconsax.shop, 'Chemists'],
      [Iconsax.user, 'Profile'],
    ];

    return Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.lgRadius),
        elevation: AppElevation.xs,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Quick Actions', style: AppTypography.h3.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                children: items.map((it) => _actionTile(context, it[0] as IconData, it[1] as String)).toList(),
              ),
            ],
          ),
        ),
    );
  }
}