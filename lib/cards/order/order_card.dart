import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.approved:
        return const Color(0xFF4CAF50);
      case OrderStatus.pending:
        return const Color(0xFFFFC107);
      case OrderStatus.delivered:
        return const Color(0xFF2196F3);
      case OrderStatus.shipped:
        return const Color(0xFF3F51B5);
      case OrderStatus.received:
        return const Color(0xFF8BC34A);
      case OrderStatus.rejected:
        return const Color(0xFFF44336);
      case OrderStatus.cancelled:
        return const Color(0xFF9E9E9E);
    }
  }

  String _getStatusText() {
    return order.status.toString().split('.').last.toUpperCase();
  }

  Color _getStatusTextColor() {
    if (order.status == OrderStatus.pending) {
      return AppColors.primary;
    }
    return AppColors.white;
  }

  Widget _infoRow(BuildContext context,{
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, color: AppColors.primary, size: 14),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: AppTypography.caption.copyWith(
              color: AppColors.quaternary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              style: AppTypography.body.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF3A3A3A)
    : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(16),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: AppColors.primaryLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryLight),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.quaternary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order.id,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withAlpha(210),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: AppTypography.caption.copyWith(
                        color: _getStatusTextColor(),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _infoRow(
              context,
              icon: Iconsax.shop,
              label: 'Shop',
              value: order.chemistShopName,
            ),
            const SizedBox(height: 8),
            _infoRow(
              context,
              icon: Iconsax.truck,
              label: 'Distributor',
              value: order.distributorName,
            ),
          ],
        ),
      ),
    );
  }
}