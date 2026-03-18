
class PlanActivity {
  final String id;
  final String type;
  final String? slot;
  final String? location;
  final String? notes;
  final bool isCompleted;

  PlanActivity({
    required this.id,
    required this.type,
    this.slot,
    this.location,
    this.notes,
    this.isCompleted = false,
  });

  PlanActivity copyWith({
    String? id,
    String? type,
    String? slot,
    String? location,
    String? notes,
    bool? isCompleted,
  }) {
    return PlanActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      slot: slot ?? this.slot,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'slot': slot,
        'location': location,
        'notes': notes,
        'isCompleted': isCompleted,
      };

  factory PlanActivity.fromJson(Map<String, dynamic> json) => PlanActivity(
        id: json['id']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        slot: json['slot']?.toString(),
        location: json['location']?.toString(),
        notes: json['notes']?.toString(),
        isCompleted: json['isCompleted'] ?? false,
      );

  factory PlanActivity.fromBackendJson({
    required Map<String, dynamic> json,
    required String fallbackId,
  }) {
    return PlanActivity(
      id: fallbackId,
      type: json['type']?.toString() ?? '',
      slot: json['slot']?.toString(),
      location: json['location']?.toString(),
      notes: json['notes']?.toString(),
      isCompleted: false,
    );
  }
}


class MonthPlan {
  final String id;
  final String? asmId;
  final int? teamId;
  final String? status;
  final String? mrId;
  final DateTime date;
  final List<PlanActivity> activities;
  final String? notes;

  MonthPlan({
    required this.id,
    this.asmId,
    this.teamId,
    this.status,
    this.mrId,
    required this.date,
    required this.activities,
    this.notes,
  });

  MonthPlan copyWith({
    String? id,
    String? asmId,
    int? teamId,
    String? status,
    String? mrId,
    DateTime? date,
    List<PlanActivity>? activities,
    String? notes,
  }) {
    return MonthPlan(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      teamId: teamId ?? this.teamId,
      status: status ?? this.status,
      mrId: mrId ?? this.mrId,
      date: date ?? this.date,
      activities: activities ?? this.activities,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'asmId': asmId,
        'teamId': teamId,
        'status': status,
        'mrId': mrId,
        'date': date.toIso8601String(),
        'activities': activities.map((a) => a.toJson()).toList(),
        'notes': notes,
      };

  factory MonthPlan.fromJson(Map<String, dynamic> json) => MonthPlan(
        id: json['id']?.toString() ?? '',
        asmId: json['asmId']?.toString(),
        teamId: _toInt(json['teamId']),
        status: json['status']?.toString(),
        mrId: json['mrId']?.toString(),
        date: DateTime.parse(json['date']),
        activities: (json['activities'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList()
            .asMap()
            .entries
            .map((entry) => PlanActivity.fromJson(entry.value))
            .toList(),
        notes: json['notes']?.toString(),
      );

  factory MonthPlan.fromBackendMrPlanJson(Map<String, dynamic> json) {
    final List<dynamic> rawActivities = json['activities'] as List<dynamic>? ?? <dynamic>[];
    final List<PlanActivity> parsedActivities = rawActivities
        .whereType<Map<String, dynamic>>()
        .toList()
        .asMap()
        .entries
        .map(
          (entry) => PlanActivity.fromBackendJson(
            json: entry.value,
            fallbackId: '${json['id'] ?? 'plan'}_${entry.key}',
          ),
        )
        .toList();

    final String? planDateRaw = json['plan_date']?.toString();

    return MonthPlan(
      id: (json['id'] ?? '').toString(),
      asmId: json['asm_id']?.toString(),
      teamId: _toInt(json['team_id']),
      status: json['status']?.toString(),
      mrId: json['mr_id']?.toString(),
      date: DateTime.tryParse(planDateRaw ?? '') ?? DateTime.now(),
      activities: parsedActivities,
      notes: null,
    );
  }

  bool get hasActivities => activities.isNotEmpty;

  int get completedCount => activities.where((a) => a.isCompleted).length;

  int get totalCount => activities.length;

  double get completionPercentage =>
      totalCount == 0 ? 0 : (completedCount / totalCount) * 100;
}



int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}
