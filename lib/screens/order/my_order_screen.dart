import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/order/order_card.dart';
import '../../cards/order/order_search_filter_card.dart';
import '../../models/order.dart';
import '../../provider/order_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../provider/distributor_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyOrderScreen extends ConsumerStatefulWidget {
  const MyOrderScreen({super.key});

  @override
  ConsumerState<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends ConsumerState<MyOrderScreen> {
  String _searchQuery = '';
  String _selectedDoctorId = '';
  String _selectedChemistShopId = '';
  String _selectedDistributorId = '';
  OrderStatus? _selectedStatus;

  List<Order> _getFilteredOrders() {
    List<Order> orders = ref.watch(sortedOrdersProvider);

    // Apply search
    if (_searchQuery.isNotEmpty) {
      orders = orders
          .where((order) =>
              order.id.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply filters
    if (_selectedDoctorId.isNotEmpty) {
      orders = orders.where((order) => order.doctorId == _selectedDoctorId).toList();
    }

    if (_selectedChemistShopId.isNotEmpty) {
      orders = orders
          .where((order) => order.chemistShopId == _selectedChemistShopId)
          .toList();
    }

    if (_selectedDistributorId.isNotEmpty) {
      orders = orders
          .where((order) => order.distributorId == _selectedDistributorId)
          .toList();
    }

    if (_selectedStatus != null) {
      orders = orders.where((order) => order.status == _selectedStatus).toList();
    }

    return orders;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Iconsax.filter, color: AppColors.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Filter Orders',
              style: AppTypography.tagline.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Filter
              Text(
                'Doctor',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDoctorDropdown(),
              const SizedBox(height: AppSpacing.md),

              // Chemist Shop Filter
              Text(
                'Chemist Shop',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildChemistShopDropdown(),
              const SizedBox(height: AppSpacing.md),

              // Distributor Filter
              Text(
                'Distributor',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDistributorDropdown(),
              const SizedBox(height: AppSpacing.md),

              // Status Filter
              Text(
                'Order Status',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStatusDropdown(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDoctorId = '';
                _selectedChemistShopId = '';
                _selectedDistributorId = '';
                _selectedStatus = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    final doctors = ref.watch(doctorProvider);
    return DropdownButtonFormField<String>(
      initialValue: _selectedDoctorId.isEmpty ? null : _selectedDoctorId,
      decoration: InputDecoration(
        hintText: 'All Doctors',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Doctors')),
        ...doctors.map((doctor) => DropdownMenuItem(
              value: doctor.id,
              child: Text(doctor.name),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedDoctorId = value ?? '';
        });
      },
    );
  }

  Widget _buildChemistShopDropdown() {
    final shops = ref.watch(chemistShopProvider);
    return DropdownButtonFormField<String>(
      initialValue: _selectedChemistShopId.isEmpty ? null : _selectedChemistShopId,
      decoration: InputDecoration(
        hintText: 'All Chemist Shops',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Chemist Shops')),
        ...shops.map((shop) => DropdownMenuItem(
              value: shop.id,
              child: Text(shop.name),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedChemistShopId = value ?? '';
        });
      },
    );
  }

  Widget _buildDistributorDropdown() {
    final distributors = ref.watch(distributorProvider);
    return DropdownButtonFormField<String>(
      initialValue: _selectedDistributorId.isEmpty ? null : _selectedDistributorId,
      decoration: InputDecoration(
        hintText: 'All Distributors',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Distributors')),
        ...distributors.map((distributor) => DropdownMenuItem(
              value: distributor.id,
              child: Text(distributor.name),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedDistributorId = value ?? '';
        });
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<OrderStatus?>(
      initialValue: _selectedStatus,
      decoration: InputDecoration(
        hintText: 'All Statuses',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Statuses')),
        ...OrderStatus.values.map((status) => DropdownMenuItem(
              value: status,
              child: Text(status.displayName),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredOrders();
    final hasActiveFilters = _selectedDoctorId.isNotEmpty ||
        _selectedChemistShopId.isNotEmpty ||
        _selectedDistributorId.isNotEmpty ||
        _selectedStatus != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MRAppBar(
        showBack: false,
        showActions: true,
        titleText: 'My Orders',
        subtitleText: 'Track and manage your orders',
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Search and Filter Card
            Stack(
              children: [
                OrderSearchFilterCard(
                  onSearchChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onFilterTapped: _showFilterDialog,
                ),
                if (hasActiveFilters)
                  Positioned(
                    top: 8,
                    right: 40,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Active Filters Chips
            if (hasActiveFilters) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_selectedDoctorId.isNotEmpty)
                      _buildFilterChip(
                        'Doctor',
                        () => setState(() => _selectedDoctorId = ''),
                      ),
                    if (_selectedChemistShopId.isNotEmpty)
                      _buildFilterChip(
                        'Chemist Shop',
                        () => setState(() => _selectedChemistShopId = ''),
                      ),
                    if (_selectedDistributorId.isNotEmpty)
                      _buildFilterChip(
                        'Distributor',
                        () => setState(() => _selectedDistributorId = ''),
                      ),
                    if (_selectedStatus != null)
                      _buildFilterChip(
                        _selectedStatus!.displayName,
                        () => setState(() => _selectedStatus = null),
                      ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDoctorId = '';
                          _selectedChemistShopId = '';
                          _selectedDistributorId = '';
                          _selectedStatus = null;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.clear_all, size: 16, color: AppColors.error),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Clear All',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Orders List
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.box,
                            size: 80,
                            color: AppColors.quaternary.withAlpha(127),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            _searchQuery.isNotEmpty || hasActiveFilters
                                ? 'No orders found'
                                : 'No orders yet',
                            style: AppTypography.tagline.copyWith(
                              color: AppColors.quaternary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _searchQuery.isNotEmpty || hasActiveFilters
                                ? 'Try adjusting your search or filters'
                                : 'Create your first order',
                            style: AppTypography.body.copyWith(
                              color: AppColors.quaternary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return OrderCard(order: filteredOrders[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('${AppRouter.orders}/create');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: AppColors.white),
        label: Text(
          'New Order',
          style: AppTypography.body.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: Chip(
        label: Text(label),
        labelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: AppColors.primaryLight,
        deleteIcon: const Icon(
          Icons.close,
          size: 16,
          color: AppColors.primary,
        ),
        onDeleted: onRemove,
      ),
    );
  }
}
