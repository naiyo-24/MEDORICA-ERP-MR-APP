import 'dart:convert';

class Doctor {
  final int? dbId;
  final String id;
  final String? mrId;
  final DateTime? birthday;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final String photo;
  final String specialization;
  final String experience;
  final String qualification;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<DoctorChamber> chambers;

  Doctor({
    this.dbId,
    required this.id,
    this.mrId,
    this.birthday,
    required this.name,
    required this.phoneNumber,
    this.email = '',
    this.address = '',
    this.photo = '',
    required this.specialization,
    required this.experience,
    required this.qualification,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.chambers = const <DoctorChamber>[],
  });

  // Copy with method for updates
  Doctor copyWith({
    int? dbId,
    String? id,
    String? mrId,
    DateTime? birthday,
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? photo,
    String? specialization,
    String? experience,
    String? qualification,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<DoctorChamber>? chambers,
  }) {
    return Doctor(
      dbId: dbId ?? this.dbId,
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      birthday: birthday ?? this.birthday,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chambers: chambers ?? this.chambers,
    );
  }

  // Convert to backend-style JSON
  Map<String, dynamic> toJson() => {
    'id': dbId,
    'doctor_id': id,
    'mr_id': mrId,
    'doctor_birthday': birthday?.toIso8601String(),
    'doctor_name': name,
    'doctor_phone_no': phoneNumber,
    'doctor_email': email,
    'doctor_address': address,
    'doctor_photo': photo,
    'doctor_specialization': specialization,
    'doctor_experience': experience,
    'doctor_qualification': qualification,
    'doctor_description': description,
    'doctor_chambers': chambers.map((c) => c.toJson()).toList(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  // Create from backend JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    final dynamic rawChambers = json['doctor_chambers'] ?? json['chambers'];
    final List<dynamic> chamberList;

    if (rawChambers is List) {
      chamberList = rawChambers;
    } else if (rawChambers is String && rawChambers.trim().isNotEmpty) {
      final dynamic decoded = jsonDecode(rawChambers);
      chamberList = decoded is List ? decoded : <dynamic>[];
    } else {
      chamberList = <dynamic>[];
    }

    return Doctor(
      dbId: json['id'] as int?,
      id: (json['doctor_id'] ?? json['id'] ?? '').toString(),
      mrId: json['mr_id']?.toString(),
      birthday: _parseDateTime(json['doctor_birthday']),
      name: (json['doctor_name'] ?? json['name'] ?? '').toString(),
      phoneNumber: (json['doctor_phone_no'] ?? json['phoneNumber'] ?? '')
          .toString(),
      email: (json['doctor_email'] ?? json['email'] ?? '').toString(),
      address: (json['doctor_address'] ?? json['address'] ?? '').toString(),
      photo: (json['doctor_photo'] ?? json['photo'] ?? '').toString(),
      specialization:
          (json['doctor_specialization'] ?? json['specialization'] ?? '')
              .toString(),
      experience: (json['doctor_experience'] ?? json['experience'] ?? '')
          .toString(),
      qualification:
          (json['doctor_qualification'] ?? json['qualification'] ?? '')
              .toString(),
      description: (json['doctor_description'] ?? json['description'] ?? '')
          .toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      chambers: chamberList
          .whereType<Map<String, dynamic>>()
          .map(DoctorChamber.fromJson)
          .toList(),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}

class DoctorChamber {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;

  DoctorChamber({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
  });

  DoctorChamber copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
  }) {
    return DoctorChamber(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'phoneNumber': phoneNumber,
  };

  factory DoctorChamber.fromJson(Map<String, dynamic> json) => DoctorChamber(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? json['chamber_name'] ?? '').toString(),
    address: (json['address'] ?? json['chamber_address'] ?? '').toString(),
    phoneNumber:
        (json['phoneNumber'] ??
                json['phone_no'] ??
                json['phone_number'] ??
                json['chamber_phone'])
            ?.toString() ??
        '',
  );
}
