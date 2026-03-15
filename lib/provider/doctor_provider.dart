import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/doctor.dart';
import '../notifiers/doctor_notifier.dart';
import '../services/doctor/doctor_services.dart';

final doctorServiceProvider = Provider<DoctorServices>((ref) {
  return DoctorServices();
});

final doctorProvider = StateNotifierProvider<DoctorNotifier, DoctorState>((
  ref,
) {
  return DoctorNotifier(ref.read(doctorServiceProvider), ref.read);
});

final doctorListProvider = Provider.autoDispose<List<Doctor>>((ref) {
  return ref.watch(doctorProvider).doctors;
});

final doctorLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(doctorProvider).isLoading;
});

final doctorSubmittingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(doctorProvider).isSubmitting;
});

final doctorErrorProvider = Provider.autoDispose<String?>((ref) {
  return ref.watch(doctorProvider).error;
});

// Provider for a single doctor by ID
final doctorDetailProvider = Provider.family<Doctor?, String>((ref, id) {
  final doctors = ref.watch(doctorListProvider);
  try {
    return doctors.firstWhere((doctor) => doctor.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for searched doctors
final searchDoctorProvider = Provider.family<List<Doctor>, String>((
  ref,
  query,
) {
  final doctors = ref.watch(doctorListProvider);
  if (query.isEmpty) return doctors;
  final lowerQuery = query.toLowerCase();
  return doctors
      .where(
        (doctor) =>
            doctor.name.toLowerCase().contains(lowerQuery) ||
            doctor.specialization.toLowerCase().contains(lowerQuery),
      )
      .toList();
});

// Provider for filtered doctors by specialization
final filteredDoctorProvider = Provider.family<List<Doctor>, String>((
  ref,
  specialization,
) {
  final doctors = ref.watch(doctorListProvider);
  if (specialization.isEmpty) return doctors;
  return doctors
      .where((doctor) => doctor.specialization == specialization)
      .toList();
});

// Provider for all specializations
final specializationsProvider = Provider<List<String>>((ref) {
  final doctors = ref.watch(doctorListProvider);
  return doctors.map((doctor) => doctor.specialization).toSet().toList();
});
