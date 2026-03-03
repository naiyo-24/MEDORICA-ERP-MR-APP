import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../provider/order_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../provider/distributor_provider.dart';
import '../../theme/app_theme.dart';

class OrderDetailsBottomSheet extends ConsumerWidget {
  final String orderId;

  const OrderDetailsBottomSheet({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailProvider(orderId));
    
    if (order == null) {
      return Container(
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Center(
          child: Text('Order not found'),
        ),
      );
    }

    final doctor = ref.watch(doctorDetailProvider(order.doctorId));
    final chemistShop = ref.watch(chemistShopDetailProvider(order.chemistShopId));
    final distributor = ref.watch(distributorDetailProvider(order.distributorId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      order.id,
                      style: AppTypography.body.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.quaternary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Section with Change Button
                  _buildSectionHeader('Order Status'),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(order.status),
                      InkWell(
                        onTap: () => _showStatusChangeDialog(context, ref, order),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Iconsax.edit, size: 16, color: AppColors.primary),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Change Status',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Order Dates
                  _buildSectionHeader('Order Information'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard([
                    _buildInfoRow(
                      icon: Iconsax.calendar,
                      label: 'Order Date',
                      value: DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate),
                    ),
                    if (order.deliveryDate != null)
                      _buildInfoRow(
                        icon: Iconsax.truck_fast,
                        label: 'Delivery Date',
                        value: DateFormat('dd MMM yyyy').format(order.deliveryDate!),
                      ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  // Doctor Details
                  _buildSectionHeader('Doctor'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard([
                    _buildInfoRow(
                      icon: Iconsax.user,
                      label: 'Name',
                      value: doctor?.name ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      icon: Iconsax.briefcase,
                      label: 'Specialization',
                      value: doctor?.specialization ?? 'N/A',
                    ),
                    _buildInfoRow(
                      icon: Iconsax.call,
                      label: 'Phone',
                      value: doctor?.phoneNumber ?? 'N/A',
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  // Chemist Shop Details
                  _buildSectionHeader('Delivery Location'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard([
                    _buildInfoRow(
                      icon: Iconsax.shop,
                      label: 'Shop Name',
                      value: chemistShop?.name ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      icon: Iconsax.location,
                      label: 'Address',
                      value: chemistShop?.location ?? 'N/A',
                    ),
                    _buildInfoRow(
                      icon: Iconsax.call,
                      label: 'Phone',
                      value: chemistShop?.phoneNumber ?? 'N/A',
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  // Distributor Details
                  _buildSectionHeader('Distributor'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard([
                    _buildInfoRow(
                      icon: Iconsax.truck,
                      label: 'Company',
                      value: distributor?.name ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      icon: Iconsax.call,
                      label: 'Phone',
                      value: distributor?.phoneNumber ?? 'N/A',
                    ),
                    if (distributor != null)
                      _buildInfoRow(
                        icon: Iconsax.timer_1,
                        label: 'Delivery Time',
                        value: distributor.deliveryTime,
                      ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  // Medicines
                  _buildSectionHeader('Medicines (${order.medicines.length} items)'),
                  const SizedBox(height: AppSpacing.sm),
                  ...order.medicines.map((medicine) => _buildMedicineCard(medicine)),
                  const SizedBox(height: AppSpacing.lg),

                  // Notes
                  if (order.notes != null && order.notes!.isNotEmpty) ...[
                    _buildSectionHeader('Notes'),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        order.notes!,
                        style: AppTypography.body.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.tagline.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: child,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.quaternary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.body.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard(OrderMedicine medicine) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: const Icon(
              Iconsax.health,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: AppTypography.body.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Qty: ${medicine.quantity}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                    if (medicine.unit != null) ...[
                      Text(
                        ' ${medicine.unit}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ],
                    if (medicine.batchNumber != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '• Batch: ${medicine.batchNumber}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status.displayName,
            style: AppTypography.body.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Iconsax.clock;
      case OrderStatus.confirmed:
        return Iconsax.tick_circle;
      case OrderStatus.processing:
        return Iconsax.refresh;
      case OrderStatus.shipped:
        return Iconsax.truck;
      case OrderStatus.delivered:
        return Iconsax.verify;
      case OrderStatus.cancelled:
        return Iconsax.close_circle;
    }
  }

  void _showStatusChangeDialog(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change Order Status',
          style: AppTypography.tagline.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderStatus.values.map((status) {
            final isSelected = status == order.status;
            return ListTile(
              leading: Icon(
                _getStatusIcon(status),
                color: isSelected ? AppColors.primary : AppColors.quaternary,
              ),
              title: Text(
                status.displayName,
                style: AppTypography.body.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Iconsax.tick_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(orderProvider.notifier).updateOrderStatus(order.id, status);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order status updated to ${status.displayName}'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
