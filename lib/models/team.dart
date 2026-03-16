
class Team {
  final int id;
  final int teamId;
  final String teamName;
  final String? teamDescription;
  final String? whatsappGroupLink;
  final String teamLeaderAsmId;
  final List<String>? teamMembersMrIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TeamLeader? teamLeader;
  final List<TeamMember> teamMembers;

  Team({
    required this.id,
    required this.teamId,
    required this.teamName,
    this.teamDescription,
    this.whatsappGroupLink,
    required this.teamLeaderAsmId,
    this.teamMembersMrIds,
    required this.createdAt,
    required this.updatedAt,
    this.teamLeader,
    required this.teamMembers,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      teamDescription: json['team_description'],
      whatsappGroupLink: json['whatsapp_group_link'],
      teamLeaderAsmId: json['team_leader_asm_id'],
      teamMembersMrIds: (json['team_members_mr_ids'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      teamLeader: json['team_leader'] != null ? TeamLeader.fromJson(json['team_leader']) : null,
      teamMembers: (json['team_members'] as List?)?.map((e) => TeamMember.fromJson(e)).toList() ?? [],
    );
  }
}

class TeamLeader {
  final String asmId;
  final String fullName;
  final String phoneNo;

  TeamLeader({
    required this.asmId,
    required this.fullName,
    required this.phoneNo,
  });

  factory TeamLeader.fromJson(Map<String, dynamic> json) {
    return TeamLeader(
      asmId: json['asm_id'],
      fullName: json['full_name'],
      phoneNo: json['phone_no'],
    );
  }
}

class TeamMember {
  final String mrId;
  final String fullName;
  final String phoneNo;
  final String? altPhoneNo;
  final String? email;
  final String? address;
  final String? headquarterAssigned;
  final List<dynamic>? territoriesOfWork;
  final String? profilePhoto;

  TeamMember({
    required this.mrId,
    required this.fullName,
    required this.phoneNo,
    this.altPhoneNo,
    this.email,
    this.address,
    this.headquarterAssigned,
    this.territoriesOfWork,
    this.profilePhoto,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      mrId: json['mr_id'],
      fullName: json['full_name'],
      phoneNo: json['phone_no'],
      altPhoneNo: json['alt_phone_no'],
      email: json['email'],
      address: json['address'],
      headquarterAssigned: json['headquarter_assigned'],
      territoriesOfWork: json['territories_of_work'],
      profilePhoto: json['profile_photo'],
    );
  }
}
