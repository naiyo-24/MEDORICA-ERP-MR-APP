import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mr_app/cards/home/home_footer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_options_card.dart';
import '../../provider/profile_provider.dart';
import '../../provider/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchCurrentMrProfile();
    });
  }

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'My Profile',
        subtitleText: 'View and manage your profile',
        onBack: () => context.pop(),
        actions: [
          IconButton(
            tooltip: isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state = isDarkMode
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: profile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profileNotifier.error ?? 'Loading profile...',
                    style: AppTypography.body.copyWith(
                      color: AppColors.quaternary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (profileNotifier.error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(profileProvider.notifier)
                            .fetchCurrentMrProfile();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  ProfileHeaderCard(profile: profile),

                  const SizedBox(height: AppSpacing.lg),

                  // Profile Options
                  ProfileOptionsCard(
                    onUpdateProfile: () {
                      context.push('/profile/update');
                    },
                    onAboutUs: () {
                      context.push('/about-us');
                    },
                    onContactSupport: () {
                      _launchPhoneDialer('+916289398298');
                    },
                    onNotifications: () {
                      context.push('/notifications');
                    },
                    onSalarySlip: () async {
                      await ref
                          .read(profileProvider.notifier)
                          .downloadSalarySlipForCurrentMr();
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  HomeFooter(),
                ],
              ),
            ),
    );
  }
}
