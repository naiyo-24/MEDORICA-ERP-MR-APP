import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../provider/doctor_provider.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../theme/app_theme.dart';
import './order_details_bottomsheet.dart';

class OrderCard extends ConsumerWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(doctorDetailProvider(order.doctorId));
    final chemistShop = ref.watch(chemistShopDetailProvider(order.chemistShopId));

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => OrderDetailsBottomSheet(orderId: order.id),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.receipt_1,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        order.id,
                        style: AppTypography.h3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Doctor Info
              _buildInfoRow(
                icon: Iconsax.user,
                label: 'Doctor',
                value: doctor?.name ?? 'Unknown Doctor',
              ),
              const SizedBox(height: AppSpacing.sm),

              // Chemist Shop Info
              _buildInfoRow(
                icon: Iconsax.shop,
                label: 'Chemist Shop',
                value: chemistShop?.name ?? 'Unknown Shop',
              ),
              const SizedBox(height: AppSpacing.sm),

              // Medicines Count
              _buildInfoRow(
                icon: Iconsax.health,
                label: 'Medicines',
                value: '${order.medicines.length} items (${order.totalQuantity} units)',
              ),
              const SizedBox(height: AppSpacing.md),

              // Footer: Date and Action
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.calendar,
                        size: 16,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        DateFormat('dd MMM yyyy').format(order.orderDate),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => OrderDetailsBottomSheet(orderId: order.id),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Text(
                        'View Details',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.quaternary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = AppColors.secondary.withAlpha(25);
        textColor = AppColors.secondary;
        break;
      case OrderStatus.confirmed:
        backgroundColor = AppColors.tertiary.withAlpha(25);
        textColor = AppColors.tertiary;
        break;
      case OrderStatus.processing:
        backgroundColor = AppColors.secondary.withAlpha(25);
        textColor = AppColors.secondary;
        break;
      case OrderStatus.shipped:
        backgroundColor = AppColors.primary.withAlpha(25);
        textColor = AppColors.primary;
        break;
      case OrderStatus.delivered:
        backgroundColor = AppColors.success.withAlpha(25);
        textColor = AppColors.success;
        break;
      case OrderStatus.cancelled:
        backgroundColor = AppColors.error.withAlpha(25);
        textColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
