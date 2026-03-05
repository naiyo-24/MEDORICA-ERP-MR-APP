import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/gift.dart';
import '../../theme/app_theme.dart';

class GiftFilterCard extends StatefulWidget {
  final Function(DateTime?) onDateFilterChanged;
  final Function(String?) onDoctorFilterChanged;
  final Function(GiftStatus?) onStatusFilterChanged;
  final DateTime? selectedDate;
  final String? selectedDoctorId;
  final GiftStatus? selectedStatus;
  final List<String> doctorNames;

  const GiftFilterCard({
    super.key,
    required this.onDateFilterChanged,
    required this.onDoctorFilterChanged,
    required this.onStatusFilterChanged,
    this.selectedDate,
    this.selectedDoctorId,
    this.selectedStatus,
    required this.doctorNames,
  });

  @override
  State<GiftFilterCard> createState() => _GiftFilterCardState();
}

class _GiftFilterCardState extends State<GiftFilterCard> {
  DateTime? _selectedDate;
  String? _selectedDoctorId;
  GiftStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _selectedDoctorId = widget.selectedDoctorId;
    _selectedStatus = widget.selectedStatus;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateFilterChanged(picked);
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
    });
    widget.onDateFilterChanged(null);
  }

  void _clearDoctorFilter() {
    setState(() {
      _selectedDoctorId = null;
    });
    widget.onDoctorFilterChanged(null);
  }

  void _clearStatusFilter() {
    setState(() {
      _selectedStatus = null;
    });
    widget.onStatusFilterChanged(null);
  }

  void _clearAllFilters() {
    setState(() {
      _selectedDate = null;
      _selectedDoctorId = null;
      _selectedStatus = null;
    });
    widget.onDateFilterChanged(null);
    widget.onDoctorFilterChanged(null);
    widget.onStatusFilterChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters =
        _selectedDate != null || _selectedDoctorId != null || _selectedStatus != null;

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
          // Header with Clear All button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Iconsax.filter, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Filter Gifts',
                      style: AppTypography.tagline.copyWith(color: AppColors.black),
                    ),
                  ],
                ),
              ),
              if (hasActiveFilters)
                GestureDetector(
                  onTap: _clearAllFilters,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      'Clear All',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Filter Options Row
          Row(
            children: [
              // Date Filter
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: AppBorderRadius.mdRadius,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: _selectedDate != null
                          ? AppColors.primaryLight
                          : AppColors.surface200,
                      borderRadius: AppBorderRadius.mdRadius,
                      border: Border.all(
                        color: _selectedDate != null
                            ? AppColors.primary
                            : AppColors.border,
                        width: _selectedDate != null ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Iconsax.calendar, size: 16, color: AppColors.primary),
                            if (_selectedDate != null)
                              GestureDetector(
                                onTap: _clearDateFilter,
                                child: const Icon(Iconsax.close_circle,
                                    size: 16, color: AppColors.primary),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _selectedDate != null
                              ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                              : 'Select Date',
                          style: AppTypography.bodySmall.copyWith(
                            color: _selectedDate != null
                                ? AppColors.black
                                : AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Doctor Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _selectedDoctorId != null
                        ? AppColors.primaryLight
                        : AppColors.surface200,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(
                      color: _selectedDoctorId != null
                          ? AppColors.primary
                          : AppColors.border,
                      width: _selectedDoctorId != null ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Iconsax.user, size: 16, color: AppColors.primary),
                          if (_selectedDoctorId != null)
                            GestureDetector(
                              onTap: _clearDoctorFilter,
                              child: const Icon(Iconsax.close_circle,
                                  size: 16, color: AppColors.primary),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      PopupMenuButton<String>(
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.mdRadius,
                        ),
                        child: Text(
                          _selectedDoctorId != null ? _selectedDoctorId! : 'Doctor',
                          style: AppTypography.bodySmall.copyWith(
                            color: _selectedDoctorId != null
                                ? AppColors.black
                                : AppColors.quaternary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        itemBuilder: (context) {
                          return widget.doctorNames.map((doctor) {
                            return PopupMenuItem<String>(
                              value: doctor,
                              child: Text(doctor),
                            );
                          }).toList();
                        },
                        onSelected: (String doctor) {
                          setState(() {
                            _selectedDoctorId = doctor;
                          });
                          widget.onDoctorFilterChanged(doctor);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Status Filter
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: _selectedStatus != null
                  ? AppColors.primaryLight
                  : AppColors.surface200,
              borderRadius: AppBorderRadius.mdRadius,
              border: Border.all(
                color: _selectedStatus != null
                    ? AppColors.primary
                    : AppColors.border,
                width: _selectedStatus != null ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Iconsax.status, size: 16, color: AppColors.primary),
                    if (_selectedStatus != null)
                      GestureDetector(
                        onTap: _clearStatusFilter,
                        child: const Icon(Iconsax.close_circle,
                            size: 16, color: AppColors.primary),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                PopupMenuButton<GiftStatus>(
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.mdRadius,
                  ),
                  child: Text(
                    _selectedStatus != null
                        ? _selectedStatus!.displayName
                        : 'Status',
                    style: AppTypography.bodySmall.copyWith(
                      color: _selectedStatus != null
                          ? AppColors.black
                          : AppColors.quaternary,
                    ),
                  ),
                  itemBuilder: (context) {
                    return GiftStatus.values.map((status) {
                      return PopupMenuItem<GiftStatus>(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList();
                  },
                  onSelected: (GiftStatus status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                    widget.onStatusFilterChanged(status);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
