import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/chemist_shop.dart';
import '../../models/distributor.dart';
import '../../models/doctor.dart' as doctor_model;
import '../../models/order.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../provider/distributor_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../provider/order_provider.dart';
import '../../theme/app_theme.dart';

class EditOrderScreen extends ConsumerStatefulWidget {
  const EditOrderScreen({super.key, required this.order});

  final Order order;

  @override
  ConsumerState<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends ConsumerState<EditOrderScreen> {
  late TextEditingController _medicineNameController;
  late TextEditingController _medicineQtyController;
  late TextEditingController _medicinePackController;
  late TextEditingController _medicineTotalAmountController;
  late TextEditingController _totalAmountController;

  ChemistShop? _selectedShop;
  doctor_model.Doctor? _selectedDoctor;
  Distributor? _selectedDistributor;

  final List<Medicine> _medicines = [];
  bool _didInitSelections = false;

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController();
    _medicineQtyController = TextEditingController();
    _medicinePackController = TextEditingController();
    _medicineTotalAmountController = TextEditingController();
    _totalAmountController = TextEditingController(
      text: widget.order.totalAmountRupees.toStringAsFixed(2),
    );

    _medicines.addAll(widget.order.medicines);
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _medicineQtyController.dispose();
    _medicinePackController.dispose();
    _medicineTotalAmountController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  void _tryInitSelections({
    required List<ChemistShop> shops,
    required List<doctor_model.Doctor> doctors,
    required List<Distributor> distributors,
  }) {
    if (_didInitSelections) {
      return;
    }

    if (shops.isEmpty && doctors.isEmpty && distributors.isEmpty) {
      return;
    }

    ChemistShop? matchingShop;
    doctor_model.Doctor? matchingDoctor;
    Distributor? matchingDistributor;

    if (shops.isNotEmpty) {
      for (final shop in shops) {
        if ((widget.order.chemistShopId.isNotEmpty &&
                shop.id == widget.order.chemistShopId) ||
            (widget.order.chemistShopId.isEmpty &&
                shop.name == widget.order.chemistShopName)) {
          matchingShop = shop;
          break;
        }
      }
    }

    if (doctors.isNotEmpty) {
      for (final doctor in doctors) {
        if ((widget.order.doctorId.isNotEmpty &&
                doctor.id == widget.order.doctorId) ||
            (widget.order.doctorId.isEmpty &&
                doctor.name == widget.order.doctorName)) {
          matchingDoctor = doctor;
          break;
        }
      }
    }

    if (distributors.isNotEmpty) {
      for (final distributor in distributors) {
        if ((widget.order.distributorId.isNotEmpty &&
                distributor.id == widget.order.distributorId) ||
            (widget.order.distributorId.isEmpty &&
                distributor.name == widget.order.distributorName)) {
          matchingDistributor = distributor;
          break;
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedShop = matchingShop;
        _selectedDoctor = matchingDoctor;
        _selectedDistributor = matchingDistributor;
        _didInitSelections = true;
      });
    });
  }

