import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../provider/appointment_provider.dart';
import '../../provider/doctor_provider.dart';
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
  final _messageController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedDoctorId;
  String? _selectedChamberId;

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.appointmentId != null;
    _selectedDoctorId = widget.initialDoctorId;

    // If editing, load appointment data
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appointment = ref.read(
          appointmentDetailProvider(widget.appointmentId!),
        );
        if (appointment != null) {
          setState(() {
            _selectedDate = appointment.date;
            _selectedTime = TimeOfDay(
              hour: int.parse(appointment.time.split(':')[0].split(' ')[0]),
              minute: int.parse(appointment.time.split(':')[1].split(' ')[0]),
            );
            _selectedDoctorId = appointment.doctorId;
            _selectedChamberId = appointment.chamberId;
            _messageController.text = appointment.message;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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

  void _saveAppointment() {
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
      if (_selectedChamberId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a chamber')),
        );
        return;
      }

      final existingAppointment = _isEditMode
          ? ref.read(appointmentDetailProvider(widget.appointmentId!))
          : null;

      final appointment = Appointment(
        id: widget.appointmentId ?? DateTime.now().toString(),
        doctorId: _selectedDoctorId!,
        chamberId: _selectedChamberId,
        date: _selectedDate!,
        time: _formatTime(_selectedTime!),
        message: _messageController.text.trim(),
        status: existingAppointment?.status ?? AppointmentStatus.scheduled,
        proofImagePath: existingAppointment?.proofImagePath,
      );

      if (_isEditMode) {
        ref.read(appointmentProvider.notifier).updateAppointment(appointment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment updated successfully')),
        );
      } else {
        ref.read(appointmentProvider.notifier).addAppointment(appointment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment scheduled successfully')),
        );
      }

      context.go('/mr/appointments');
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = ref.watch(doctorListProvider);
    final selectedDoctorMatches = doctors
        .where((doctor) => doctor.id == _selectedDoctorId)
        .toList();
    final selectedDoctor = selectedDoctorMatches.isEmpty
        ? null
        : selectedDoctorMatches.first;
    final selectedDoctorChambers = selectedDoctor == null
        ? <DoctorChamber>[]
        : selectedDoctor.chambers;

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
                          _selectedChamberId = null;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Chamber Dropdown Card
              _buildSectionCard(
                title: 'Select Chamber',
                icon: Iconsax.location,
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
                      value: _selectedChamberId,
                      hint: Text(
                        _selectedDoctorId == null
                            ? 'Select doctor first'
                            : 'Choose a chamber',
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
                      items: selectedDoctorChambers.map((
                        DoctorChamber chamber,
                      ) {
                        return DropdownMenuItem<String>(
                          value: chamber.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                chamber.name,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                chamber.address,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.quaternary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: _selectedDoctorId == null
                          ? null
                          : (String? newValue) {
                              setState(() {
                                _selectedChamberId = newValue;
                              });
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Message Card
              _buildSectionCard(
                title: 'Appointment Message',
                icon: Iconsax.message_text,
                child: TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  style: AppTypography.body.copyWith(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter the reason for appointment...',
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
                      return 'Please enter the appointment message';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Save Button
              ElevatedButton(
                onPressed: _saveAppointment,
                style: AppButtonStyles.primaryButton(),
                child: Text(
                  _isEditMode ? 'Update Appointment' : 'Schedule Appointment',
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
