import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../provider/appointment_provider.dart';
import '../../provider/auth_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class AppointmentDetailsBottomSheet extends ConsumerWidget {
  final Appointment appointment;
  final Doctor doctor;

  const AppointmentDetailsBottomSheet({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return AppColors.primary;
      case AppointmentStatus.ongoing:
        return const Color(0xFF1565C0);
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  Text(
                    'Appointment Details',
                    style: AppTypography.h3.copyWith(color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Iconsax.close_circle,
                      color: AppColors.quaternary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status).withAlpha(25),
                  borderRadius: AppBorderRadius.mdRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.status,
                      color: _getStatusColor(appointment.status),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      appointment.status.displayName,
                      style: AppTypography.tagline.copyWith(
                        color: _getStatusColor(appointment.status),
                      ),
                    ),
                  ],
                ),
              ),
                const SizedBox(height: AppSpacing.md),
                // Status Update Dropdown
                _StatusUpdateSection(
                  currentStatus: appointment.status,
                  onStatusChanged: (newStatus) async {
                    final mrId = ref.read(authNotifierProvider).mr?.mrId;
                    if (mrId == null || mrId.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unable to update status: MR ID missing.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    final updatedAppointment = appointment.copyWith(status: newStatus);
                    await ref.read(appointmentNotifierProvider.notifier).updateAppointment(
                      mrId: mrId,
                      appointment: updatedAppointment,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appointment status updated.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              const SizedBox(height: AppSpacing.xl),

              // Doctor Information
              _buildInfoSection(
                icon: Iconsax.user,
                title: 'Doctor',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      doctor.specialization,
                      style: AppTypography.body.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: AppSpacing.xl),

              // Date Information
              _buildInfoSection(
                icon: Iconsax.calendar,
                title: 'Date',
                content: Text(
                  DateFormat('EEEE, MMMM dd, yyyy').format(appointment.date),
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
              const Divider(height: AppSpacing.xl),

              // Time Information
              _buildInfoSection(
                icon: Iconsax.clock,
                title: 'Time',
                content: Text(
                  appointment.time,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
              const Divider(height: AppSpacing.xl),

              // Place
              _buildInfoSection(
                icon: Iconsax.message_text,
                title: 'Appointment Place',
                content: Text(
                  appointment.message,
                  style: AppTypography.body.copyWith(color: AppColors.black),
                ),
              ),
              if (appointment.visualAds.isNotEmpty) ...[
                const Divider(height: AppSpacing.xl),
                _buildInfoSection(
                  icon: Iconsax.image,
                  title: 'Visual Ads',
                  content: Text(
                    appointment.visualAds
                        .map((ad) => ad.medicineName)
                        .join(', '),
                    style: AppTypography.body.copyWith(color: AppColors.black),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),

              if (appointment.status == AppointmentStatus.ongoing &&
                  appointment.visualAds.isNotEmpty) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    final encodedIds = appointment.visualAds
                        .map((ad) => ad.id)
                        .join(',');
                    Navigator.of(context).pop();
                    context.push('${AppRouter.visualAds}?adIds=$encodedIds');
                  },
                  style: AppButtonStyles.primaryButton(height: 46),
                  icon: const Icon(Iconsax.play, color: AppColors.white),
                  label: Text(
                    'Present Visual Ads Now',
                    style: AppTypography.buttonMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showDeleteDialog(context, ref);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.mdRadius,
                        ),
                      ),
                      icon: const Icon(Iconsax.trash, size: 20),
                      label: Text(
                        'Delete',
                        style: AppTypography.buttonMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push(
                          '/asm/appointments/edit/${appointment.id}',
                          extra: appointment,
                        );
                      },
                      style: AppButtonStyles.primaryButton(height: 44),
                      icon: const Icon(
                        Iconsax.edit,
                        color: AppColors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Edit',
                        style: AppTypography.buttonMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppBorderRadius.smRadius,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              content,
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.lgRadius),
        title: Text(
          'Delete Appointment',
          style: AppTypography.tagline.copyWith(color: AppColors.black),
        ),
        content: Text(
          'Are you sure you want to delete this appointment?',
          style: AppTypography.body.copyWith(color: AppColors.quaternary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.quaternary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.mdRadius,
              ),
            ),
            onPressed: () {
              final mrId = ref.read(authNotifierProvider).mr?.mrId;
              if (mrId == null || mrId.trim().isEmpty) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please login again.')),
                );
                return;
              }

              ref
                  .read(appointmentNotifierProvider.notifier)
                  .deleteAppointment(
                    mrId: mrId,
                    appointmentId: appointment.id,
                  )
                  .then((_) {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appointment deleted successfully'),
                      ),
                    );
                  })
                  .catchError((error) {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString().replaceFirst('Exception: ', ''),
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  });
            },
            child: Text(
              'Delete',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusUpdateSection extends StatefulWidget {
  final AppointmentStatus currentStatus;
  final ValueChanged<AppointmentStatus> onStatusChanged;

  const _StatusUpdateSection({
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  State<_StatusUpdateSection> createState() => _StatusUpdateSectionState();
}

class _StatusUpdateSectionState extends State<_StatusUpdateSection> {
  late AppointmentStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Status',
          style: AppTypography.caption.copyWith(
            color: AppColors.quaternary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<AppointmentStatus>(
          initialValue: _selectedStatus,
          decoration: InputDecoration(
            labelText: 'Select Status',
            labelStyle: AppTypography.body.copyWith(color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          style: AppTypography.body.copyWith(color: AppColors.black),
          dropdownColor: AppColors.surface,
          items: AppointmentStatus.values.map((status) {
            return DropdownMenuItem<AppointmentStatus>(
              value: status,
              child: Text(status.displayName, style: AppTypography.body),
            );
          }).toList(),
          onChanged: (newStatus) {
            if (newStatus != null && newStatus != _selectedStatus) {
              setState(() {
                _selectedStatus = newStatus;
              });
              widget.onStatusChanged(newStatus);
            }
          },
        ),
      ],
    );
  }
}