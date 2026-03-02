import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';
import '../../cards/doctor/doctor_card.dart' show DoctorCard;
import '../../cards/doctor/doctor_search_bar_card.dart';
import '../../provider/doctor_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyDoctorScreen extends ConsumerStatefulWidget {
  const MyDoctorScreen({super.key});

  @override
  ConsumerState<MyDoctorScreen> createState() => _MyDoctorScreenState();
}

class _MyDoctorScreenState extends ConsumerState<MyDoctorScreen> {
  String _searchQuery = '';
  String _selectedSpecialization = '';

  @override
  Widget build(BuildContext context) {
    final allDoctors = ref.watch(doctorProvider);
    final specializations = ref.watch(specializationsProvider);

    // Filter doctors based on search and specialization
    var filteredDoctors = allDoctors.where((doctor) {
      final matchesSearch = _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialization
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesSpecialization = _selectedSpecialization.isEmpty ||
          doctor.specialization == _selectedSpecialization;

      return matchesSearch && matchesSpecialization;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MRAppBar(
        showBack: false,
        showActions: false,
        titleText: 'My Doctors',
        subtitleText: 'List of doctors you manage',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/mr/doctor/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Search Bar
            DoctorSearchBarCard(
              onSearchChanged: (value) {
                setState(() => _searchQuery = value);
              },
              onFilterChanged: (value) {
                setState(() => _selectedSpecialization = value);
              },
              specializations: specializations,
              selectedSpecialization: _selectedSpecialization.isEmpty
                  ? null
                  : _selectedSpecialization,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Doctor List
            if (filteredDoctors.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xxxl,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.user_search,
                        size: 64,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No doctors found',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Try adjusting your search or add a new doctor',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.tertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDoctors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  return DoctorCard(doctor: filteredDoctors[index]);
                },
              ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 1),
    );
  }
}