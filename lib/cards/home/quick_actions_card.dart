import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';

class MRQuickActionsCard extends ConsumerWidget {
  const MRQuickActionsCard({super.key});

  Widget _actionTile(BuildContext context, WidgetRef ref, IconData icon, String label) {
    return InkWell(
      onTap: () {
        _handleAction(context, ref, label);
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
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

  void _handleAction(BuildContext context, WidgetRef ref, String label) {
    switch (label) {
      case 'Month Plan':
        context.push('/month-plan');
        break;
      case 'Gifts':
        context.push('/gifts');
        break;
      case 'Add Doctors':
        context.push('/mr/doctor/add');
        break;
      case 'Visual Ads':
        context.push('/visual-ads');
        break;
      case 'My Team':
        final mr = ref.read(profileProvider);
        final mrId = mr?.mrId ?? '';
        context.push('/mr/team?mrId=$mrId');
        break;
      case 'Chemists':
        context.push('/mr/chemist');
        break;
      case 'Attendance':
        context.push('/attendance');
        break;
      default:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$label tapped')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      [Iconsax.route_square, 'Month Plan'],
      [FontAwesomeIcons.gifts, 'Gifts'],
      [FontAwesomeIcons.userDoctor, 'Add Doctors'],
      [FontAwesomeIcons.image, 'Visual Ads'],
      [Iconsax.truck, 'My Team'],
      [Iconsax.wallet, 'Salary Slip'],
      [Iconsax.shop, 'Chemists'],
      [Iconsax.calendar, 'Attendance'],
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
              children: items.map((it) => _actionTile(context, ref, it[0] as IconData, it[1] as String)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
       