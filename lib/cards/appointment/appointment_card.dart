import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../provider/doctor_provider.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';
import 'appointment_details_bottomsheet.dart';

class AppointmentCard extends ConsumerWidget {
    String getDoctorPhotoUrl(String photo) {
      if (photo.trim().isEmpty) return '';
      if (photo.startsWith('http://') || photo.startsWith('https://')) return photo;
      // Ensure a slash between baseUrl and photo path
      final base = ApiUrl.baseUrl;
      if (photo.startsWith('/')) {
        return base + photo;
      } else {
        return '$base/$photo';
      }
    }
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

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
    final doctor = ref.watch(doctorDetailProvider(appointment.doctorId));

    if (doctor == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shadowColor: AppColors.shadowColor,
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.lgRadius),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => _showAppointmentDetails(context, appointment, doctor),
        borderRadius: AppBorderRadius.lgRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Row
              Row(
                children: [
                  // Doctor Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: doctor.photo.trim().isNotEmpty
                        ? NetworkImage(getDoctorPhotoUrl(doctor.photo))
                        : null,
                    child: doctor.photo.trim().isEmpty
                        ? const Icon(Iconsax.user, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Doctor Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doctor.specialization,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status).withAlpha(25),
                      borderRadius: AppBorderRadius.smRadius,
                    ),
                    child: Text(
                      appointment.status.displayName,
                      style: AppTypography.caption.copyWith(
                        color: _getStatusColor(appointment.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Divider
              const Divider(color: AppColors.divider),
              const SizedBox(height: AppSpacing.md),

              // Date and Time Row
              Row(
                children: [
                  // Date
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.calendar,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          DateFormat('MMM dd, yyyy').format(appointment.date),
                          style: AppTypography.body.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Time
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.clock,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          appointment.time,
                          style: AppTypography.body.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (appointment.message.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.message_text,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        appointment.message,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(
    BuildContext context,
    Appointment appointment,
    Doctor doctor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentDetailsBottomSheet(
        appointment: appointment,
        doctor: doctor,
      ),
    );
  }
}