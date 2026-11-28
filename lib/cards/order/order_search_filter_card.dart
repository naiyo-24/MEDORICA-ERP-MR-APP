import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';

class OrderSearchFilterCard extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(OrderStatus?) onStatusFilterChanged;

  const OrderSearchFilterCard({
    super.key,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
  });

  @override
  State<OrderSearchFilterCard> createState() => _OrderSearchFilterCardState();
}

class _OrderSearchFilterCardState extends State<OrderSearchFilterCard> {
  late TextEditingController _searchController;
  OrderStatus? _selectedStatus;

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search orders...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.quaternary,
                  fontSize: 12,
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
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
              ),
              style: AppTypography.body.copyWith(
                color: colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: AppColors.primaryLight,
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),
          PopupMenuButton<OrderStatus?>(
            onSelected: (value) {
              setState(() => _selectedStatus = value);
              widget.onStatusFilterChanged(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: null, child: Text('All Orders')),
              const PopupMenuItem(
                value: OrderStatus.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: OrderStatus.approved,
                child: Text('Approved'),
              ),
              const PopupMenuItem(
                value: OrderStatus.delivered,
                child: Text('Delivered'),
              ),
              const PopupMenuItem(
                value: OrderStatus.shipped,
                child: Text('Shipped'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Iconsax.setting_3,
                color: _selectedStatus != null
                    ? AppColors.primary
                    : AppColors.quaternary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}