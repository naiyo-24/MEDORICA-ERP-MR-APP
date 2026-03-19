import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
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
          return InkWell(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withAlpha(8),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile photo and name
                        Row(
                          children: [
                            photoUrl != null
                                ? CircleAvatar(
                                    radius: 36,
                                    backgroundImage: NetworkImage(photoUrl),
                                    backgroundColor: AppColors.primaryLight,
                                  )
                                : CircleAvatar(
                                    radius: 36,
                                    backgroundColor: AppColors.primaryLight,
                                    child: Icon(Iconsax.user, color: AppColors.primary, size: 36),
                                  ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.fullName,
                                    style: AppTypography.h2.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    m.phoneNo,
                                    style: AppTypography.body.copyWith(color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.call, color: AppColors.primary, size: 24),
                              onPressed: () async {
                                final url = Uri.parse('tel:${m.phoneNo}');
                                await launchUrl(url);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Action buttons (fix infinite width)
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          alignment: WrapAlignment.center,
                          children: [
                            if (m.email != null)
                              SizedBox(
                                width: 120,
                                child: ElevatedButton.icon(
                                  style: AppButtonStyles.secondaryButton(),
                                  icon: const Icon(Iconsax.sms, color: AppColors.primary),
                                  label: Text('Mail', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                                  onPressed: () async {
                                    final url = Uri.parse('mailto:${m.email}');
                                    await launchUrl(url);
                                  },
                                ),
                              ),
                            if (m.address != null)
                              SizedBox(
                                width: 120,
                                child: ElevatedButton.icon(
                                  style: AppButtonStyles.secondaryButton(),
                                  icon: const Icon(Iconsax.location, color: AppColors.primary),
                                  label: Text('Map', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                                  onPressed: () async {
                                    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(m.address!)}');
                                    await launchUrl(url);
                                  },
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Details
                        if (m.altPhoneNo != null)
                          Row(
                            children: [
                              Icon(Iconsax.call_add, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(m.altPhoneNo!, style: AppTypography.bodySmall),
                              IconButton(
                                icon: const Icon(Iconsax.call_add, color: AppColors.primary),
                                onPressed: () async {
                                  final url = Uri.parse('tel:${m.altPhoneNo}');
                                  await launchUrl(url);
                                },
                              ),
                            ],
                          ),
                        if (m.headquarterAssigned != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(Iconsax.location, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(m.headquarterAssigned!, style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        if (m.territoriesOfWork != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (m.address != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  );
                },
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              elevation: 2,
              color: AppColors.white,
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
                vertical: AppSpacing.sm,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    photoUrl != null
                        ? CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(photoUrl),
                            backgroundColor: AppColors.primaryLight,
                          )
                        : CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Iconsax.user, color: AppColors.primary, size: 32),
                          ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.fullName,
                            style: AppTypography.h3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Iconsax.call, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(m.phoneNo, style: AppTypography.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
