import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/order.dart';
import '../../models/chemist_shop.dart';
import '../../models/doctor.dart' as doctor_model;
import '../../models/distributor.dart';
import '../../provider/auth_provider.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../provider/distributor_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../provider/order_provider.dart';
import '../../theme/app_theme.dart';

class CreateNewOrderScreen extends ConsumerStatefulWidget {
  const CreateNewOrderScreen({super.key});

  @override
  ConsumerState<CreateNewOrderScreen> createState() =>
      _CreateNewOrderScreenState();
}

class _CreateNewOrderScreenState extends ConsumerState<CreateNewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _medicineNameController;
  late TextEditingController _medicineQtyController;
  late TextEditingController _medicinePackController;
  late TextEditingController _medicineTotalAmountController;

  ChemistShop? _selectedShop;
  doctor_model.Doctor? _selectedDoctor;
  Distributor? _selectedDistributor;
  final List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController();
    _medicineQtyController = TextEditingController();
    _medicinePackController = TextEditingController();
    _medicineTotalAmountController = TextEditingController();

    // Ensure chemist shops are loaded for dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chemistShopNotifier = ref.read(chemistShopProvider.notifier);
      chemistShopNotifier.loadShopsForCurrentMr();
    });
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _medicineQtyController.dispose();
    _medicinePackController.dispose();
    _medicineTotalAmountController.dispose();
    super.dispose();
  }

  void _addMedicine() {
    if (_medicineNameController.text.isEmpty ||
        _medicineQtyController.text.isEmpty ||
        _medicinePackController.text.isEmpty ||
        _medicineTotalAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all medicine fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final medicine = Medicine(
      id: DateTime.now().toString(),
      name: _medicineNameController.text,
      quantity: int.tryParse(_medicineQtyController.text) ?? 0,
      pack: _medicinePackController.text,
      totalAmount: double.tryParse(_medicineTotalAmountController.text) ?? 0.0,
    );

    setState(() {
      _medicines.add(medicine);
      _medicineNameController.clear();
      _medicineQtyController.clear();
      _medicinePackController.clear();
      _medicineTotalAmountController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeMedicine(int index) {
    setState(() => _medicines.removeAt(index));
  }

  Future<void> _saveOrder() async {
    if (_medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one medicine'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authState = ref.read(authNotifierProvider);
    final mrId = authState.mr?.mrId;
    if (mrId == null || mrId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to identify ASM. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final totalAmount = _medicines.fold<double>(
      0,
      (sum, medicine) => sum + medicine.totalAmount,
    );

    try {
      await ref
          .read(orderNotifierProvider.notifier)
          .createOrder(
            mrId: mrId,
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
          content: Text(error ?? 'Failed to create order'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order created successfully'),
        backgroundColor: AppColors.primary,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final shops = ref.watch(chemistShopProvider).shops;
    final doctors = ref.watch(doctorListProvider);
    final distributors = ref.watch(distributorListProvider);
    final isSaving = ref.watch(orderLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_circle_left, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Create New Order',
          style: AppTypography.h3.copyWith(color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Chemist Shop Selection
              _buildSectionTitle('Select Chemist Shop'),
              const SizedBox(height: 16),
              _buildDropdown<ChemistShop>(
                items: shops,
                selectedItem: _selectedShop,
                label: 'Chemist Shop',
                hint: 'Select a chemist shop',
                itemLabel: (shop) => shop.name,
                onChanged: (shop) {
                  setState(() {
                    _selectedShop = shop;
                  });
                },
                icon: Iconsax.shop,
                isRequired: false,
              ),
              const SizedBox(height: 24),

              // Section 3: Doctor Selection
              _buildSectionTitle('Select Doctor'),
              const SizedBox(height: 16),
              _buildDropdown<doctor_model.Doctor>(
                items: doctors,
                selectedItem: _selectedDoctor,
                label: 'Doctor',
                hint: 'Select a doctor',
                itemLabel: (doctor) =>
                    '${doctor.name} (${doctor.specialization})',
                onChanged: (doctor) {
                  setState(() => _selectedDoctor = doctor);
                },
                icon: Iconsax.user,
                isRequired: false,
              ),
              const SizedBox(height: 24),

              // Section 3.5: Distributor Selection
              _buildSectionTitle('Select Distributor'),
              const SizedBox(height: 16),
              _buildDropdown<Distributor>(
                items: distributors,
                selectedItem: _selectedDistributor,
                label: 'Distributor',
                hint: 'Select a distributor',
                itemLabel: (distributor) => distributor.name,
                onChanged: (distributor) {
                  setState(() => _selectedDistributor = distributor);
                },
                icon: Iconsax.truck,
                isRequired: false,
              ),
              const SizedBox(height: 24),

              // Section 4: Medicines
              _buildSectionTitle('Add Medicines'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _medicineNameController,
                label: 'Medicine Name',
                hint: 'e.g., Aspirin 500mg',
                icon: Iconsax.box,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _medicineQtyController,
                      label: 'Quantity',
                      hint: 'Enter quantity',
                      icon: Iconsax.box_1,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _medicinePackController,
                      label: 'Pack',
                      hint: 'e.g., Blister',
                      icon: Iconsax.box,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _medicineTotalAmountController,
                      label: 'Total Amount',
                      hint: 'Amount (₹)',
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
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Iconsax.add, size: 20),
                  label: const Text(
                    'Add Medicine',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Medicines List
              if (_medicines.isNotEmpty) ...[
                Text(
                  'Added Medicines (${_medicines.length})',
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
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
                                color: Colors.red.withAlpha(50),
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
                const SizedBox(height: 24),
              ],

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : _saveOrder,
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
                      : const Icon(Iconsax.add_circle, color: AppColors.white),
                  label: Text(
                    isSaving ? 'Creating...' : 'Create Order',
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
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: AppTypography.body.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
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
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required List<T> items,
    required T? selectedItem,
    required String label,
    required String hint,
    required String Function(T) itemLabel,
    required Function(T) onChanged,
    required IconData icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: AppTypography.body.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
          ],
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
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}