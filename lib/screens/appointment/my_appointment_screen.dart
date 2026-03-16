import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/appointment.dart';
import '../../provider/appointment_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../cards/appointment/appointment_card.dart';
import '../../cards/appointment/appointment_filter_options_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/app_bar.dart';

class MyAppointmentScreen extends ConsumerStatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  ConsumerState<MyAppointmentScreen> createState() =>
      _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends ConsumerState<MyAppointmentScreen> {
  DateTime? _selectedDate;
  AppointmentStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentProvider);

    // Apply filters
    final filteredAppointments = _filterAppointments(appointments);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go(AppRouter.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'My Appointments',
          subtitleText: 'View and Manage',
        ),
        body: Column(
          children: [
            // Filter Options Card
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppointmentFilterOptionsCard(
                selectedDate: _selectedDate,
                selectedStatus: _selectedStatus,
                onDateFilterChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                onStatusFilterChanged: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),
            ),

            // Appointments List
            Expanded(
              child: filteredAppointments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];
                        return AppointmentCard(appointment: appointment);
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/mr/appointments/schedule'),
          backgroundColor: AppColors.primary,
          icon: const Icon(Iconsax.add, color: AppColors.white),
          label: Text(
            'New Appointment',
            style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
          ),
        ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 2),
      ),
    );
  }

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    var filtered = List<Appointment>.from(appointments);

    // Filter by date
    if (_selectedDate != null) {
      filtered = filtered
          .where(
            (appointment) =>
                appointment.date.year == _selectedDate!.year &&
                appointment.date.month == _selectedDate!.month &&
                appointment.date.day == _selectedDate!.day,
          )
          .toList();
    }

    // Filter by status
    if (_selectedStatus != null) {
      filtered = filtered
          .where((appointment) => appointment.status == _selectedStatus)
          .toList();
    }

    // Sort by date (upcoming first, then past)
    filtered.sort((a, b) {
      final now = DateTime.now();
      final aFuture = a.date.isAfter(now);
      final bFuture = b.date.isAfter(now);

      if (aFuture && !bFuture) return -1;
      if (!aFuture && bFuture) return 1;
      if (aFuture && bFuture) return a.date.compareTo(b.date);
      return b.date.compareTo(a.date);
    });

    return filtered;
  }

  Widget _buildEmptyState() {
    final hasActiveFilters = _selectedDate != null || _selectedStatus != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters ? Iconsax.search_status : Iconsax.calendar_1,
              size: 80,
              color: AppColors.quaternary.withAlpha(127),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasActiveFilters
                  ? 'No appointments found'
                  : 'No appointments yet',
              style: AppTypography.h3.copyWith(color: AppColors.quaternary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasActiveFilters
                  ? 'Try adjusting your filters'
                  : 'Schedule your first appointment',
              style: AppTypography.body.copyWith(color: AppColors.quaternary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (!hasActiveFilters)
              ElevatedButton.icon(
                onPressed: () => context.push('/mr/appointments/schedule'),
                style: AppButtonStyles.primaryButton(height: 44),
                icon: const Icon(Iconsax.add, color: AppColors.white),
                label: Text(
                  'Schedule Appointment',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}