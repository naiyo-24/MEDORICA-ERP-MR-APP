class Appointment {
  final String id;
  final String doctorId;
  final DateTime date;
  final String time;
  final String message;
  final AppointmentStatus status;
  final String? proofImagePath;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.message,
    required this.status,
    this.proofImagePath,
  });

  // Copy with method for updates
  Appointment copyWith({
    String? id,
    String? doctorId,
    DateTime? date,
    String? time,
    String? message,
    AppointmentStatus? status,
    String? proofImagePath,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      time: time ?? this.time,
      message: message ?? this.message,
      status: status ?? this.status,
      proofImagePath: proofImagePath ?? this.proofImagePath,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'date': date.toIso8601String(),
        'time': time,
        'message': message,
        'status': status.toString(),
        'proofImagePath': proofImagePath,
      };

  // Create from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] ?? '',
        doctorId: json['doctorId'] ?? '',
        date: DateTime.parse(json['date']),
        time: json['time'] ?? '',
        message: json['message'] ?? '',
        status: AppointmentStatus.values.firstWhere(
          (e) => e.toString() == json['status'],
          orElse: () => AppointmentStatus.scheduled,
        ),
        proofImagePath: json['proofImagePath'],
      );
}

enum AppointmentStatus {
  scheduled,
  completed,
  cancelled,
  missed;

  String get displayName {
    switch (this) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.missed:
        return 'Missed';
    }
  }
}
