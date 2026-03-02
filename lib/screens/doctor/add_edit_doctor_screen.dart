import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../models/doctor.dart';
import '../../provider/doctor_provider.dart';

class AddEditDoctorScreen extends ConsumerStatefulWidget {
  final Doctor? doctor;

  const AddEditDoctorScreen({super.key, this.doctor});

  @override
  ConsumerState<AddEditDoctorScreen> createState() =>
      _AddEditDoctorScreenState();
}

class _AddEditDoctorScreenState extends ConsumerState<AddEditDoctorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _photoController;
  late TextEditingController _specializationController;
  late TextEditingController _experienceController;
  late TextEditingController _qualificationController;
  late TextEditingController _descriptionController;
  late TextEditingController _chamberNameController;
  late TextEditingController _chamberAddressController;
  late TextEditingController _chamberPhoneController;

  final _formKey = GlobalKey<FormState>();
  List<DoctorChamber> _chambers = [];
  bool _loading = false;
  XFile? _selectedPhoto;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final doctor = widget.doctor;
    _nameController = TextEditingController(text: doctor?.name ?? '');
    _phoneController = TextEditingController(text: doctor?.phoneNumber ?? '');
    _emailController = TextEditingController(text: doctor?.email ?? '');
    _photoController = TextEditingController(text: doctor?.photo ?? '');
    _specializationController =
        TextEditingController(text: doctor?.specialization ?? '');
    _experienceController =
        TextEditingController(text: doctor?.experience ?? '');
    _qualificationController =
        TextEditingController(text: doctor?.qualification ?? '');
    _descriptionController =
        TextEditingController(text: doctor?.description ?? '');
    _chamberNameController = TextEditingController();
    _chamberAddressController = TextEditingController();
    _chamberPhoneController = TextEditingController();
    _chambers = doctor?.chambers ?? [];
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _photoController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _qualificationController.dispose();
    _descriptionController.dispose();
    _chamberNameController.dispose();
    _chamberAddressController.dispose();
    _chamberPhoneController.dispose();
    super.dispose();
  }

  void _addChamber() {
    if (_chamberNameController.text.isEmpty ||
        _chamberAddressController.text.isEmpty ||
        _chamberPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all chamber details')),
      );
      return;
    }

    setState(() {
      _chambers.add(
        DoctorChamber(
          id: DateTime.now().toString(),
          name: _chamberNameController.text,
          address: _chamberAddressController.text,
          phoneNumber: _chamberPhoneController.text,
        ),
      );
      _chamberNameController.clear();
      _chamberAddressController.clear();
      _chamberPhoneController.clear();
    });
  }

  void _removeChamber(int index) {
    setState(() => _chambers.removeAt(index));
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _chambers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and add at least one chamber'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final doctor = Doctor(
      id: widget.doctor?.id ?? DateTime.now().toString(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photo: _photoController.text.trim(),
      specialization: _specializationController.text.trim(),
      experience: _experienceController.text.trim(),
      qualification: _qualificationController.text.trim(),
      description: _descriptionController.text.trim(),
      chambers: _chambers,
    );

    if (widget.doctor == null) {
      ref.read(doctorProvider.notifier).addDoctor(doctor);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor added successfully')),
      );
    } else {
      ref.read(doctorProvider.notifier).updateDoctor(doctor);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor updated successfully')),
      );
    }

    setState(() => _loading = false);
    context.go('/mr/doctor');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.doctor != null;

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
              isEditing ? 'Edit Doctor' : 'Add Doctor',
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
            Text(
              isEditing ? 'Update doctor details' : 'Add new doctor details',
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
              // Doctor Name
              _buildTextFormField(
                controller: _nameController,
                label: 'Doctor Name',
                icon: Iconsax.user,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter doctor name' : null,
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

              // Specialization
              _buildTextFormField(
                controller: _specializationController,
                label: 'Specialization',
                icon: Iconsax.medal_star,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter specialization' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Experience
              _buildTextFormField(
                controller: _experienceController,
                label: 'Experience (e.g., 15 years)',
                icon: Iconsax.briefcase,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter experience' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Qualification
              _buildTextFormField(
                controller: _qualificationController,
                label: 'Qualification',
                icon: Iconsax.book,
                maxLines: 2,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter qualification' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Description',
                icon: Iconsax.document,
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter description' : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Chambers Section
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
                      'Chambers',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Chamber Name
                    _buildTextFormField(
                      controller: _chamberNameController,
                      label: 'Chamber Name',
                      icon: Iconsax.hospital,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Chamber Address
                    _buildTextFormField(
                      controller: _chamberAddressController,
                      label: 'Chamber Address',
                      icon: Iconsax.location,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Chamber Phone
                    _buildTextFormField(
                      controller: _chamberPhoneController,
                      label: 'Chamber Phone',
                      icon: Iconsax.call,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Add Chamber Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: AppButtonStyles.secondaryButton(height: 48),
                        onPressed: _addChamber,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Add Chamber',
                              style: AppTypography.buttonMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_chambers.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Added Chambers (${_chambers.length})',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _chambers.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final chamber = _chambers[index];
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
                                        chamber.name,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        chamber.address,
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.quaternary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: AppColors.error,
                                    size: 18,
                                  ),
                                  onPressed: () => _removeChamber(index),
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
              const SizedBox(height: AppSpacing.lg),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: AppButtonStyles.primaryButton(height: 56),
                        onPressed: _submit,
                        child: Text(
                          isEditing ? 'Update Doctor' : 'Add Doctor',
                          style: AppTypography.buttonLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
              ),
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.body.copyWith(
          color: AppColors.quaternary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPhotoPickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doctor Photo',
          style: AppTypography.body.copyWith(
            color: AppColors.quaternary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Photo Preview
              if (_selectedPhoto != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.lg - 1),
                      topRight: Radius.circular(AppBorderRadius.lg - 1),
                    ),
                    color: AppColors.surface,
                  ),
                  child: Image.file(
                    File(_selectedPhoto!.path),
                    fit: BoxFit.cover,
                  ),
                )
              else if (_photoController.text.isNotEmpty &&
                  !_photoController.text.startsWith('/'))
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.lg - 1),
                      topRight: Radius.circular(AppBorderRadius.lg - 1),
                    ),
                    color: AppColors.surface,
                  ),
                  child: Image.network(
                    _photoController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: const Icon(
                          Iconsax.image,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.lg - 1),
                      topRight: Radius.circular(AppBorderRadius.lg - 1),
                    ),
                    color: AppColors.surface,
                  ),
                  child: const Icon(
                    Iconsax.image,
                    size: 48,
                    color: AppColors.quaternary,
                  ),
                ),
              // Pick Button
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: ListTile(
                  onTap: _pickPhotoFromGallery,
                  horizontalTitleGap: AppSpacing.md,
                  leading: const Icon(
                    Iconsax.gallery,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    _selectedPhoto != null ? 'Change Photo' : 'Select from Gallery',
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Iconsax.arrow_right,
                    color: AppColors.quaternary,
                    size: 18,
                  ),
                ),
              ),
              // File Path Display
              if (_photoController.text.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border),
                    ),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Photo:',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _selectedPhoto?.name ?? 'Network Image',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}