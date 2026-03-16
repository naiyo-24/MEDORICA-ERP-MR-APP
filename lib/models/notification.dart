class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'appointment', 'message', 'system'
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final String? icon;
  final String? subTitle;
  final String? audience;
  final DateTime? updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.icon,
    this.subTitle,
    this.audience,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString().trim();
    final subTitle =
        _readString(json['sub_title']) ?? _readString(json['message']);
    final timestamp =
        _parseDateTime(json['created_at'] ?? json['timestamp']) ??
        DateTime.now();

    return NotificationModel(
      id: (json['id'] ?? '').toString(),
      title: title.isEmpty ? 'Notification' : title,
      message: (subTitle != null && subTitle.trim().isNotEmpty)
          ? subTitle.trim()
          : (title.isEmpty ? 'No details available.' : title),
      type: _readString(json['type']) ?? _inferType(title, subTitle),
      timestamp: timestamp,
      isRead: json['isRead'] as bool? ?? false,
      actionUrl: _readString(json['actionUrl']),
      icon: _readString(json['icon']),
      subTitle: subTitle,
      audience: _readString(json['audience']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
      'icon': icon,
      'sub_title': subTitle,
      'audience': audience,
      'created_at': timestamp.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    String? icon,
    String? subTitle,
    String? audience,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      icon: icon ?? this.icon,
      subTitle: subTitle ?? this.subTitle,
      audience: audience ?? this.audience,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String? _readString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }

  static String _inferType(String title, String? subTitle) {
    final content = '${title.toLowerCase()} ${subTitle?.toLowerCase() ?? ''}';

    if (content.contains('order')) {
      return 'order';
    }

    if (content.contains('appointment') || content.contains('doctor')) {
      return 'appointment';
    }

    if (content.contains('message') || content.contains('chat')) {
      return 'message';
    }

    return 'system';
  }
}
