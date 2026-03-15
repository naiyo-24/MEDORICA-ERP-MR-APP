import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

import '../models/doctor.dart';
import '../provider/auth_provider.dart';
import '../services/doctor/doctor_services.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);

class DoctorState {
  final List<Doctor> doctors;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const DoctorState({
    this.doctors = const <Doctor>[],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  DoctorState copyWith({
    List<Doctor>? doctors,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return DoctorState(
      doctors: doctors ?? this.doctors,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class DoctorNotifier extends StateNotifier<DoctorState> {
  DoctorNotifier(this._doctorServices, this._read)
    : super(const DoctorState()) {
    loadDoctorsForCurrentMr();
  }

  final DoctorServices _doctorServices;
  final Reader _read;

  Future<void> loadDoctorsForCurrentMr() async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'No logged in MR found');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final List<Doctor> doctors = await _doctorServices.fetchDoctorsByMrId(
        mrId,
      );
      state = state.copyWith(doctors: doctors, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final Doctor created = await _doctorServices.createDoctor(
        mrId: mrId,
        doctorName: doctor.name,
        doctorPhoneNo: doctor.phoneNumber,
        doctorBirthday: doctor.birthday,
        doctorSpecialization: doctor.specialization.isNotEmpty
            ? doctor.specialization
            : null,
        doctorQualification: doctor.qualification.isNotEmpty
            ? doctor.qualification
            : null,
        doctorExperience: doctor.experience.isNotEmpty
            ? doctor.experience
            : null,
        doctorDescription: doctor.description.isNotEmpty
            ? doctor.description
            : null,
        doctorChambers: doctor.chambers,
        doctorEmail: doctor.email.isNotEmpty ? doctor.email : null,
        doctorAddress: doctor.address.isNotEmpty ? doctor.address : null,
        doctorPhotoPath: _isLocalPath(doctor.photo) ? doctor.photo : null,
      );

      state = state.copyWith(
        doctors: <Doctor>[created, ...state.doctors],
        isSubmitting: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updateDoctor(Doctor updatedDoctor) async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      state = state.copyWith(error: 'No logged in MR found');
      return;
    }
    if (updatedDoctor.id.isEmpty) {
      state = state.copyWith(error: 'Missing doctor ID for update');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final Doctor saved = await _doctorServices.updateDoctor(
        mrId: mrId,
        doctorId: updatedDoctor.id,
        doctorName: updatedDoctor.name.isNotEmpty ? updatedDoctor.name : null,
        doctorPhoneNo: updatedDoctor.phoneNumber.isNotEmpty
            ? updatedDoctor.phoneNumber
            : null,
        doctorBirthday: updatedDoctor.birthday,
        doctorSpecialization: updatedDoctor.specialization.isNotEmpty
            ? updatedDoctor.specialization
            : null,
        doctorQualification: updatedDoctor.qualification.isNotEmpty
            ? updatedDoctor.qualification
            : null,
        doctorExperience: updatedDoctor.experience.isNotEmpty
            ? updatedDoctor.experience
            : null,
        doctorDescription: updatedDoctor.description.isNotEmpty
            ? updatedDoctor.description
            : null,
        doctorChambers: updatedDoctor.chambers,
        doctorEmail: updatedDoctor.email.isNotEmpty
            ? updatedDoctor.email
            : null,
        doctorAddress: updatedDoctor.address.isNotEmpty
            ? updatedDoctor.address
            : null,
        doctorPhotoPath: _isLocalPath(updatedDoctor.photo)
            ? updatedDoctor.photo
            : null,
      );

      final List<Doctor> next = state.doctors.map((Doctor item) {
        return item.id == saved.id ? saved : item;
      }).toList();

      state = state.copyWith(doctors: next, isSubmitting: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> deleteDoctor(String doctorId) async {
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      await _doctorServices.deleteDoctor(doctorId);
      state = state.copyWith(
        doctors: state.doctors
            .where((Doctor doctor) => doctor.id != doctorId)
            .toList(),
        isSubmitting: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  bool _isLocalPath(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('http://') || path.startsWith('https://')) return false;
    return true;
  }
}
