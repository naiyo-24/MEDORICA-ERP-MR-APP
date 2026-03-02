import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/doctor.dart';
import '../notifiers/doctor_notifier.dart';

// Provider for the list of doctors
final doctorProvider = StateNotifierProvider<DoctorNotifier, List<Doctor>>((ref) {
  return DoctorNotifier();
});

// Provider for a single doctor by ID
final doctorDetailProvider = Provider.family<Doctor?, String>((ref, id) {
  final doctors = ref.watch(doctorProvider);
  try {
    return doctors.firstWhere((doctor) => doctor.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for searched doctors
final searchDoctorProvider = Provider.family<List<Doctor>, String>((ref, query) {
  final doctors = ref.watch(doctorProvider);
  if (query.isEmpty) return doctors;
  final lowerQuery = query.toLowerCase();
  return doctors
      .where((doctor) =>
          doctor.name.toLowerCase().contains(lowerQuery) ||
          doctor.specialization.toLowerCase().contains(lowerQuery))
      .toList();
});

// Provider for filtered doctors by specialization
final filteredDoctorProvider =
    Provider.family<List<Doctor>, String>((ref, specialization) {
  final doctors = ref.watch(doctorProvider);
  if (specialization.isEmpty) return doctors;
  return doctors
      .where((doctor) => doctor.specialization == specialization)
      .toList();
});

// Provider for all specializations
final specializationsProvider = Provider<List<String>>((ref) {
  final doctors = ref.watch(doctorProvider);
  return doctors.map((doctor) => doctor.specialization).toSet().toList();
});