  void _addMedicine() {
    if (_medicineNameController.text.trim().isEmpty ||
        _medicineQtyController.text.trim().isEmpty ||
        _medicinePackController.text.trim().isEmpty ||
        _medicineTotalAmountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all medicine fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final medicine = Medicine(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _medicineNameController.text.trim(),
      quantity: int.tryParse(_medicineQtyController.text.trim()) ?? 0,
      pack: _medicinePackController.text.trim(),
      totalAmount:
          double.tryParse(_medicineTotalAmountController.text.trim()) ?? 0,
    );

    setState(() {
      _medicines.add(medicine);
      _medicineNameController.clear();
      _medicineQtyController.clear();
      _medicinePackController.clear();
      _medicineTotalAmountController.clear();
      _recalculateTotal();
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      _medicines.removeAt(index);
      _recalculateTotal();
    });
  }

  void _recalculateTotal() {
    final total = _medicines.fold<double>(
      0,
      (sum, medicine) => sum + medicine.totalAmount,
    );
    _totalAmountController.text = total.toStringAsFixed(2);
  }

  Future<void> _saveOrderChanges() async {
    if (_medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one medicine'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final totalAmount = double.tryParse(_totalAmountController.text.trim());
    if (totalAmount == null || totalAmount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid total amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref
          .read(orderNotifierProvider.notifier)
          .updateOrder(
            orderId: widget.order.id,
            distributorId: _selectedDistributor?.id,
            chemistShopId: _selectedShop?.id,
            doctorId: _selectedDoctor?.id,
            medicines: _medicines,
            totalAmountRupees: totalAmount,
            distributorName: _selectedDistributor?.name ?? '',
            distributorPhoneNo: _selectedDistributor?.phoneNo ?? '',
            distributorAddress: _selectedDistributor?.address ?? '',
            distributorDeliveryTime: _selectedDistributor?.deliveryTime ?? '',
            chemistShopName: _selectedShop?.name ?? '',
            chemistShopPhoneNo: _selectedShop?.phoneNumber ?? '',
            chemistShopAddress: _selectedShop?.location ?? '',
            doctorName: _selectedDoctor?.name ?? '',
          );
    } catch (_) {
      final error = ref.read(orderNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to update order'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order updated successfully'),
        backgroundColor: AppColors.primary,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shops = ref.watch(chemistShopProvider).shops;
    final doctors = ref.watch(doctorListProvider);
    final distributors = ref.watch(distributorListProvider);
    final isSaving = ref.watch(orderLoadingProvider);

    _tryInitSelections(
      shops: shops,
      doctors: doctors,
      distributors: distributors,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_circle_left, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Order',
          style: AppTypography.h3.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReadOnlyCard(
              colorScheme: colorScheme,
              label: 'Order ID',
              value: widget.order.id,
              icon: Iconsax.note,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyCard(
              colorScheme: colorScheme,
              label: 'Current Status',
              value: widget.order.status
                  .toString()
                  .split('.')
                  .last
                  .toUpperCase(),
              icon: Iconsax.status,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Select Chemist Shop'),
            const SizedBox(height: 12),
            _buildDropdown<ChemistShop>(
              colorScheme: colorScheme,
              items: shops,
              selectedItem: _selectedShop,
              label: 'Chemist Shop',
              hint: 'Select a chemist shop',
              itemLabel: (shop) => shop.name,
              onChanged: (shop) => setState(() => _selectedShop = shop),
              icon: Iconsax.shop,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Select Doctor'),
            const SizedBox(height: 12),
            _buildDropdown<doctor_model.Doctor>(
              colorScheme: colorScheme,
              items: doctors,
              selectedItem: _selectedDoctor,
              label: 'Doctor',
              hint: 'Select a doctor',
              itemLabel: (doctor) =>
                  '${doctor.name} (${doctor.specialization})',
              onChanged: (doctor) => setState(() => _selectedDoctor = doctor),
              icon: Iconsax.user,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Select Distributor'),
            const SizedBox(height: 12),
            _buildDropdown<Distributor>(
              colorScheme: colorScheme,
              items: distributors,
              selectedItem: _selectedDistributor,
              label: 'Distributor',
              hint: 'Select a distributor',
              itemLabel: (distributor) => distributor.name,
              onChanged: (distributor) =>
                  setState(() => _selectedDistributor = distributor),
              icon: Iconsax.truck,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Medicines'),
            const SizedBox(height: 12),
            _buildTextField(
              colorScheme: colorScheme,
              controller: _medicineNameController,
              label: 'Medicine Name',
              hint: 'e.g., Aspirin 500mg',
              icon: Iconsax.box,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    colorScheme: colorScheme,
                    controller: _medicineQtyController,
                    label: 'Quantity',
                    hint: 'Qty',
                    icon: Iconsax.box_1,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    colorScheme: colorScheme,
                    controller: _medicinePackController,
                    label: 'Pack',
                    hint: 'Pack',
                    icon: Iconsax.box,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    colorScheme: colorScheme,
                    controller: _medicineTotalAmountController,
                    label: 'Amount',
                    hint: 'Amount',
                    icon: Iconsax.wallet_2,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addMedicine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Iconsax.add, size: 18),
                label: const Text('Add Medicine'),
              ),
            ),
            const SizedBox(height: 14),
            if (_medicines.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _medicines.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final medicine = _medicines[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withAlpha(100),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryLight.withAlpha(150),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
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
                              const SizedBox(height: 4),
                              Text(
                                'Qty: ${medicine.quantity} | Pack: ${medicine.pack}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.quaternary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Amount: ₹${medicine.totalAmount.toStringAsFixed(2)}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _removeMedicine(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Iconsax.trash,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            _buildTextField(
              colorScheme: colorScheme,
              controller: _totalAmountController,
              label: 'Total Amount (₹)',
              hint: 'Enter final total amount',
              icon: Iconsax.wallet_3,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _saveOrderChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 4,
                  shadowColor: AppColors.primary.withAlpha(100),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Iconsax.edit, color: AppColors.white),
                label: Text(
                  isSaving ? 'Updating...' : 'Update Order',
                  style: AppTypography.h3.copyWith(
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
    );
  }

  Widget _buildReadOnlyCard({
    required ColorScheme colorScheme,
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withAlpha(70),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.quaternary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.body.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    );
  }

  Widget _buildTextField({
    required ColorScheme colorScheme,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.quaternary,
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
            filled: true,
            fillColor: AppColors.primaryLight.withAlpha(50),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          style: AppTypography.body.copyWith(
            color: colorScheme.onSurface,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required ColorScheme colorScheme,
    required List<T> items,
    required T? selectedItem,
    required String label,
    required String hint,
    required String Function(T) itemLabel,
    required void Function(T) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryLight, width: 1),
            color: AppColors.primaryLight.withAlpha(50),
          ),
          child: DropdownButton<T>(
            value: selectedItem,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(
              hint,
              style: AppTypography.body.copyWith(
                color: AppColors.quaternary,
                fontSize: 13,
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      style: AppTypography.body.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
