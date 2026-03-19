import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/order.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class OrderDetailsBottomSheet extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailsBottomSheet({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsBottomSheet> createState() =>
      _OrderDetailsBottomSheetState();
}

class _OrderDetailsBottomSheetState
    extends ConsumerState<OrderDetailsBottomSheet> {
  Future<void> _launchDialer(String phoneNo) async {
    final phoneUrl = 'tel:${phoneNo.replaceAll(RegExp(r'[^\d+]'), '')}';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(
        Uri.parse(phoneUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _launchMaps(String address) async {
    final mapsUrl =
        'https://www.google.com/maps/search/${Uri.encodeComponent(address)}';
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Details',
                        style: AppTypography.h2.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Order ID
                  _buildSection(
                    title: 'Order ID',
                    child: Text(
                      widget.order.id,
                      style: AppTypography.h3.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chemist Shop Information
                  _buildSectionTitle('Chemist Shop'),
                  const SizedBox(height: 10),
                  _buildContactItem(
                    icon: Iconsax.shop,
                    label: 'Shop Name',
                    value: widget.order.chemistShopName,
                    isClickable: false,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchDialer(widget.order.chemistShopPhoneNo),
                    child: _buildContactItem(
                      icon: Iconsax.call,
                      label: 'Shop Phone',
                      value: widget.order.chemistShopPhoneNo,
                      isClickable: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchMaps(widget.order.chemistShopAddress),
                    child: _buildContactItem(
                      icon: Iconsax.location,
                      label: 'Shop Address',
                      value: widget.order.chemistShopAddress,
                      isClickable: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Doctor Information
                  _buildSectionTitle('Doctor'),
                  const SizedBox(height: 10),
                  _buildContactItem(
                    icon: Iconsax.user,
                    label: 'Doctor Name',
                    value: widget.order.doctorName,
                    isClickable: false,
                  ),
                  const SizedBox(height: 16),

                  // Distributor Information
                  _buildSectionTitle('Distributor'),
                  const SizedBox(height: 10),
                  _buildContactItem(
                    icon: Iconsax.truck,
                    label: 'Distributor Name',
                    value: widget.order.distributorName,
                    isClickable: false,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchDialer(widget.order.distributorPhoneNo),
                    child: _buildContactItem(
                      icon: Iconsax.call,
                      label: 'Distributor Phone',
                      value: widget.order.distributorPhoneNo,
                      isClickable: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchMaps(widget.order.distributorAddress),
                    child: _buildContactItem(
                      icon: Iconsax.location,
                      label: 'Distributor Address',
                      value: widget.order.distributorAddress,
                      isClickable: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildContactItem(
                    icon: Iconsax.clock,
                    label: 'Delivery Time',
                    value: widget.order.distributorDeliveryTime,
                    isClickable: false,
                  ),
                  const SizedBox(height: 16),

                  // Medicines
                  _buildSectionTitle('Medicines'),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.order.medicines.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final medicine = widget.order.medicines[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withAlpha(100),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryLight.withAlpha(150),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine.name,
                              style: AppTypography.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Qty: ${medicine.quantity}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.quaternary,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Pack: ${medicine.pack}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.quaternary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Order Status
                  _buildSectionTitle('Order Status'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withAlpha(100),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primaryLight.withAlpha(150),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.status, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.order.status
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: AppTypography.body.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(
                          '${AppRouter.orders}/edit/${widget.order.id}',
                          extra: widget.order,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 2,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Iconsax.edit_2, color: AppColors.white),
                      label: Text(
                        'Edit Order',
                        style: AppTypography.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.caption.copyWith(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isClickable,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTypography.body.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isClickable)
            Icon(Iconsax.arrow_right, color: AppColors.quaternary, size: 18),
        ],
      ),
    );
  }
}