import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/doctor/doctor_screen.dart';
import '../screens/doctor/doctor_detail_screen.dart';
import '../screens/doctor/add_edit_doctor_screen.dart';
import '../models/doctor.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String doctor = '/mr/doctor';
  static const String appointments = '/mr/appointments';
  static const String orders = '/mr/orders';
  static const String chemist = '/mr/chemist';
  static const String distributor = '/mr/distributor';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: doctor,
        name: 'doctor',
        builder: (context, state) => const MyDoctorScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'doctorAdd',
            builder: (context, state) => const AddEditDoctorScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'doctorDetail',
            builder: (context, state) {
              final doctorId = state.pathParameters['id']!;
              return DoctorDetailScreen(doctorId: doctorId);
            },
          ),
          GoRoute(
            path: 'edit/:id',
            name: 'doctorEdit',
            builder: (context, state) {
              final _ = state.pathParameters['id']!;
              final doctor = state.extra as Doctor?;
              return AddEditDoctorScreen(doctor: doctor);
            },
          ),
        ],
      ),
      GoRoute(
        path: appointments,
        name: 'appointments',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Appointments - Coming Soon')),
        ),
      ),
      GoRoute(
        path: orders,
        name: 'orders',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Orders - Coming Soon')),
        ),
      ),
      GoRoute(
        path: chemist,
        name: 'chemist',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Shops - Coming Soon')),
        ),
      ),
      GoRoute(
        path: distributor,
        name: 'distributor',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Distributors - Coming Soon')),
        ),
      ),
    ],
  );
}
