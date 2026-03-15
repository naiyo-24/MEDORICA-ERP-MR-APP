import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/chemist_shop.dart';
import '../../provider/chemist_shop_provider.dart';
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
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  XFile? _selectedPhoto;
  XFile? _selectedBankPassbookPhoto;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final shop = widget.shop;
    _nameController = TextEditingController(text: shop?.name ?? '');
    _phoneController = TextEditingController(text: shop?.phoneNumber ?? '');
    _emailController = TextEditingController(text: shop?.email ?? '');
    _locationController = TextEditingController(text: shop?.location ?? '');
    _descriptionController =
        TextEditingController(text: shop?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    try {
      return await _imagePicker.pickImage(source: source, imageQuality: 85);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
      return null;
    }
  }

  void _showPhotoPickerOptions({required bool isBankPassbook}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Iconsax.gallery, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final file = await _pickImage(ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    if (isBankPassbook) {
                      _selectedBankPassbookPhoto = file;
                    } else {
                      _selectedPhoto = file;
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.camera, color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final file = await _pickImage(ImageSource.camera);
                if (file != null) {
                  setState(() {
                    if (isBankPassbook) {
                      _selectedBankPassbookPhoto = file;
                    } else {
                      _selectedPhoto = file;
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _loading = true);

    // Resolve photo paths: prefer newly picked local file, else keep existing
    final String shopPhotoPath = _selectedPhoto?.path ?? widget.shop?.photo ?? '';
    final String bankPassbookPath =
        _selectedBankPassbookPhoto?.path ?? widget.shop?.bankPassbookPhoto ?? '';

    final shop = ChemistShop(
      id: widget.shop?.id ?? '',
      mrId: widget.shop?.mrId,
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photo: shopPhotoPath,
      bankPassbookPhoto: bankPassbookPath.isNotEmpty ? bankPassbookPath : null,
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (widget.shop == null) {
      await ref.read(chemistShopProvider.notifier).addChemistShop(shop);
    } else {
      await ref.read(chemistShopProvider.notifier).updateChemistShop(shop);
    }

    if (!mounted) return;

    final String? error = ref.read(chemistShopProvider).error;
    if (error != null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.shop == null
              ? 'Shop added successfully'
              : 'Shop updated successfully',
        ),
      ),
    );
    context.go('/mr/chemist');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.shop != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_circle_left, color: AppColors.primary),
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
              // Shop Name (required)
              _buildTextFormField(
                controller: _nameController,
                label: 'Shop Name *',
                icon: Iconsax.shop,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter shop name' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone Number (required)
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number *',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter phone number' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Email (optional)
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                icon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),

              // Address / Location (optional)
              _buildTextFormField(
                controller: _locationController,
                label: 'Address',
                icon: Iconsax.location,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),

              // Description (optional)
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Description',
                icon: Iconsax.document_text,
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Shop Photo
              _buildPhotoPickerField(
                label: 'Shop Photo',
                icon: Iconsax.shop,
                selectedFile: _selectedPhoto,
                existingUrl: widget.shop?.photo,
                onPickTapped: () =>
                    _showPhotoPickerOptions(isBankPassbook: false),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Bank Passbook Photo
              _buildPhotoPickerField(
                label: 'Bank Passbook Photo',
                icon: Iconsax.wallet,
                selectedFile: _selectedBankPassbookPhoto,
                existingUrl: widget.shop?.bankPassbookPhoto,
                onPickTapped: () =>
                    _showPhotoPickerOptions(isBankPassbook: true),
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

  Widget _buildPhotoPickerField({
    required String label,
    required IconData icon,
    required XFile? selectedFile,
    required String? existingUrl,
    required VoidCallback onPickTapped,
  }) {
    final bool hasPhoto =
        selectedFile != null || (existingUrl != null && existingUrl.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (hasPhoto)
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: selectedFile != null
                  ? Image.file(File(selectedFile.path), fit: BoxFit.cover)
                  : (existingUrl!.startsWith('http')
                      ? Image.network(
                          existingUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _photoPlaceholder(icon),
                        )
                      : _photoPlaceholder(icon)),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: AppButtonStyles.secondaryButton(height: 48),
            onPressed: onPickTapped,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(hasPhoto ? Iconsax.refresh : icon),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  hasPhoto ? 'Change $label' : 'Add $label',
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

  Widget _photoPlaceholder(IconData icon) {
    return Container(
      color: AppColors.surface,
      child: Center(child: Icon(icon, size: 48, color: AppColors.quaternary)),
    );
  }
}
