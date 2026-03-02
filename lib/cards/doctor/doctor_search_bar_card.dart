import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../theme/app_theme.dart';

class DoctorSearchBarCard extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;
  final List<String> specializations;
  final String? selectedSpecialization;

  const DoctorSearchBarCard({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.specializations,
    this.selectedSpecialization,
  });

  @override
  State<DoctorSearchBarCard> createState() => _DoctorSearchBarCardState();
}

class _DoctorSearchBarCardState extends State<DoctorSearchBarCard> {
  late TextEditingController _searchController;
  String? _selectedSpecialization;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedSpecialization = widget.selectedSpecialization;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
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
          child: TextField(
            controller: _searchController,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search doctors by name or specialization',
              hintStyle: AppTypography.body.copyWith(
                color: AppColors.quaternary,
              ),
              prefixIcon: Icon(
                Iconsax.search_normal,
                color: AppColors.quaternary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.quaternary),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Filter Dropdown
        Container(
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            value: _selectedSpecialization,
            hint: Row(
              children: [
                Icon(
                  Iconsax.hospital,
                  color: AppColors.quaternary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Filter by specialization',
                  style: AppTypography.body.copyWith(
                    color: AppColors.quaternary,
                  ),
                ),
              ],
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'All Specializations',
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              ...widget.specializations.map(
                (spec) => DropdownMenuItem<String>(
                  value: spec,
                  child: Text(
                    spec,
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedSpecialization = value);
              widget.onFilterChanged(value ?? '');
            },
          ),
        ),
      ],
    );
  }
}
