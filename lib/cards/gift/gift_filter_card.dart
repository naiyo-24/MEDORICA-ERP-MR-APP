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
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: isDarkMode ? Colors.black : Colors.white,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hasActiveFilters =
        _selectedDate != null ||
        _selectedDoctorId != null ||
        _selectedStatus != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
                    Icon(
                      Iconsax.filter,
                      color: colorScheme.onSurface,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Filter Gifts',
                      style: AppTypography.tagline.copyWith(
                        color: colorScheme.onSurface,
                      ),
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
                        color: colorScheme.onSurface,
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
                      color: isDarkMode
                          ? AppColors.darkSurface300
                          : (_selectedDate != null
                                ? AppColors.primaryLight
                                : AppColors.surface200),
                      borderRadius: AppBorderRadius.mdRadius,
                      border: Border.all(
                        color: colorScheme.onSurface,
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
                            Icon(
                              Iconsax.calendar,
                              size: 16,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.primary,
                            ),
                            if (_selectedDate != null)
                              GestureDetector(
                                onTap: _clearDateFilter,
                                child: Icon(
                                  Iconsax.close_circle,
                                  size: 16,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _selectedDate != null
                              ? DateFormat(
                                  'MMM dd, yyyy',
                                ).format(_selectedDate!)
                              : 'Select Date',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Doctor Filter
              // Doctor Filter
              Expanded(
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.mdRadius,
                  ),
                  onSelected: (String doctor) {
                    setState(() {
                      _selectedDoctorId = doctor;
                    });
                    widget.onDoctorFilterChanged(doctor);
                  },
                  itemBuilder: (context) {
                    return widget.doctorNames.map((doctor) {
                      return PopupMenuItem<String>(
                        value: doctor,
                        child: Text(doctor),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkSurface300
                          : (_selectedDate != null
                                ? AppColors.primaryLight
                                : AppColors.surface200),
                      borderRadius: AppBorderRadius.mdRadius,
                      border: Border.all(
                        color: colorScheme.onSurface,
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
                            Icon(
                              Iconsax.user,
                              size: 16,
                              color: colorScheme.onSurface,
                            ),
                            if (_selectedDoctorId != null)
                              GestureDetector(
                                onTap: _clearDoctorFilter,
                                child: Icon(
                                  Iconsax.close_circle,
                                  size: 16,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _selectedDoctorId ?? 'Doctor',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Status Filter
          // Status Filter
          PopupMenuButton<GiftStatus>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.mdRadius,
            ),
            onSelected: (GiftStatus status) {
              setState(() {
                _selectedStatus = status;
              });
              widget.onStatusFilterChanged(status);
            },
            itemBuilder: (context) {
              return GiftStatus.values.map((status) {
                return PopupMenuItem<GiftStatus>(
                  value: status,
                  child: Text(status.displayName),
                );
              }).toList();
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkSurface300
                    : (_selectedDate != null
                          ? AppColors.primaryLight
                          : AppColors.surface200),
                borderRadius: AppBorderRadius.mdRadius,
                border: Border.all(
                  color: colorScheme.onSurface,
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
                      Icon(
                        Iconsax.status,
                        size: 16,
                        color: colorScheme.onSurface,
                      ),
                      if (_selectedStatus != null)
                        GestureDetector(
                          onTap: _clearStatusFilter,
                          child: Icon(
                            Iconsax.close_circle,
                            size: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _selectedStatus?.displayName ?? 'Status',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
