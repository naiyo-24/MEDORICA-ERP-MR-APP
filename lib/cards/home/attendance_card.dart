import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../provider/attendance_provider.dart';

class MRAttendanceCard extends ConsumerWidget {
  const MRAttendanceCard({super.key});

  String _formatTime(DateTime? t) {
    if (t == null) return '-';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<XFile?> _takeSelfie() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75,
      );
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(todaysAttendanceProvider);
    final notifier = ref.read(attendanceNotifierProvider.notifier);

    return Card(
        color: AppColors.surface200,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.mdRadius),
        elevation: AppElevation.xs,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Attendance', style: AppTypography.h3.copyWith(color: AppColors.primary)),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: AppCardStyles.styleCard(backgroundColor: AppColors.surface),
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(AppSpacing.sm),
                                      decoration: AppCardStyles.minimalCard(backgroundColor: AppColors.primaryLight),
                                      child: Icon(Icons.info_outline, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(child: Text('How attendance works', style: AppTypography.h3.copyWith(color: AppColors.primary))),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text('• A selfie is taken using your front camera.', style: AppTypography.body.copyWith(color: AppColors.quaternary)),
                                const SizedBox(height: AppSpacing.sm),
                                Text('• Each selfie is saved with a timestamp and attached to your attendance record.', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
                                const SizedBox(height: AppSpacing.sm),
                                Text('• Photos are used only for verification and may be retained according to company policy.', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
                                const SizedBox(height: AppSpacing.sm),
                                Text('• You must check out with a selfie to complete the day\'s record.', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
                                const SizedBox(height: AppSpacing.lg),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: AppCardStyles.minimalCard(backgroundColor: AppColors.primaryLight),
                      child: Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                    ),
                  ),
                  const Spacer(),
                  if (attendance != null && attendance.isCheckedIn)
                    Text('Checked in at ${_formatTime(attendance.checkIn)}', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary))
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We capture a timestamped selfie as proof of your visit. The photo and time are stored securely and used by your organization for verification.',
                style: AppTypography.description.copyWith(color: AppColors.quaternary),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (attendance == null || !attendance.isCheckedIn) ...[
                ElevatedButton.icon(
                  style: AppButtonStyles.primaryButton(),
                  onPressed: () async {
                    final file = await _takeSelfie();
                    if (file == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selfie required to Check In.')));
                      return;
                    }
                    notifier.checkIn(photoPath: file.path);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked in successfully.')));
                  },
                  icon: const Icon(Iconsax.camera),
                  label: const Text('Check In Now!'),
                ),
              ] else if (attendance.isCheckedIn && !attendance.isCheckedOut) ...[
                if (attendance.checkInPhotoPath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: AppBorderRadius.mdRadius,
                          child: Image.file(File(attendance.checkInPhotoPath!), width: double.infinity, height: 160, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Selfie captured at ${_formatTime(attendance.checkIn)}', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
                      ],
                    ),
                  ),

                
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.white,
                      elevation: AppElevation.sm,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.lgRadius),
                    ),
                    onPressed: () async {
                      final file = await _takeSelfie();
                      if (file == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selfie required to Check Out.')));
                        return;
                      }
                      notifier.checkOut(photoPath: file.path);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked out successfully.')));
                    },
                    icon: const Icon(Iconsax.camera),
                    label: const Text('Check Out...'),
                  ),
              ] else ...[
                Text('You have checked out for today at ${_formatTime(attendance.checkOut)}.', style: AppTypography.body),
                const SizedBox(height: AppSpacing.sm),
                if (attendance.checkOutPhotoPath != null)
                  ClipRRect(
                    borderRadius: AppBorderRadius.mdRadius,
                    child: Image.file(File(attendance.checkOutPhotoPath!), width: double.infinity, height: 160, fit: BoxFit.cover),
                  ),
              ],
            ],
          ),
        ),
    );
  }
}