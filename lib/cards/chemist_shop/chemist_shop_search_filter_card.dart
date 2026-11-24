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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF3A3A3A)
    : AppColors.white,
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
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.quaternary,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                          setState(() {});
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
          // Filter Button
          if (widget.onFilterTapped != null) ...[
            
            IconButton(
              
              icon: Icon(
                Iconsax.filter,
                color: colorScheme.onSurface,
                size: 20,
              ),
              onPressed: widget.onFilterTapped,
            ),
          ],
        ],
      ),
    );
  }
}
