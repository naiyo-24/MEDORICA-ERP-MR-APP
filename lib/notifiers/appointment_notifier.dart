import 'package:flutter_riverpod/legacy.dart';
import '../models/appointment.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  AppointmentNotifier() : super([]) {
    _loadAppointments();
  }

  // Load appointments - mock data for now
  void _loadAppointments() {
    state = [
      Appointment(
        id: '1',
        doctorId: '1',
        date: DateTime(2026, 3, 5),
        time: '10:00 AM',
        message: 'Regular checkup for heart condition',
        status: AppointmentStatus.scheduled,
      ),
      Appointment(
        id: '2',
        doctorId: '2',
        date: DateTime(2026, 3, 8),
        time: '2:30 PM',
        message: 'Follow-up on knee injury',
        status: AppointmentStatus.scheduled,
      ),
      Appointment(
        id: '3',
        doctorId: '1',
        date: DateTime(2026, 2, 28),
        time: '11:00 AM',
        message: 'Consultation for chest pain',
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: '4',
        doctorId: '3',
        date: DateTime(2026, 2, 25),
        time: '4:00 PM',
        message: 'Neurological examination',
        status: AppointmentStatus.cancelled,
      ),
    ];
  }

  // Add a new appointment
  void addAppointment(Appointment appointment) {
    state = [...state, appointment.copyWith(id: DateTime.now().toString())];
  }

  // Update an appointment
  void updateAppointment(Appointment updatedAppointment) {
    state = [
      for (final appointment in state)
        if (appointment.id == updatedAppointment.id)
          updatedAppointment
        else
          appointment,
    ];
  }

  // Delete an appointment
  void deleteAppointment(String id) {
    state = [
      for (final appointment in state)
        if (appointment.id != id) appointment
    ];
  }

  // Get an appointment by id
  Appointment? getAppointmentById(String id) {
    try {
      return state.firstWhere((appointment) => appointment.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get appointments by doctor id
  List<Appointment> getAppointmentsByDoctorId(String doctorId) {
    return state
        .where((appointment) => appointment.doctorId == doctorId)
        .toList();
  }

  // Filter by date
  List<Appointment> filterByDate(DateTime date) {
    return state
        .where((appointment) =>
            appointment.date.year == date.year &&
            appointment.date.month == date.month &&
            appointment.date.day == date.day)
        .toList();
  }

  // Filter by status
  List<Appointment> filterByStatus(AppointmentStatus status) {
    return state
        .where((appointment) => appointment.status == status)
        .toList();
  }

  // Get upcoming appointments
  List<Appointment> getUpcomingAppointments() {
    final now = DateTime.now();
    return state
        .where((appointment) =>
            appointment.date.isAfter(now) &&
            appointment.status == AppointmentStatus.scheduled)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get past appointments
  List<Appointment> getPastAppointments() {
    final now = DateTime.now();
    return state
        .where((appointment) => appointment.date.isBefore(now))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Mark appointment as completed with proof image
  void markAppointmentAsCompleted(String id, String proofImagePath) {
    state = [
      for (final appointment in state)
        if (appointment.id == id)
          appointment.copyWith(
            status: AppointmentStatus.completed,
            proofImagePath: proofImagePath,
          )
        else
          appointment,
    ];
  }

  // Cancel an appointment
  void cancelAppointment(String id) {
    state = [
      for (final appointment in state)
        if (appointment.id == id)
          appointment.copyWith(status: AppointmentStatus.cancelled)
        else
          appointment,
    ];
  }
}
