import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/appointment.dart';
import '../../theme/app_theme.dart';

class AppointmentFilterOptionsCard extends StatefulWidget {
  final Function(DateTime?) onDateFilterChanged;
  final Function(AppointmentStatus?) onStatusFilterChanged;
  final DateTime? selectedDate;
  final AppointmentStatus? selectedStatus;

  const AppointmentFilterOptionsCard({
    super.key,
    required this.onDateFilterChanged,
    required this.onStatusFilterChanged,
    this.selectedDate,
    this.selectedStatus,
  });

  @override
  State<AppointmentFilterOptionsCard> createState() =>
      _AppointmentFilterOptionsCardState();
}

class _AppointmentFilterOptionsCardState
    extends State<AppointmentFilterOptionsCard> {
  DateTime? _selectedDate;
  AppointmentStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
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

  return Theme(
    data: theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: theme.colorScheme.primary,
        onPrimary: theme.colorScheme.onPrimary,
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

  void _clearStatusFilter() {
    setState(() {
      _selectedStatus = null;
    });
    widget.onStatusFilterChanged(null);
  }

  void _clearAllFilters() {
    setState(() {
      _selectedDate = null;
      _selectedStatus = null;
    });
    widget.onDateFilterChanged(null);
    widget.onStatusFilterChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasActiveFilters = _selectedDate != null || _selectedStatus != null;

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
                      'Filter Appointments',
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
                      color: Theme.of(context).brightness == Brightness.dark
    ? colorScheme.surface
    : _selectedDate != null
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
                            Icon(
                              Iconsax.calendar,
                              size: 18,
                              color: colorScheme.onSurface,
                            ),
                            if (_selectedDate != null)
                              InkWell(
                                onTap: _clearDateFilter,
                                child: const Icon(
                                  Iconsax.close_circle,
                                  size: 16,
                                  color: AppColors.quaternary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _selectedDate == null
                              ? 'By Date'
                              : DateFormat('MMM dd').format(_selectedDate!),
                          style: AppTypography.bodySmall.copyWith(
    color: _selectedStatus != null
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant,
    fontWeight: _selectedStatus != null
        ? FontWeight.w600
        : FontWeight.w400,
  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Status Filter
              // Status Filter
              Expanded(
                child: PopupMenuButton<AppointmentStatus>(
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.mdRadius,
                  ),
                  onSelected: (AppointmentStatus status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                    widget.onStatusFilterChanged(status);
                  },
                  itemBuilder: (context) {
                    return AppointmentStatus.values.map((status) {
                      return PopupMenuItem<AppointmentStatus>(
                        value: status,
                        child: Text(
                          status.displayName,
                          style: AppTypography.body,
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
    ? colorScheme.surface
    : _selectedStatus != null
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
                            Icon(
                              Iconsax.status,
                              size: 18,
                              color: colorScheme.onSurface
                            ),
                            if (_selectedStatus != null)
                              GestureDetector(
                                onTap: _clearStatusFilter,
                                child: const Icon(
                                  Iconsax.close_circle,
                                  size: 16,
                                  color: AppColors.quaternary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
  _selectedStatus?.displayName ?? 'By Status',
  style: AppTypography.bodySmall.copyWith(
    color: _selectedStatus != null
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant,
    fontWeight: _selectedStatus != null
        ? FontWeight.w600
        : FontWeight.w400,
  ),
),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
