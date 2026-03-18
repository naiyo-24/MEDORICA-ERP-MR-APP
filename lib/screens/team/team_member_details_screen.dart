import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/team.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class TeamMemberDetailsScreen extends StatelessWidget {
  final List<TeamMember> members;
  const TeamMemberDetailsScreen({required this.members, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Team Members',
        subtitleText: 'Know your team better',
        onBack: () => context.pop(),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          final String? photoUrl = m.profilePhoto != null
              ? ApiUrl.getFullUrl(m.profilePhoto!)
              : null;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            elevation: 4,
            color: AppColors.white,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppBorderRadius.lg),
                    topRight: Radius.circular(AppBorderRadius.lg),
                  ),
                  child: photoUrl != null
                      ? Image.network(
                          photoUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 180,
                          color: AppColors.primaryLight,
                          child: Center(
                            child: Icon(Iconsax.user, color: AppColors.primary, size: 64),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        m.fullName,
                        style: AppTypography.h2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withAlpha(120),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.call, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(m.phoneNo, style: AppTypography.bodySmall),
                              ],
                            ),
                            if (m.altPhoneNo != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.call_add, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(m.altPhoneNo!, style: AppTypography.bodySmall),
                                  ],
                                ),
                              ),
                            if (m.email != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.sms, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(m.email!, style: AppTypography.bodySmall),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Divider(color: AppColors.primary.withAlpha(120)),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withAlpha(120),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          children: [
                            if (m.headquarterAssigned != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.location, size: 18, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(m.headquarterAssigned!, style: AppTypography.bodySmall),
                                ],
                              ),
                            if (m.territoriesOfWork != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Iconsax.map, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        m.territoriesOfWork!.join(", "),
                                        style: AppTypography.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (m.address != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Iconsax.home, size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        m.address!,
                                        style: AppTypography.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
