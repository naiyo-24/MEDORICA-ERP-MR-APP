import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorCard extends StatelessWidget {
  final Distributor distributor;
  final VoidCallback onTap;

  const DistributorCard({
    super.key,
    required this.distributor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final photoPath = distributor.photoUrl?.trim();
    final hasPhoto = photoPath != null && photoPath.isNotEmpty;
    final isNetworkPhoto =
        hasPhoto &&
        (photoPath.startsWith('http://') || photoPath.startsWith('https://'));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.primaryLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Section
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: AppColors.primaryLight,
              ),
              child: hasPhoto
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: isNetworkPhoto
                              ? Image.network(
                                  photoPath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultPhotoContainer();
                                  },
                                )
                              : Image.file(
                                  File(photoPath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultPhotoContainer();
                                  },
                                ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(140),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              distributor.id,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildDefaultPhotoContainer(),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    distributor.name,
                    style: AppTypography.h3.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        color: AppColors.quaternary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          distributor.location ?? 'Location not available',
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Phone
                  Row(
                    children: [
                      Icon(Iconsax.call, color: AppColors.quaternary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          distributor.phoneNo,
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPhotoContainer() {
    return Container(
      color: AppColors.primaryLight.withAlpha(100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.image, size: 56, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              'No Photo',
              style: AppTypography.body.copyWith(
                color: AppColors.quaternary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}