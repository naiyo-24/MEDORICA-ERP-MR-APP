import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(child: Text('No team found'));
          }
          final team = teams.first;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(team.teamName, style: AppTypography.h2),
                if (team.whatsappGroupLink != null)
                  ElevatedButton.icon(
                    icon: Icon(FontAwesomeIcons.whatsapp),
                    label: const Text('Join WhatsApp Group'),
                    onPressed: () async {
                      final url = Uri.parse(team.whatsappGroupLink!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                if (team.teamDescription != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Text(team.teamDescription!),
                  ),
                ElevatedButton(
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
              ],
            ),
          );
        },
      ),
    );
  }
}
