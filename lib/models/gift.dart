class Gift {
  final String id;
  final String doctorId;
  final String giftItem;
  final DateTime date;
  final String occasion;
  final String remarks;
  final GiftStatus status;

  Gift({
    required this.id,
    required this.doctorId,
    required this.giftItem,
    required this.date,
    required this.occasion,
    required this.remarks,
    required this.status,
  });

  // Copy with method for updates
  Gift copyWith({
    String? id,
    String? doctorId,
    String? giftItem,
    DateTime? date,
    String? occasion,
    String? remarks,
    GiftStatus? status,
  }) {
    return Gift(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      giftItem: giftItem ?? this.giftItem,
      date: date ?? this.date,
      occasion: occasion ?? this.occasion,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'giftItem': giftItem,
        'date': date.toIso8601String(),
        'occasion': occasion,
        'remarks': remarks,
        'status': status.toString(),
      };

  // Create from JSON
  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json['id'] ?? '',
        doctorId: json['doctorId'] ?? '',
        giftItem: json['giftItem'] ?? '',
        date: DateTime.parse(json['date']),
        occasion: json['occasion'] ?? '',
        remarks: json['remarks'] ?? '',
        status: GiftStatus.values.firstWhere(
          (e) => e.toString() == json['status'],
          orElse: () => GiftStatus.pending,
        ),
      );
}

enum GiftStatus {
  pending,
  sent,
  received,
  cancelled;

  String get displayName {
    switch (this) {
      case GiftStatus.pending:
        return 'Pending';
      case GiftStatus.sent:
        return 'Sent';
      case GiftStatus.received:
        return 'Received';
      case GiftStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class GiftItem {
  final String id;
  final String name;
  final String description;

  GiftItem({
    required this.id,
    required this.name,
    required this.description,
  });
}

class GiftOccasion {
  final String id;
  final String name;

  GiftOccasion({
    required this.id,
    required this.name,
  });
}
