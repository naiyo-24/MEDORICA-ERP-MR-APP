class AboutUs {
  final String companyName;
  final String description;
  final String directorName;
  final String directorMessage;
  final String directorPhotoUrl;
  final String phone;
  final String email;
  final String address;
  final String mapUrl;

  AboutUs({
    required this.companyName,
    required this.description,
    required this.directorName,
    required this.directorMessage,
    required this.directorPhotoUrl,
    required this.phone,
    required this.email,
    required this.address,
    required this.mapUrl,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      companyName: json['companyName'] ?? '',
      description: json['description'] ?? '',
      directorName: json['directorName'] ?? '',
      directorMessage: json['directorMessage'] ?? '',
      directorPhotoUrl: json['directorPhotoUrl'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      mapUrl: json['mapUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'description': description,
      'directorName': directorName,
      'directorMessage': directorMessage,
      'directorPhotoUrl': directorPhotoUrl,
      'phone': phone,
      'email': email,
      'address': address,
      'mapUrl': mapUrl,
    };
  }
}
