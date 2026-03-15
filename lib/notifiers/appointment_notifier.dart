import 'package:flutter_riverpod/legacy.dart';

import '../models/appointment.dart';
import '../services/appointment/appointment_services.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
    Future<void> fetchAppointmentsBymrId(String mrId) async {
      await loadAppointmentsBymrId(mrId);
    }
  AppointmentNotifier(this._appointmentServices) : super(const []);

  final AppointmentServices _appointmentServices;
  String? _activemrId;

  Future<void> syncAsm(String? mrId) async {
    final nextmrId = mrId?.trim();
    if (nextmrId == null || nextmrId.isEmpty) {
      _activemrId = null;
      state = const [];
      return;
    }

    if (_activemrId == nextmrId && state.isNotEmpty) {
      return;
    }

    _activemrId = nextmrId;
    await loadAppointmentsBymrId(nextmrId);
  }

  Future<void> loadAppointmentsBymrId(String mrId) async {
    final trimmedmrId = mrId.trim();
    if (trimmedmrId.isEmpty) {
      state = const [];
      return;
    }

    final appointments = await _appointmentServices.fetchAppointmentsBymrId(
      trimmedmrId,
    );
    state = appointments;
  }

  Future<void> addAppointment({
    required String mrId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    final created = await _appointmentServices.createAppointment(
      mrId: mrId,
      appointment: appointment,
      completionPhotoProofPath: completionPhotoProofPath,
    );
    state = [...state, created];
  }

  Future<void> updateAppointment({
    required String mrId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    final updated = await _appointmentServices.updateAppointmentById(
      appointmentId: appointment.id,
      appointment: appointment,
      completionPhotoProofPath: completionPhotoProofPath,
    );

    state = [
      for (final item in state)
        if (item.id == appointment.id) updated else item,
    ];

    if (!state.any((item) => item.id == updated.id)) {
      await fetchAppointmentsBymrId(mrId);
    }
  }

  Future<void> deleteAppointment({
    required String mrId,
    required String appointmentId,
  }) async {
    await _appointmentServices.deleteAppointmentById(appointmentId);
    state = state
        .where((appointment) => appointment.id != appointmentId)
        .toList();

    if (state.isEmpty) {
      await fetchAppointmentsBymrId(mrId);
    }
  }
}