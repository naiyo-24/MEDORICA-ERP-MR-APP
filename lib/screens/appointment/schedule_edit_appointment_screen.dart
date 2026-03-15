import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../models/visual_ads.dart';
import '../../provider/appointment_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../provider/visual_ads_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class ScheduleEditAppointmentScreen extends ConsumerStatefulWidget {
  final String? appointmentId;
  final String? initialDoctorId;

  const ScheduleEditAppointmentScreen({
    super.key,
    this.appointmentId,
    this.initialDoctorId,
  });

  @override
  ConsumerState<ScheduleEditAppointmentScreen> createState() =>
      _ScheduleEditAppointmentScreenState();
}

class _ScheduleEditAppointmentScreenState
    extends ConsumerState<ScheduleEditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedDoctorId;
  AppointmentStatus _selectedStatus = AppointmentStatus.pending;
  final Set<String> _selectedVisualAdIds = <String>{};
  File? _completionProofImage;
  bool _isSubmitting = false;

  bool _isEditMode = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.appointmentId != null;
    _selectedDoctorId = widget.initialDoctorId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adsState = ref.read(visualAdsProvider);
      if (adsState.ads.isEmpty && !adsState.isLoading) {
        ref.read(visualAdsProvider.notifier).loadVisualAds();
      }
    });

    // If editing, load appointment data
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appointment = ref.read(
          appointmentDetailProvider(widget.appointmentId!),
        );
        if (appointment != null) {
          setState(() {
            _selectedDate = appointment.date;
            _selectedTime = _parseTimeOfDay(appointment.time);
            _selectedDoctorId = appointment.doctorId;
            _selectedStatus = appointment.status;
            _placeController.text = appointment.message;
            _selectedVisualAdIds
              ..clear()
              ..addAll(appointment.visualAds.map((ad) => ad.id));
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTimeOfDay(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return TimeOfDay.now();
    }

    // Normalize all unicode/regular spaces so strings like "6:30 PM" and
    // "6:30 PM" (narrow no-break space) are parsed consistently.
    final normalized = trimmed.replaceAll(RegExp(r'\s+'), ' ');

    final meridiemMatch = RegExp(
      r'^(\d{1,2}):(\d{2})\s*([AaPp][Mm])$',
    ).firstMatch(normalized);
    if (meridiemMatch != null) {
      final rawHour = int.tryParse(meridiemMatch.group(1) ?? '') ?? 0;
      final minute = int.tryParse(meridiemMatch.group(2) ?? '') ?? 0;
      final marker = (meridiemMatch.group(3) ?? '').toUpperCase();

      var hour = rawHour % 12;
      if (marker == 'PM') {
        hour += 12;
      }

      return TimeOfDay(hour: hour, minute: minute.clamp(0, 59));
    }

    final twentyFourMatch = RegExp(
      r'^(\d{1,2}):(\d{2})$',
    ).firstMatch(normalized);
    if (twentyFourMatch != null) {
      final hour = (int.tryParse(twentyFourMatch.group(1) ?? '') ?? 0).clamp(
        0,
        23,
      );
      final minute = (int.tryParse(twentyFourMatch.group(2) ?? '') ?? 0).clamp(
        0,
        59,
      );
      return TimeOfDay(hour: hour, minute: minute);
    }

    return TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickCompletionProofImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _completionProofImage = File(picked.path);
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not pick completion proof image'),
          ),
        );
      }
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a date')));
        return;
      }
      if (_selectedTime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a time')));
        return;
      }
      if (_selectedDoctorId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a doctor')));
        return;
      }

      if (_selectedVisualAdIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one visual ad')),
        );
        return;
      }

      final mrId = ref.read(authNotifierProvider).mr?.mrId;
      if (mrId == null || mrId.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not authenticated. Please log in again.'),
          ),
        );
        return;
      }

      final existing = _isEditMode
          ? ref.read(appointmentDetailProvider(widget.appointmentId!))
          : null;

      final requiresProof = _selectedStatus == AppointmentStatus.completed;
      final hasExistingProof =
          existing?.completionPhotoProof != null &&
          existing!.completionPhotoProof!.trim().isNotEmpty;
      if (requiresProof && _completionProofImage == null && !hasExistingProof) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Completion proof photo is required for completed status',
            ),
          ),
        );
        return;
      }

      final allAds = ref.read(visualAdsProvider).ads;
      final selectedVisualAds = allAds
          .where((ad) => _selectedVisualAdIds.contains(ad.id.toString()))
          .map(
            (ad) => AppointmentVisualAd(
              id: ad.id.toString(),
              medicineName: ad.medicineName,
            ),
          )
          .toList();

      final appointment = Appointment(
        id: widget.appointmentId ?? '',
        mrId: mrId,
        doctorId: _selectedDoctorId!,
        date: _selectedDate!,
        time: _formatTime(_selectedTime!),
        message: _placeController.text.trim(),
        status: _selectedStatus,
        completionPhotoProof: existing?.completionPhotoProof,
        visualAds: selectedVisualAds,
      );

      setState(() => _isSubmitting = true);

      try {
        if (_isEditMode) {
          await ref
              .read(appointmentNotifierProvider.notifier)
              .updateAppointment(
                mrId: mrId,
                appointment: appointment,
                completionPhotoProofPath: _completionProofImage?.path,
              );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment updated successfully')),
          );
        } else {
          await ref
              .read(appointmentNotifierProvider.notifier)
              .addAppointment(
                mrId: mrId,
                appointment: appointment,
                completionPhotoProofPath: _completionProofImage?.path,
              );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment scheduled successfully')),
          );
        }

        context.go('/asm/appointments');
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorsState = ref.watch(doctorProvider);
    final doctors = doctorsState.doctors;
    final visualAdsState = ref.watch(visualAdsProvider);
    final visualAds = visualAdsState.ads;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: _isEditMode ? 'Edit Appointment' : 'Schedule Appointment',
        subtitleText: _isEditMode ? 'Update Details' : 'Book an Appointment',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker Card
              _buildSectionCard(
                title: 'Appointment Date',
                icon: Iconsax.calendar,
                child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: AppBorderRadius.mdRadius,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface200,
                      borderRadius: AppBorderRadius.mdRadius,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : DateFormat(
                                  'EEEE, MMM dd, yyyy',
                                ).format(_selectedDate!),
                          style: AppTypography.body.copyWith(
                            color: _selectedDate == null
                                ? AppColors.quaternary
                                : AppColors.black,
                          ),
                        ),
                        const Icon(Iconsax.calendar, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Time Picker Card
              _buildSectionCard(
                title: 'Appointment Time',
                icon: Iconsax.clock,
                child: InkWell(
                  onTap: () => _selectTime(context),
                  borderRadius: AppBorderRadius.mdRadius,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface200,
                      borderRadius: AppBorderRadius.mdRadius,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime == null
                              ? 'Select Time'
                              : _formatTime(_selectedTime!),
                          style: AppTypography.body.copyWith(
                            color: _selectedTime == null
                                ? AppColors.quaternary
                                : AppColors.black,
                          ),
                        ),
                        const Icon(Iconsax.clock, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Doctor Dropdown Card
              _buildSectionCard(
                title: 'Select Doctor',
                icon: Iconsax.user,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface200,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDoctorId,
                      hint: Text(
                        'Choose a doctor',
                        style: AppTypography.body.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                      isExpanded: true,
                      icon: const Icon(
                        Iconsax.arrow_down_1,
                        color: AppColors.primary,
                      ),
                      style: AppTypography.body.copyWith(
                        color: AppColors.black,
                      ),
                      items: doctors.map((Doctor doctor) {
                        return DropdownMenuItem<String>(
                          value: doctor.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                doctor.name,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                doctor.specialization,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.quaternary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDoctorId = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Status Dropdown Card
              _buildSectionCard(
                title: 'Appointment Status',
                icon: Iconsax.status,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface200,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AppointmentStatus>(
                      value: _selectedStatus,
                      isExpanded: true,
                      icon: const Icon(
                        Iconsax.arrow_down_1,
                        color: AppColors.primary,
                      ),
                      style: AppTypography.body.copyWith(
                        color: AppColors.black,
                      ),
                      items: AppointmentStatus.values.map((
                        AppointmentStatus status,
                      ) {
                        return DropdownMenuItem<AppointmentStatus>(
                          value: status,
                          child: Text(
                            status.displayName,
                            style: AppTypography.body.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (AppointmentStatus? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Place Card
              _buildSectionCard(
                title: 'Appointment Place',
                icon: Iconsax.message_text,
                child: TextFormField(
                  controller: _placeController,
                  maxLines: 2,
                  style: AppTypography.body.copyWith(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter appointment place...',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.quaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.surface200,
                    border: OutlineInputBorder(
                      borderRadius: AppBorderRadius.mdRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppBorderRadius.mdRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppBorderRadius.mdRadius,
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter appointment place';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Visual Ads Selection Card
              _buildSectionCard(
                title: 'Select Visual Ads',
                icon: Iconsax.image,
                child: visualAdsState.isLoading && visualAds.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : visualAds.isEmpty
                    ? Text(
                        'No visual ads available',
                        style: AppTypography.body.copyWith(
                          color: AppColors.quaternary,
                        ),
                      )
                    : Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: visualAds.map((VisualAd ad) {
                          final adId = ad.id.toString();
                          final selected = _selectedVisualAdIds.contains(adId);
                          return FilterChip(
                            label: Text(ad.medicineName),
                            selected: selected,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedVisualAdIds.add(adId);
                                } else {
                                  _selectedVisualAdIds.remove(adId);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Completion Proof Card
              if (_selectedStatus == AppointmentStatus.completed)
                _buildSectionCard(
                  title: 'Completion Proof Photo',
                  icon: Iconsax.camera,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickCompletionProofImage,
                        style: AppButtonStyles.primaryButton(height: 42),
                        icon: const Icon(
                          Iconsax.camera,
                          color: AppColors.white,
                          size: 18,
                        ),
                        label: Text(
                          _completionProofImage == null
                              ? 'Capture Proof Photo'
                              : 'Recapture Proof Photo',
                          style: AppTypography.buttonMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_completionProofImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.md,
                          ),
                          child: Image.file(
                            _completionProofImage!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (_isEditMode)
                        Text(
                          'Keep existing proof photo or upload a new one.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                    ],
                  ),
                ),
              if (_selectedStatus == AppointmentStatus.completed)
                const SizedBox(height: AppSpacing.xxl),
              const SizedBox(height: AppSpacing.xxl),

              // Save Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _saveAppointment,
                style: AppButtonStyles.primaryButton(),
                child: Text(
                  _isSubmitting
                      ? 'Saving...'
                      : _isEditMode
                      ? 'Update Appointment'
                      : 'Schedule Appointment',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderRadius.lgRadius,
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
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.tagline.copyWith(color: AppColors.black),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}