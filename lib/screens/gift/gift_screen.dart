import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/gift.dart';
import '../../provider/gift_provider.dart';
import '../../provider/doctor_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/gift/gift_filter_card.dart';
import '../../cards/gift/gift_card.dart';

class GiftScreen extends ConsumerStatefulWidget {
  const GiftScreen({super.key});

  @override
  ConsumerState<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends ConsumerState<GiftScreen> {
  DateTime? _selectedDate;
  String? _selectedDoctorId;
  GiftStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final gifts = ref.watch(giftProvider);
    final doctors = ref.watch(doctorProvider);

    // Apply filters
    final filteredGifts = _filterGifts(gifts);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go('/home');
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: MRAppBar(
          showBack: true,
          showActions: false,
          titleText: 'Gift Management',
          subtitleText: 'Send & Track Gifts',
          onBack: () => context.go('/home'),
        ),
        body: Column(
          children: [
            // Filter Card
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GiftFilterCard(
                selectedDate: _selectedDate,
                selectedDoctorId: _selectedDoctorId,
                selectedStatus: _selectedStatus,
                doctorNames: doctors.map((d) => d.name).toList(),
                onDateFilterChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                onDoctorFilterChanged: (doctorId) {
                  setState(() {
                    _selectedDoctorId = doctorId;
                  });
                },
                onStatusFilterChanged: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),
            ),

            // Gifts List
            Expanded(
              child: filteredGifts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: filteredGifts.length,
                      itemBuilder: (context, index) {
                        final gift = filteredGifts[index];
                        return GiftCard(gift: gift);
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/gifts/send'),
          backgroundColor: AppColors.primary,
          icon: const Icon(Iconsax.gift, color: AppColors.white),
          label: Text(
            'Gift a Doctor',
            style: AppTypography.buttonMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  List<Gift> _filterGifts(List<Gift> gifts) {
    var filtered = gifts;

    // Filter by date
    if (_selectedDate != null) {
      filtered = filtered
          .where((gift) =>
              gift.date.year == _selectedDate!.year &&
              gift.date.month == _selectedDate!.month &&
              gift.date.day == _selectedDate!.day)
          .toList();
    }

    // Filter by doctor
    if (_selectedDoctorId != null) {
      filtered = filtered
          .where((gift) => gift.doctorId == _selectedDoctorId)
          .toList();
    }

    // Filter by status
    if (_selectedStatus != null) {
      filtered = filtered.where((gift) => gift.status == _selectedStatus).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return filtered;
  }

  Widget _buildEmptyState() {
    final hasActiveFilters =
        _selectedDate != null || _selectedDoctorId != null || _selectedStatus != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters ? Iconsax.search_status : Iconsax.gift,
              size: 80,
              color: AppColors.quaternary.withAlpha(127),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasActiveFilters ? 'No gifts found' : 'No gifts yet',
              style: AppTypography.h3.copyWith(
                color: AppColors.quaternary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasActiveFilters
                  ? 'Try adjusting your filters'
                  : 'Send your first gift to a doctor',
              style: AppTypography.body.copyWith(
                color: AppColors.quaternary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (!hasActiveFilters)
              ElevatedButton.icon(
                onPressed: () => context.push('/gifts/send'),
                style: AppButtonStyles.primaryButton(height: 44),
                icon: const Icon(Iconsax.gift, color: AppColors.white),
                label: Text(
                  'Send Gift',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
