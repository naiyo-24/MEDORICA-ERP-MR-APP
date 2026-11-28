import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class DistributorSearchFilterCard extends StatefulWidget {
  final Function(String) onSearch;

  const DistributorSearchFilterCard({super.key, required this.onSearch});

  @override
  State<DistributorSearchFilterCard> createState() =>
      _DistributorSearchFilterCardState();
}

class _DistributorSearchFilterCardState
    extends State<DistributorSearchFilterCard> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                hintText: 'Search distributor...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.quaternary,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: AppColors.quaternary,
                  size: 18,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 34,
                  minHeight: 34,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
              ),
              style: AppTypography.body.copyWith(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}