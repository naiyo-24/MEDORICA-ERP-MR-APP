class ChemistShop {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String photo;
  final String location;
  final String description;
  final List<String> doctorIds; // List of doctor IDs who sit at this shop

  ChemistShop({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.photo,
    required this.location,
    required this.description,
    required this.doctorIds,
  });

  // Copy with method for updates
  ChemistShop copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? photo,
    String? location,
    String? description,
    List<String>? doctorIds,
  }) {
    return ChemistShop(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      location: location ?? this.location,
      description: description ?? this.description,
      doctorIds: doctorIds ?? this.doctorIds,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'photo': photo,
        'location': location,
        'description': description,
        'doctorIds': doctorIds,
      };

  // Create from JSON
  factory ChemistShop.fromJson(Map<String, dynamic> json) => ChemistShop(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        email: json['email'] ?? '',
        photo: json['photo'] ?? '',
        location: json['location'] ?? '',
        description: json['description'] ?? '',
        doctorIds: (json['doctorIds'] as List?)?.cast<String>() ?? [],
      );
}
