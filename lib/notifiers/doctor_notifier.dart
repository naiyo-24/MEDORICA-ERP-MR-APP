import 'package:flutter_riverpod/legacy.dart';
import '../models/doctor.dart';

class DoctorNotifier extends StateNotifier<List<Doctor>> {
  DoctorNotifier() : super([]) {
    _loadDoctors();
  }

  // Load doctors - mock data for now
  void _loadDoctors() {
    state = [
      Doctor(
        id: '1',
        name: 'Dr. Ahmed Khan',
        phoneNumber: '+880 1700 123456',
        email: 'ahmed.khan@hospital.com',
        photo: 'https://via.placeholder.com/400x300?text=Dr.+Ahmed+Khan',
        specialization: 'Cardiology',
        experience: '15 years',
        qualification: 'MBBS, MD (Cardiology)',
        description: 'Experienced cardiologist with 15 years of practice in managing complex cardiac conditions.',
        chambers: [
          DoctorChamber(
            id: '1',
            name: 'Khan Heart Care Clinic',
            address: '123 Gulshan Avenue, Dhaka',
            phoneNumber: '+880 2 8000 1234',
          ),
          DoctorChamber(
            id: '2',
            name: 'Cardiac Center DMC',
            address: '456 Dhanmondi Road, Dhaka',
            phoneNumber: '+880 2 8000 5678',
          ),
        ],
      ),
      Doctor(
        id: '2',
        name: 'Dr. Fatima Begum',
        phoneNumber: '+880 1800 234567',
        email: 'fatima.begum@hospital.com',
        photo: 'https://via.placeholder.com/400x300?text=Dr.+Fatima+Begum',
        specialization: 'Orthopedics',
        experience: '12 years',
        qualification: 'MBBS, MS (Orthopedics)',
        description: 'Specialist in orthopedic surgery with focus on joint replacements and sports injuries.',
        chambers: [
          DoctorChamber(
            id: '3',
            name: 'Bone & Joint Clinic',
            address: '789 Mirpur Road, Dhaka',
            phoneNumber: '+880 2 8000 9999',
          ),
        ],
      ),
      Doctor(
        id: '3',
        name: 'Dr. Rajesh Sharma',
        phoneNumber: '+880 1900 345678',
        email: 'rajesh.sharma@hospital.com',
        photo: 'https://via.placeholder.com/400x300?text=Dr.+Rajesh+Sharma',
        specialization: 'Neurology',
        experience: '10 years',
        qualification: 'MBBS, MD (Neurology)',
        description: 'Expert in neurological disorders including stroke, epilepsy, and Parkinson\'s disease.',
        chambers: [
          DoctorChamber(
            id: '4',
            name: 'Neuro Center',
            address: '321 Banani, Dhaka',
            phoneNumber: '+880 2 8000 7777',
          ),
        ],
      ),
    ];
  }

  // Add a new doctor
  void addDoctor(Doctor doctor) {
    state = [...state, doctor.copyWith(id: DateTime.now().toString())];
  }

  // Update a doctor
  void updateDoctor(Doctor updatedDoctor) {
    state = [
      for (final doctor in state)
        if (doctor.id == updatedDoctor.id) updatedDoctor else doctor,
    ];
  }

  // Delete a doctor
  void deleteDoctor(String id) {
    state = [for (final doctor in state) if (doctor.id != id) doctor];
  }

  // Get a doctor by id
  Doctor? getDoctorById(String id) {
    try {
      return state.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search doctors
  List<Doctor> searchDoctors(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    return state
        .where((doctor) =>
            doctor.name.toLowerCase().contains(lowerQuery) ||
            doctor.specialization.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Filter by specialization
  List<Doctor> filterBySpecialization(String specialization) {
    if (specialization.isEmpty) return state;
    return state
        .where((doctor) => doctor.specialization == specialization)
        .toList();
  }

  // Get all specializations
  List<String> getAllSpecializations() {
    return state.map((doctor) => doctor.specialization).toSet().toList();
  }
}