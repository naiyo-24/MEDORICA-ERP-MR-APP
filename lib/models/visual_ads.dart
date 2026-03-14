class VisualAd {
  final int id;
  final String adId;
  final String medicineName;
  final String? adImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? localImagePath;

  const VisualAd({
    required this.id,
    required this.adId,
    required this.medicineName,
    this.adImage,
    required this.createdAt,
    required this.updatedAt,
    this.localImagePath,
  });

  String get displayImagePath => localImagePath ?? adImage ?? '';

  factory VisualAd.fromJson(Map<String, dynamic> json) {
    return VisualAd(
      id: _asInt(json['id']),
      adId: _asString(json['ad_id'] ?? json['adId']),
      medicineName: _asString(json['medicine_name'] ?? json['medicineName']),
      adImage: _asNullableString(json['ad_image'] ?? json['adImage']),
      createdAt: _asDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _asDateTime(json['updated_at'] ?? json['updatedAt']),
      localImagePath: _asNullableString(
        json['local_image_path'] ?? json['localImagePath'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad_id': adId,
      'medicine_name': medicineName,
      'ad_image': adImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'local_image_path': localImagePath,
    };
  }

  VisualAd copyWith({
    int? id,
    String? adId,
    String? medicineName,
    String? adImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? localImagePath,
  }) {
    return VisualAd(
      id: id ?? this.id,
      adId: adId ?? this.adId,
      medicineName: medicineName ?? this.medicineName,
      adImage: adImage ?? this.adImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }

  static String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  static String? _asNullableString(dynamic value) {
    final parsed = _asString(value);
    return parsed.isEmpty ? null : parsed;
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime _asDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisualAd &&
          runtimeType == other.runtimeType &&
          adId == other.adId;

  @override
  int get hashCode => adId.hashCode;
}