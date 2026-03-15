class ChemistShop {
  // Backend integer primary key (null for locally-constructed objects).
  final int? dbId;
  // Backend string business identifier (shop_id).
  final String id;
  final String? mrId;
  final String name;
  final String phoneNumber;
  final String email;
  final String photo;
  final String? bankPassbookPhoto;
  final String location;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> doctorIds; // local UI only — not stored on backend

  ChemistShop({
    this.dbId,
    required this.id,
    this.mrId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.photo,
    this.bankPassbookPhoto,
    required this.location,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.doctorIds = const <String>[],
  });

  // Copy with method for updates
  ChemistShop copyWith({
    int? dbId,
    String? id,
    String? mrId,
    String? name,
    String? phoneNumber,
    String? email,
    String? photo,
    String? bankPassbookPhoto,
    String? location,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? doctorIds,
  }) {
    return ChemistShop(
      dbId: dbId ?? this.dbId,
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      bankPassbookPhoto: bankPassbookPhoto ?? this.bankPassbookPhoto,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      doctorIds: doctorIds ?? this.doctorIds,
    );
  }

  // Convert to JSON (backend format).
  Map<String, dynamic> toJson() => {
        'id': dbId,
        'shop_id': id,
        'mr_id': mrId,
        'shop_name': name,
        'phone_no': phoneNumber,
        'email': email,
        'photo': photo,
        'bank_passbook_photo': bankPassbookPhoto,
        'address': location,
        'description': description,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  // Create from backend JSON response.
  factory ChemistShop.fromJson(Map<String, dynamic> json) => ChemistShop(
        dbId: json['id'] as int?,
        id: json['shop_id'] as String? ?? '',
        mrId: json['mr_id'] as String?,
        name: json['shop_name'] as String? ?? '',
        phoneNumber: json['phone_no'] as String? ?? '',
        email: json['email'] as String? ?? '',
        photo: json['photo'] as String? ?? '',
        bankPassbookPhoto: json['bank_passbook_photo'] as String?,
        location: json['address'] as String? ?? '',
        description: json['description'] as String? ?? '',
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())
            : null,
        doctorIds: const <String>[],
      );
}
