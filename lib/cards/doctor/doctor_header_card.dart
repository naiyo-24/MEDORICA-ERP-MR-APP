import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../models/doctor.dart';
import '../../../services/api_url.dart';

class DoctorHeaderCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorHeaderCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            child: doctor.photo.isNotEmpty
                ? Image.network(
                    ApiUrl.getFullUrl(doctor.photo),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  )
                : Container(
                    color: AppColors.primaryLight,
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
          ),
          // Dark Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
                stops: [0.4, 1.0],
              ),
            ),
          ),
          // Doctor Name
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: AppTypography.h2.copyWith(color: AppColors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  doctor.specialization,
                  style: AppTypography.tagline.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
