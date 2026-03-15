import '../services/api_url.dart';

class AppointmentVisualAd {
  final String id;
  final String medicineName;

  const AppointmentVisualAd({required this.id, required this.medicineName});

  Map<String, dynamic> toJson() => {
    'id': int.tryParse(id) ?? id,
    'medicine_name': medicineName,
  };

  factory AppointmentVisualAd.fromJson(Map<String, dynamic> json) {
    return AppointmentVisualAd(
      id: (json['id'] ?? '').toString(),
      medicineName: (json['medicine_name'] ?? json['medicineName'] ?? '')
          .toString(),
    );
  }
}

class Appointment {
  final String id; // appointment_id
  final String? mrId;
  final String doctorId;
  final DateTime date; // appointment_date
  final String time; // appointment_time
  final String message; // maps to backend `place`
  final AppointmentStatus status;
  final String? completionPhotoProof;
  final List<AppointmentVisualAd> visualAds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Appointment({
    required this.id,
    this.mrId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.message,
    required this.status,
    this.completionPhotoProof,
    this.visualAds = const [],
    this.createdAt,
    this.updatedAt,
  });

  Appointment copyWith({
    String? id,
    String? mrId,
    String? doctorId,
    DateTime? date,
    String? time,
    String? message,
    AppointmentStatus? status,
    String? completionPhotoProof,
    List<AppointmentVisualAd>? visualAds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      time: time ?? this.time,
      message: message ?? this.message,
      status: status ?? this.status,
      completionPhotoProof: completionPhotoProof ?? this.completionPhotoProof,
      visualAds: visualAds ?? this.visualAds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'appointment_id': id,
    'mr_id': mrId,
    'doctor_id': doctorId,
    'appointment_date': _dateOnly(date),
    'appointment_time': time,
    'place': message,
    'status': status.apiValue,
    'completion_photo_proof': completionPhotoProof,
    'visual_ads': visualAds.map((ad) => ad.toJson()).toList(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: (json['appointment_id'] ?? json['id'] ?? '').toString(),
      mrId: _nullable(json['mr_id']),
      doctorId: (json['doctor_id'] ?? '').toString(),
      date: _parseDate(json['appointment_date']),
      time: (json['appointment_time'] ?? '').toString(),
      message: (json['place'] ?? '').toString(),
      status: AppointmentStatus.fromApiValue((json['status'] ?? '').toString()),
      completionPhotoProof: _normalizePath(json['completion_photo_proof']),
      visualAds: _parseVisualAds(json['visual_ads']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static List<AppointmentVisualAd> _parseVisualAds(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map<String, dynamic>>()
        .map(AppointmentVisualAd.fromJson)
        .toList();
  }

  static String _dateOnly(DateTime value) {
    final local = value.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime _parseDate(dynamic value) {
    final text = (value ?? '').toString().trim();
    return DateTime.tryParse(text) ?? DateTime.now();
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String? _nullable(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _normalizePath(dynamic value) {
    final text = _nullable(value);
    if (text == null) return null;
    if (text.startsWith('http://') || text.startsWith('https://')) {
      return ApiUrl.getFullUrl(text);
    }
    return ApiUrl.getFullUrl(text);
  }
}

enum AppointmentStatus {
  pending,
  ongoing,
  cancelled,
  completed;

  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.ongoing:
        return 'Ongoing';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.completed:
        return 'Completed';
    }
  }

  String get apiValue {
    switch (this) {
      case AppointmentStatus.pending:
        return 'pending';
      case AppointmentStatus.ongoing:
        return 'ongoing';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.completed:
        return 'completed';
    }
  }

  static AppointmentStatus fromApiValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'ongoing':
        return AppointmentStatus.ongoing;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'completed':
        return AppointmentStatus.completed;
      case 'pending':
      default:
        return AppointmentStatus.pending;
    }
  }
}