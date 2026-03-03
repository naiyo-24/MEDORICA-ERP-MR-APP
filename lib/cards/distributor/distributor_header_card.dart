import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorHeaderCard extends StatelessWidget {
  final Distributor distributor;

  const DistributorHeaderCard({super.key, required this.distributor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Dark Overlay
        Container(
          height: 260,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppBorderRadius.xl),
              bottomRight: Radius.circular(AppBorderRadius.xl),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppBorderRadius.xl),
              bottomRight: Radius.circular(AppBorderRadius.xl),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                distributor.photo.startsWith('http')
                    ? Image.network(
                        distributor.photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Iconsax.truck,
                            size: 80,
                            color: AppColors.quaternary,
                          ),
                        ),
                      )
                    : Image.asset(
                        distributor.photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Iconsax.truck,
                            size: 80,
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                // Dark Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(76),
                        Colors.black.withAlpha(178),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Distributor Name and Location
        Positioned(
          bottom: AppSpacing.xl,
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distributor Name
              Text(
                distributor.name,
                style: AppTypography.h1.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Location
              Row(
                children: [
                  const Icon(
                    Iconsax.location,
                    size: 20,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      distributor.location,
                      style: AppTypography.body.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
