import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mr_app/services/update/app_update_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mr_app/theme/app_theme.dart';

class AppUpdateScreen extends StatefulWidget {
  final VoidCallback? onUpdateComplete;
  const AppUpdateScreen({super.key, this.onUpdateComplete});

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  String? _latestVersion;
  // String? _apkFileName;
  // String? _apkUrl;
  bool _loading = true;
  bool _downloading = false;
  double _progress = 0.0;
  String? _downloadedFilePath;
  String? _currentVersion;

  bool _installerLaunched = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    setState(() => _loading = true);
    final info = await PackageInfo.fromPlatform();
    _currentVersion = info.version;
    final data = await AppUpdateServices().fetchLatestVersionInfo();
    setState(() {
      _latestVersion = data?['version'];
      _loading = false;
    });
  }

  bool get _shouldUpdate {
    if (_latestVersion == null || _currentVersion == null) return false;
    // Compare only version numbers (strip .apk if present)
    final latest = _latestVersion!.replaceAll('.apk', '');
    return latest != _currentVersion;
  }

  Future<void> _downloadAndInstall() async {
    setState(() {
      _downloading = true;
      _progress = 0.0;
    });
    final filePath = await AppUpdateServices().downloadLatestApk(
      onProgress: (p) => setState(() => _progress = p),
    );
    setState(() {
      _downloading = false;
      _downloadedFilePath = filePath;
    });
    if (filePath != null) {
      setState(() => _installerLaunched = true);
      await AppUpdateServices().openApkFile(filePath);
      // Give Android ~1 second to fully receive the installer intent and bring
      // the Package Installer activity to the foreground before we kill the
      // old process. Without this delay there is a race: exit(0) can fire
      // before the OS has delivered the Intent, causing the installer to never appear.
      await Future.delayed(const Duration(milliseconds: 1000));
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_shouldUpdate) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.huge),
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          decoration: BoxDecoration(
            borderRadius: AppBorderRadius.xlRadius,
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColorDark,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight,
                ),
                child: const Icon(
                  Icons.system_update,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'App Update Available',
                style: AppTypography.h2.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'A new version ($_latestVersion) is ready to download.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_downloading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: _progress,
                      minHeight: 6,
                      backgroundColor: AppColors.surface200,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Downloading... ${(100 * _progress).toStringAsFixed(0)}%',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppButtonStyles.primaryButton(),
                    onPressed: _installerLaunched ? null : _downloadAndInstall,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download, size: 20),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          _installerLaunched
                              ? 'Installing...'
                              : 'Download & Install Update',
                          style: AppTypography.buttonMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_downloadedFilePath != null && !_installerLaunched)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Text(
                    'Downloaded to: $_downloadedFilePath',
                    style: AppTypography.caption.copyWith(color: AppColors.secondary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
