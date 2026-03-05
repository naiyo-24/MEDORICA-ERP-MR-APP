import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../provider/appointment_provider.dart';
import '../../theme/app_theme.dart';

class AppointmentDetailsBottomSheet extends ConsumerStatefulWidget {
  final Appointment appointment;
  final Doctor doctor;

  const AppointmentDetailsBottomSheet({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  @override
  ConsumerState<AppointmentDetailsBottomSheet> createState() =>
      _AppointmentDetailsBottomSheetState();
}

class _AppointmentDetailsBottomSheetState
    extends ConsumerState<AppointmentDetailsBottomSheet> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return AppColors.primary;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.missed:
        return AppColors.quaternary;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _markAsCompleted() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a selfie with proof of visit'),
        ),
      );
      return;
    }

    ref.read(appointmentProvider.notifier).markAppointmentAsCompleted(
          widget.appointment.id,
          _selectedImage!.path,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment marked as completed successfully'),
      ),
    );

    Navigator.of(context).pop();
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.lgRadius,
        ),
        title: Text(
          'Cancel Appointment',
          style: AppTypography.tagline.copyWith(color: AppColors.black),
        ),
        content: Text(
          'Are you sure you want to cancel this appointment?',
          style: AppTypography.body.copyWith(color: AppColors.quaternary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Keep',
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
              ref.read(appointmentProvider.notifier).cancelAppointment(
                    widget.appointment.id,
                  );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment cancelled successfully'),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMapsForAddress(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
    );

    if (!await launchUrl(mapsUri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final proofImage = _selectedImage != null
        ? File(_selectedImage!.path)
        : (widget.appointment.proofImagePath != null
            ? File(widget.appointment.proofImagePath!)
            : null);
    final selectedChamber = widget.doctor.chambers.where((chamber) {
      return chamber.id == widget.appointment.chamberId;
    }).toList();
    final appointmentChamber =
        selectedChamber.isNotEmpty ? selectedChamber.first : null;

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
                    icon: const Icon(Iconsax.close_circle,
                        color: AppColors.quaternary),
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
                  color: _getStatusColor(widget.appointment.status).withAlpha(25),
                  borderRadius: AppBorderRadius.mdRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.status,
                      color: _getStatusColor(widget.appointment.status),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      widget.appointment.status.displayName,
                      style: AppTypography.tagline.copyWith(
                        color: _getStatusColor(widget.appointment.status),
                      ),
                    ),
                  ],
                ),
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
                      widget.doctor.name,
                      style:
                          AppTypography.bodyLarge.copyWith(color: AppColors.black),
                    ),
                    Text(
                      widget.doctor.specialization,
                      style: AppTypography.body
                          .copyWith(color: AppColors.quaternary),
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
                  DateFormat('EEEE, MMMM dd, yyyy').format(widget.appointment.date),
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.black),
                ),
              ),
              const Divider(height: AppSpacing.xl),

              // Time Information
              _buildInfoSection(
                icon: Iconsax.clock,
                title: 'Time',
                content: Text(
                  widget.appointment.time,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.black),
                ),
              ),
              const Divider(height: AppSpacing.xl),

              // Chamber Information
              _buildInfoSection(
                icon: Iconsax.location,
                title: 'Chamber',
                content: appointmentChamber == null
                    ? Text(
                        'Not selected',
                        style: AppTypography.body.copyWith(
                          color: AppColors.quaternary,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointmentChamber.name,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            appointmentChamber.address,
                            style: AppTypography.body.copyWith(
                              color: AppColors.quaternary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _openMapsForAddress(appointmentChamber.address),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                              ),
                            ),
                            icon: const Icon(Iconsax.map, size: 18),
                            label: Text(
                              'Get Directions',
                              style: AppTypography.buttonMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const Divider(height: AppSpacing.xl),

              // Message/Reason
              _buildInfoSection(
                icon: Iconsax.message_text,
                title: 'Appointment Reason',
                content: Text(
                  widget.appointment.message,
                  style: AppTypography.body.copyWith(color: AppColors.black),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Proof Image Section (only show for scheduled appointments)
              if (widget.appointment.status == AppointmentStatus.scheduled) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proof of Visit',
                        style: AppTypography.tagline.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Upload a selfie with proof of doctor/chamber visit',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (_selectedImage != null || proofImage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: AppBorderRadius.mdRadius,
                              child: Image.file(
                                _selectedImage ?? proofImage!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        ),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                            horizontal: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.mdRadius,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                        icon: const Icon(Iconsax.camera, size: 20),
                        label: Text(
                          _selectedImage != null || proofImage != null
                              ? 'Change Image'
                              : 'Upload Selfie',
                          style: AppTypography.buttonMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ] else if (widget.appointment.status == AppointmentStatus.completed &&
                  proofImage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(25),
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proof of Visit',
                        style: AppTypography.tagline.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ClipRRect(
                        borderRadius: AppBorderRadius.mdRadius,
                        child: Image.file(
                          proofImage,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // Action Buttons
              if (widget.appointment.status == AppointmentStatus.scheduled) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _markAsCompleted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.mdRadius,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        icon: const Icon(Iconsax.tick_circle, color: AppColors.white, size: 20),
                        label: Text(
                          'Completed',
                          style: AppTypography.buttonMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showCancelConfirmation,
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
                        icon: const Icon(Iconsax.close_circle, color: AppColors.error, size: 20),
                        label: Text(
                          'Cancel',
                          style: AppTypography.buttonMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push(
                          '/mr/appointments/edit/${widget.appointment.id}',
                          extra: widget.appointment,
                        );
                      },
                      style: AppButtonStyles.primaryButton(height: 44),
                      icon: const Icon(Iconsax.edit, color: AppColors.white, size: 20),
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
}
