enum PlanActivityType {
  doctorVisit,
  chemistVisit,
  distributorVisit,
  meeting,
  other,
}

class PlanActivity {
  final String id;
  final PlanActivityType type;
  final String title;
  final String? description;
  final String? time;
  final String? location;
  final String? contactId; // doctor/chemist/distributor ID
  final bool isCompleted;

  PlanActivity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.time,
    this.location,
    this.contactId,
    this.isCompleted = false,
  });

  PlanActivity copyWith({
    String? id,
    PlanActivityType? type,
    String? title,
    String? description,
    String? time,
    String? location,
    String? contactId,
    bool? isCompleted,
  }) {
    return PlanActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      location: location ?? this.location,
      contactId: contactId ?? this.contactId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'description': description,
    'time': time,
    'location': location,
    'contactId': contactId,
    'isCompleted': isCompleted,
  };

  factory PlanActivity.fromJson(Map<String, dynamic> json) => PlanActivity(
    id: json['id'],
    type: PlanActivityType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => PlanActivityType.other,
    ),
    title: json['title'],
    description: json['description'],
    time: json['time'],
    location: json['location'],
    contactId: json['contactId'],
    isCompleted: json['isCompleted'] ?? false,
  );

  factory PlanActivity.fromBackendJson({
    required Map<String, dynamic> json,
    required String fallbackId,
  }) {
    final String rawType = (json['type'] ?? '').toString().trim();
    return PlanActivity(
      id: fallbackId,
      type: _parsePlanActivityType(rawType),
      title: _titleFromBackendType(rawType),
      description: json['notes']?.toString(),
      time: json['slot']?.toString(),
      location: json['location']?.toString(),
      isCompleted: false,
    );
  }

  String get typeLabel {
    switch (type) {
      case PlanActivityType.doctorVisit:
        return 'Doctor Visit';
      case PlanActivityType.chemistVisit:
        return 'Chemist Visit';
      case PlanActivityType.distributorVisit:
        return 'Distributor Visit';
      case PlanActivityType.meeting:
        return 'Meeting';
      case PlanActivityType.other:
        return 'Other';
    }
  }
}

class MonthPlan {
  final String id;
  final String? asmId;
  final int? teamId;
  final String? status;
  final String? mrId;
  final String? mrName;
  final DateTime date;
  final List<PlanActivity> activities;
  final String? notes;

  MonthPlan({
    required this.id,
    this.asmId,
    this.teamId,
    this.status,
    this.mrId,
    this.mrName,
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
    String? mrName,
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
      mrName: mrName ?? this.mrName,
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
    'mrName': mrName,
    'date': date.toIso8601String(),
    'activities': activities.map((a) => a.toJson()).toList(),
    'notes': notes,
  };

  factory MonthPlan.fromJson(Map<String, dynamic> json) => MonthPlan(
    id: json['id'],
    asmId: json['asmId'],
    teamId: json['teamId'],
    status: json['status'],
    mrId: json['mrId'],
    mrName: json['mrName'],
    date: DateTime.parse(json['date']),
    activities: (json['activities'] as List)
        .map((a) => PlanActivity.fromJson(a))
        .toList(),
    notes: json['notes'],
  );

  factory MonthPlan.fromBackendMrPlanJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mrPlan =
        (json['mr_plan'] as Map<String, dynamic>? ?? <String, dynamic>{});

    final List<dynamic> rawActivities =
        (mrPlan['activities'] as List<dynamic>? ?? <dynamic>[]);
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
      mrId: mrPlan['mr_id']?.toString(),
      mrName: mrPlan['mr_name']?.toString(),
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

PlanActivityType _parsePlanActivityType(String raw) {
  final String value = raw.trim().toLowerCase();
  if (value.contains('doctor')) {
    return PlanActivityType.doctorVisit;
  }
  if (value.contains('chemist')) {
    return PlanActivityType.chemistVisit;
  }
  if (value.contains('distributor')) {
    return PlanActivityType.distributorVisit;
  }
  if (value.contains('meeting')) {
    return PlanActivityType.meeting;
  }
  return PlanActivityType.other;
}

String _titleFromBackendType(String raw) {
  final PlanActivityType parsedType = _parsePlanActivityType(raw);
  switch (parsedType) {
    case PlanActivityType.doctorVisit:
      return 'Doctor Visit';
    case PlanActivityType.chemistVisit:
      return 'Chemist Visit';
    case PlanActivityType.distributorVisit:
      return 'Distributor Visit';
    case PlanActivityType.meeting:
      return 'Meeting';
    case PlanActivityType.other:
      return raw.trim().isEmpty ? 'Activity' : raw.trim();
  }
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
