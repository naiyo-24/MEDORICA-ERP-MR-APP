import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class ChemistShopSearchFilterCard extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onFilterTapped;

  const ChemistShopSearchFilterCard({
    super.key,
    required this.onSearchChanged,
    this.onFilterTapped,
  });

  @override
  State<ChemistShopSearchFilterCard> createState() =>
      _ChemistShopSearchFilterCardState();
}

class _ChemistShopSearchFilterCardState
    extends State<ChemistShopSearchFilterCard> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search shops...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.quaternary,
                ),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: AppColors.quaternary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Iconsax.close_circle,
                          color: AppColors.quaternary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Filter Button
          if (widget.onFilterTapped != null)
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(
                  color: AppColors.primary,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Iconsax.filter,
                  color: AppColors.primary,
                ),
                onPressed: widget.onFilterTapped,
              ),
            ),
        ],
      ),
    );
  }
}
