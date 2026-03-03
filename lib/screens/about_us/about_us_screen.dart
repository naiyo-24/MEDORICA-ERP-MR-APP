import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cards/about_us/about_us_header_card.dart';
import '../../cards/about_us/about_us_description_card.dart';
import '../../cards/about_us/about_us_director_card.dart';
import '../../cards/about_us/about_us_contact_us_card.dart';
import '../../cards/home/home_footer.dart';
import '../../provider/about_us_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUs = ref.watch(aboutUsProvider);
    final isLoading = ref.watch(aboutUsLoadingProvider);
    final error = ref.watch(aboutUsErrorProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'About Us',
        subtitleText: 'Learn about Medorica Pharma',
        onBack: () => context.pop(),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        error,
                        style: AppTypography.body.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(aboutUsNotifierProvider).refresh();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : aboutUs == null
                  ? const Center(
                      child: Text('No information available'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.sm),
                          // Header Card with Logo and Company Name
                          AboutUsHeaderCard(
                            companyName: aboutUs.companyName,
                          ),
                          // Description Card
                          AboutUsDescriptionCard(
                            description: aboutUs.description,
                          ),
                          // Director Card
                          AboutUsDirectorCard(
                            directorName: aboutUs.directorName,
                            directorMessage: aboutUs.directorMessage,
                            directorPhotoUrl: aboutUs.directorPhotoUrl,
                          ),
                          // Contact Us Card
                          AboutUsContactUsCard(
                            phone: aboutUs.phone,
                            email: aboutUs.email,
                            address: aboutUs.address,
                            mapUrl: aboutUs.mapUrl,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          HomeFooter(),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
    );
  }
}
