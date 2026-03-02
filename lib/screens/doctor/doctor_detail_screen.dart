import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';
import '../../models/doctor.dart';
import '../../provider/doctor_provider.dart';
import '../../cards/doctor/doctor_header_card.dart';
import '../../cards/doctor/doctor_experience_card.dart';
import '../../cards/doctor/doctor_specialization_card.dart';
import '../../cards/doctor/doctor_qualification_card.dart';
import '../../cards/doctor/doctor_description_card.dart';
import '../../cards/doctor/doctor_contact_card.dart';
import '../../cards/doctor/doctor_chambers_card.dart';


class DoctorDetailScreen extends ConsumerWidget {
  final String doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorDetailProvider(doctorId));

    return doctorAsync == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_circle_left,
                    color: AppColors.primary),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: Text('Doctor not found'),
            ),
          )
        : _buildDoctorDetail(context, ref, doctorAsync);
  }

  Widget _buildDoctorDetail(
    BuildContext context,
    WidgetRef ref,
    Doctor doctor,
  ) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Iconsax.arrow_circle_left, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit, color: AppColors.primary),
            onPressed: () =>
                context.go('/mr/doctor/edit/${doctor.id}', extra: doctor),
          ),
          IconButton(
            icon: const Icon(Iconsax.trash, color: AppColors.error),
            onPressed: () => _showDeleteDialog(context, ref, doctor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/mr/appointments/schedule?doctorId=${doctor.id}');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.calendar, color: AppColors.white),
        label: Text(
          'Book Appointment',
          style: AppTypography.buttonMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Doctor Header Card
            DoctorHeaderCard(doctor: doctor),
            const SizedBox(height: AppSpacing.lg),

            // Experience and Specialization Side by Side
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: DoctorExperienceCard(experience: doctor.experience),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DoctorSpecializationCard(
                      specialization: doctor.specialization,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Qualification
            DoctorQualificationCard(qualification: doctor.qualification),
            const SizedBox(height: AppSpacing.lg),

            // Description
            DoctorDescriptionCard(description: doctor.description),
            const SizedBox(height: AppSpacing.lg),

            // Contact Information
            DoctorContactCard(
              phoneNumber: doctor.phoneNumber,
              email: doctor.email,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Chambers
            DoctorChambersCard(chambers: doctor.chambers),
            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Doctor doctor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Doctor'),
        content: Text('Are you sure you want to delete ${doctor.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              ref.read(doctorProvider.notifier).deleteDoctor(doctor.id);
              Navigator.of(context).pop();
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Doctor deleted successfully'),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}