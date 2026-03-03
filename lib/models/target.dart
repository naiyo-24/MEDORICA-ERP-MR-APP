class Target {
  final String id;
  final String month;
  final int year;
  final double targetAmount; // Total target in rupees
  final double achievedAmount; // Amount achieved in rupees
  final DateTime createdAt;
  final DateTime updatedAt;

  Target({
    required this.id,
    required this.month,
    required this.year,
    required this.targetAmount,
    required this.achievedAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate remaining target
  double get remainingAmount => targetAmount - achievedAmount;

  // Calculate percentage achieved
  double get percentageAchieved {
    if (targetAmount == 0) return 0;
    return (achievedAmount / targetAmount) * 100;
  }

  // Get status based on achievement
  TargetStatus get status {
    final percentage = percentageAchieved;
    if (percentage >= 100) {
      return TargetStatus.achieved;
    } else if (percentage >= 80) {
      return TargetStatus.closeToTarget;
    } else if (percentage >= 50) {
      return TargetStatus.onTrack;
    } else {
      return TargetStatus.veryFarAway;
    }
  }

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(
      id: json['id'] as String,
      month: json['month'] as String,
      year: json['year'] as int,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      achievedAmount: (json['achievedAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'targetAmount': targetAmount,
      'achievedAmount': achievedAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Target copyWith({
    String? id,
    String? month,
    int? year,
    double? targetAmount,
    double? achievedAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Target(
      id: id ?? this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      targetAmount: targetAmount ?? this.targetAmount,
      achievedAmount: achievedAmount ?? this.achievedAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum TargetStatus {
  achieved,
  closeToTarget,
  onTrack,
  veryFarAway,
}
