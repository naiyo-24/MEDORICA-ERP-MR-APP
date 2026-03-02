import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/chemist_shop.dart';
import '../../provider/chemist_shop_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../theme/app_theme.dart';

class AddEditChemistShopScreen extends ConsumerStatefulWidget {
  final ChemistShop? shop;

  const AddEditChemistShopScreen({super.key, this.shop});

  @override
  ConsumerState<AddEditChemistShopScreen> createState() =>
      _AddEditChemistShopScreenState();
}

class _AddEditChemistShopScreenState
    extends ConsumerState<AddEditChemistShopScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _photoController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  final _formKey = GlobalKey<FormState>();
  List<String> _selectedDoctorIds = [];
  bool _loading = false;
  XFile? _selectedPhoto;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final shop = widget.shop;
    _nameController = TextEditingController(text: shop?.name ?? '');
    _phoneController = TextEditingController(text: shop?.phoneNumber ?? '');
    _emailController = TextEditingController(text: shop?.email ?? '');
    _photoController = TextEditingController(text: shop?.photo ?? '');
    _locationController = TextEditingController(text: shop?.location ?? '');
    _descriptionController =
        TextEditingController(text: shop?.description ?? '');
    _selectedDoctorIds = shop?.doctorIds ?? [];
  }

  Future<void> _pickPhotoFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedPhoto = pickedFile;
          _photoController.text = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickPhotoFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedPhoto = pickedFile;
          _photoController.text = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: ${e.toString()}')),
        );
      }
    }
  }

  void _showPhotoPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Iconsax.gallery, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPhotoFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.camera, color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickPhotoFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _photoController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showDoctorSelectionDialog() {
    final allDoctors = ref.read(doctorProvider);
    final selectedIds = List<String>.from(_selectedDoctorIds);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Select Doctors',
            style: AppTypography.h3.copyWith(color: AppColors.primary),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: allDoctors.isEmpty
                ? Center(
                    child: Text(
                      'No doctors available',
                      style: AppTypography.body.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: allDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = allDoctors[index];
                      final isSelected = selectedIds.contains(doctor.id);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setDialogState(() {
                            if (value == true) {
                              selectedIds.add(doctor.id);
                            } else {
                              selectedIds.remove(doctor.id);
                            }
                          });
                        },
                        title: Text(
                          doctor.name,
                          style: AppTypography.body.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          doctor.specialization,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                        activeColor: AppColors.primary,
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.quaternary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedDoctorIds = selectedIds);
                Navigator.of(context).pop();
              },
              child: Text(
                'Done',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeDoctorId(String doctorId) {
    setState(() => _selectedDoctorIds.remove(doctorId));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final shop = ChemistShop(
      id: widget.shop?.id ?? DateTime.now().toString(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photo: _photoController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      doctorIds: _selectedDoctorIds,
    );

    if (widget.shop == null) {
      ref.read(chemistShopProvider.notifier).addChemistShop(shop);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop added successfully')),
      );
    } else {
      ref.read(chemistShopProvider.notifier).updateChemistShop(shop);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop updated successfully')),
      );
    }

    setState(() => _loading = false);
    context.go('/mr/chemist');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.shop != null;
    final allDoctors = ref.watch(doctorProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_circle_left,
              color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit Shop' : 'Add Shop',
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
            Text(
              isEditing ? 'Update shop details' : 'Add new shop details',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.quaternary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shop Name
              _buildTextFormField(
                controller: _nameController,
                label: 'Shop Name',
                icon: Iconsax.shop,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter shop name' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone Number
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter phone number' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Email
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                icon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter email' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Photo Picker
              _buildPhotoPickerField(),
              const SizedBox(height: AppSpacing.md),

              // Location
              _buildTextFormField(
                controller: _locationController,
                label: 'Location',
                icon: Iconsax.location,
                maxLines: 2,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter location' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Description',
                icon: Iconsax.document_text,
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter description' : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Doctors Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consulting Doctors',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Select Doctors Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: AppButtonStyles.secondaryButton(height: 48),
                        onPressed: _showDoctorSelectionDialog,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Select Doctors',
                              style: AppTypography.buttonMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_selectedDoctorIds.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Selected Doctors (${_selectedDoctorIds.length})',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedDoctorIds.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final doctorId = _selectedDoctorIds[index];
                          final doctor = allDoctors.firstWhere(
                            (d) => d.id == doctorId,
                            orElse: () => allDoctors.first,
                          );
                          return Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppBorderRadius.md),
                              border: Border.all(color: AppColors.surface300),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.name,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        doctor.specialization,
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.quaternary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => _removeDoctorId(doctorId),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Submit Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: AppButtonStyles.primaryButton(height: 56),
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : Text(
                          isEditing ? 'Update Shop' : 'Add Shop',
                          style: AppTypography.buttonLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: AppTypography.body.copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.body.copyWith(color: AppColors.quaternary),
        prefixIcon: Icon(icon, color: AppColors.quaternary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }

  Widget _buildPhotoPickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo Preview
        if (_selectedPhoto != null || _photoController.text.isNotEmpty)
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: _selectedPhoto != null
                  ? Image.file(
                      File(_selectedPhoto!.path),
                      fit: BoxFit.cover,
                    )
                  : _photoController.text.startsWith('http')
                      ? Image.network(
                          _photoController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surface,
                            child: const Icon(
                              Iconsax.gallery,
                              size: 64,
                              color: AppColors.quaternary,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Iconsax.gallery,
                            size: 64,
                            color: AppColors.quaternary,
                          ),
                        ),
            ),
          ),
        // Photo Picker Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: AppButtonStyles.secondaryButton(height: 48),
            onPressed: _showPhotoPickerOptions,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.gallery),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _selectedPhoto != null || _photoController.text.isNotEmpty
                      ? 'Change Photo'
                      : 'Add Photo',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
