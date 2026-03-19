import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mr_app/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/team_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import 'team_member_details_screen.dart';

class MyTeamScreen extends ConsumerStatefulWidget {
  final String mrId;
  const MyTeamScreen({required this.mrId, super.key});

  @override
  ConsumerState<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends ConsumerState<MyTeamScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(teamNotifierProvider.notifier).fetchTeamsByMrId(widget.mrId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamNotifierProvider);

    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'My Team',
        subtitleText: 'View your team details',
        onBack: () => context.pop(),
      ),
      body: teamState.when(
        loading: () => const TransparentLoader(subtext: 'Loading team...'),
        error: (e, _) => Center(child: Text('Server down. Please try again later.')),
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(child: Text('No team found'));
          }
          final team = teams.first;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    elevation: 6,
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(team.teamName, style: AppTypography.h2.copyWith(color: AppColors.primary)),
                          if (team.teamDescription != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              child: Text(
                                team.teamDescription!,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                              ),
                            ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              if (team.whatsappGroupLink != null)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                      ),
                                      elevation: 2,
                                    ),
                                    icon: Icon(FontAwesomeIcons.whatsapp, size: 18),
                                    label: const Text('Join WhatsApp Group'),
                                    onPressed: () async {
                                      final url = Uri.parse(team.whatsappGroupLink!);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      }
                                    },
                                  ),
                                ),
                              if (team.whatsappGroupLink != null)
                                const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text('View Team Members'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TeamMemberDetailsScreen(members: team.teamMembers),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
