import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor.dart';
import '../../provider/doctor_provider.dart';
import '../../theme/app_theme.dart';

class ChemistShopDoctorsCard extends ConsumerWidget {
  final List<String> doctorIds;

  const ChemistShopDoctorsCard({super.key, required this.doctorIds});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDoctors = ref.watch(doctorProvider);
    final doctors = allDoctors
        .where((doctor) => doctorIds.contains(doctor.id))
        .toList();

    if (doctors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: const Icon(
                  Iconsax.hospital,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Consulting Doctors',
                style: AppTypography.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Doctors List
          ...doctors.map((doctor) => _DoctorListItem(
                doctor: doctor,
                onCallPressed: () => _makePhoneCall(doctor.phoneNumber),
              )),
        ],
      ),
    );
  }
}

class _DoctorListItem extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onCallPressed;

  const _DoctorListItem({
    required this.doctor,
    required this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Doctor Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: doctor.photo.startsWith('http')
                ? NetworkImage(doctor.photo)
                : null,
            child: !doctor.photo.startsWith('http')
                ? const Icon(
                    Iconsax.user,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  doctor.specialization,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.quaternary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Iconsax.call,
                      size: 14,
                      color: AppColors.quaternary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      doctor.phoneNumber,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Call Button
          IconButton(
            onPressed: onCallPressed,
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: const Icon(
                Iconsax.call,
                color: AppColors.success,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
