class Doctor {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String photo;
  final String specialization;
  final String experience;
  final String qualification;
  final String description;
  final List<DoctorChamber> chambers;

  Doctor({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.photo,
    required this.specialization,
    required this.experience,
    required this.qualification,
    required this.description,
    required this.chambers,
  });

  // Copy with method for updates
  Doctor copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? photo,
    String? specialization,
    String? experience,
    String? qualification,
    String? description,
    List<DoctorChamber>? chambers,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      description: description ?? this.description,
      chambers: chambers ?? this.chambers,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'photo': photo,
    'specialization': specialization,
    'experience': experience,
    'qualification': qualification,
    'description': description,
    'chambers': chambers.map((c) => c.toJson()).toList(),
  };

  // Create from JSON
  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    email: json['email'] ?? '',
    photo: json['photo'] ?? '',
    specialization: json['specialization'] ?? '',
    experience: json['experience'] ?? '',
    qualification: json['qualification'] ?? '',
    description: json['description'] ?? '',
    chambers: (json['chambers'] as List?)
        ?.map((c) => DoctorChamber.fromJson(c))
        .toList() ?? [],
  );
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
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
  );
}