class Attendance {
  final DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;
  String? checkInPhotoPath;
  String? checkOutPhotoPath;

  Attendance({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.checkInPhotoPath,
    this.checkOutPhotoPath,
  });

  bool get isCheckedIn => checkIn != null;
  bool get isCheckedOut => checkOut != null;
}