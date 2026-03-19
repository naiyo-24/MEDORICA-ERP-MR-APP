
import 'package:flutter/material.dart';
import 'package:mr_app/services/update/app_update_services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateScreen extends StatefulWidget {
  const AppUpdateScreen({super.key});

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
      await AppUpdateServices().openApkFile(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_shouldUpdate) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('App Update Available')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.system_update, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'A new version ($_latestVersion) is available!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_downloading)
              Column(
                children: [
                  LinearProgressIndicator(value: _progress),
                  const SizedBox(height: 8),
                  Text(
                    'Downloading... ${(100 * _progress).toStringAsFixed(0)}%',
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download & Install Update'),
                onPressed: _downloadAndInstall,
              ),
            if (_downloadedFilePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Downloaded to: $_downloadedFilePath'),
              ),
          ],
        ),
      ),
    );
  }
}
