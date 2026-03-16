import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/team.dart';
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
          return Card(
            margin: const EdgeInsets.all(AppSpacing.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: m.profilePhoto != null ? NetworkImage(m.profilePhoto!) : null,
                    radius: 32,
                    child: m.profilePhoto == null ? const Icon(Icons.person) : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.fullName, style: AppTypography.h3),
                        Text('Phone: ${m.phoneNo}'),
                        if (m.altPhoneNo != null) Text('Alt Phone: ${m.altPhoneNo}'),
                        if (m.email != null) Text('Email: ${m.email}'),
                        if (m.headquarterAssigned != null) Text('Headquarter: ${m.headquarterAssigned}'),
                        if (m.territoriesOfWork != null) Text('Territories: ${m.territoriesOfWork?.join(", ")}'),
                        if (m.address != null) Text('Address: ${m.address}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
