import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/appointment.dart';
import '../notifiers/appointment_notifier.dart';

// Provider for the list of appointments
final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>((ref) {
  return AppointmentNotifier();
});

// Provider for a single appointment by ID
final appointmentDetailProvider = Provider.family<Appointment?, String>((ref, id) {
  final appointments = ref.watch(appointmentProvider);
  try {
    return appointments.firstWhere((appointment) => appointment.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for appointments by doctor ID
final appointmentsByDoctorProvider =
    Provider.family<List<Appointment>, String>((ref, doctorId) {
  final appointments = ref.watch(appointmentProvider);
  return appointments
      .where((appointment) => appointment.doctorId == doctorId)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});

// Provider for upcoming appointments
final upcomingAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final appointments = ref.watch(appointmentProvider);
  final now = DateTime.now();
  return appointments
      .where((appointment) =>
          appointment.date.isAfter(now) &&
          appointment.status == AppointmentStatus.scheduled)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});

// Provider for past appointments
final pastAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final appointments = ref.watch(appointmentProvider);
  final now = DateTime.now();
  return appointments
      .where((appointment) => appointment.date.isBefore(now))
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

// Provider for filtered appointments by date
final appointmentsByDateProvider =
    Provider.family<List<Appointment>, DateTime>((ref, date) {
  final appointments = ref.watch(appointmentProvider);
  return appointments
      .where((appointment) =>
          appointment.date.year == date.year &&
          appointment.date.month == date.month &&
          appointment.date.day == date.day)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});

// Provider for filtered appointments by status
final appointmentsByStatusProvider =
    Provider.family<List<Appointment>, AppointmentStatus>((ref, status) {
  final appointments = ref.watch(appointmentProvider);
  return appointments
      .where((appointment) => appointment.status == status)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});
