import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../models/gift.dart';
import '../../provider/auth_provider.dart';
import '../../provider/gift_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class SendEditGiftScreen extends ConsumerStatefulWidget {
  final String? giftId;

  const SendEditGiftScreen({super.key, this.giftId});

  @override
  ConsumerState<SendEditGiftScreen> createState() => _SendEditGiftScreenState();
}

class _SendEditGiftScreenState extends ConsumerState<SendEditGiftScreen> {
    Widget _buildSectionCard({
      required String title,
      required IconData icon,
      required Widget child,
    }) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppBorderRadius.lgRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.md),
                Text(
                  title,
                  style: AppTypography.tagline.copyWith(color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                surface: AppColors.white,
                onSurface: AppColors.black,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    void _saveGift() async {
      if (_formKey.currentState!.validate()) {
        if (_selectedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a date')));
          return;
        }
        if (_selectedDoctorId == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a doctor')));
          return;
        }
        if (_selectedOccasion == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an occasion')));
          return;
        }
        if (_selectedGiftItem == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a gift item')));
          return;
        }

        final mrId = ref.read(authNotifierProvider).mr?.mrId;
        if (mrId == null || mrId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('MR ID not found. Please login again.')));
          return;
        }
        final giftInventory = ref.read(giftInventoryProvider);
        final selectedGift = giftInventory.firstWhere((g) => g.name == _selectedGiftItem, orElse: () => GiftItem(id: '', name: '', description: ''));
        final giftId = int.tryParse(selectedGift.id) ?? 0;

        try {
          if (_isEditMode && widget.giftId != null) {
            await ref.read(giftProvider.notifier).updateMrGiftApplication(
              mrId: mrId,
              requestId: int.tryParse(widget.giftId!) ?? 0,
              doctorId: _selectedDoctorId,
              occassion: _selectedOccasion,
              giftDate: _selectedDate,
              remarks: _remarksController.text.trim(),
              // Optionally add message/status if needed
            );
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gift application updated successfully')));
          } else {
            await ref.read(giftProvider.notifier).postMrGiftApplication(
              mrId: mrId,
              doctorId: _selectedDoctorId!,
              giftId: giftId,
              occassion: _selectedOccasion,
              giftDate: _selectedDate,
              remarks: _remarksController.text.trim(),
              // Optionally add message if needed
            );
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gift application sent successfully')));
          }
          context.go('/gifts');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedDoctorId;
  String? _selectedOccasion;
  String? _selectedGiftItem;

  final bool _isEditMode = false;

  // Sample data
  final List<String> _occasions = [
    'Birthday',
    'Service Anniversary',
    'Appreciation',
    'Holiday',
    'Promotion',
    'Retirement',
  ];

  @override
  Widget build(BuildContext context) {
    final doctors = ref.watch(doctorListProvider);
    final giftInventory = ref.watch(giftInventoryProvider);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: _isEditMode ? 'Edit Gift' : 'Send Gift',
        subtitleText: _isEditMode
            ? 'Update Gift Details'
            : 'Send Gift to Doctor',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Doctor Dropdown Card
              _buildSectionCard(
                title: 'Select Doctor',
                icon: Iconsax.user,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface200,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDoctorId,
                      isExpanded: true,
                      icon: const Icon(
                        Iconsax.arrow_down_1,
                        color: AppColors.primary,
                      ),
                      style: AppTypography.body.copyWith(
                        color: AppColors.black,
                      ),
                      items: doctors
                          .map(
                            (doctor) => DropdownMenuItem<String>(
                              value: doctor.id,
                              child: Text(
                                doctor.name,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDoctorId = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Date Picker Card
              _buildSectionCard(
                title: 'Gift Date',
                icon: Iconsax.calendar,
                child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: AppBorderRadius.mdRadius,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface200,
                      borderRadius: AppBorderRadius.mdRadius,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate!),
                          style: AppTypography.body.copyWith(
                            color: _selectedDate == null
                                ? AppColors.quaternary
                                : AppColors.black,
                          ),
                        ),
                        const Icon(Iconsax.calendar, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Occasion Dropdown Card
              _buildSectionCard(
                title: 'Occasion',
                icon: Iconsax.star,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface200,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedOccasion,
                      isExpanded: true,
                      icon: const Icon(
                        Iconsax.arrow_down_1,
                        color: AppColors.primary,
                      ),
                      style: AppTypography.body.copyWith(
                        color: AppColors.black,
                      ),
                      items: _occasions
                          .map(
                            (occasion) => DropdownMenuItem<String>(
                              value: occasion,
                              child: Text(
                                occasion,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOccasion = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Gift Item Dropdown Card
              _buildSectionCard(
                title: 'Gift Item',
                icon: Iconsax.gift,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface200,
                    borderRadius: AppBorderRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGiftItem,
                      isExpanded: true,
                      icon: const Icon(
                        Iconsax.arrow_down_1,
                        color: AppColors.primary,
                      ),
                      style: AppTypography.body.copyWith(
                        color: AppColors.black,
                      ),
                      items: giftInventory
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(
                                item.name,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGiftItem = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Remarks Card
              _buildSectionCard(
                title: 'Remarks',
                icon: Iconsax.message_text,
                child: TextFormField(
                  controller: _remarksController,
                  maxLines: 4,
                  style: AppTypography.body.copyWith(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: 'Add any remarks...',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.quaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.surface200,
                    border: OutlineInputBorder(
                      borderRadius: AppBorderRadius.mdRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppBorderRadius.mdRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppBorderRadius.mdRadius,
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Save Button
              ElevatedButton(
                style: AppButtonStyles.primaryButton(height: 50),
                onPressed: _saveGift,
                child: Text(
                  _isEditMode ? 'Update Gift' : 'Send Gift',
                  style: AppTypography.buttonLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}