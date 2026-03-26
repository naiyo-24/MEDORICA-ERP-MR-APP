import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'services/update/app_update_services.dart';
import 'widgets/app_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mr_app/notifiers/auth_notifier.dart';
import 'package:mr_app/provider/gift_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'provider/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shouldShowUpdateScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final showUpdate = snapshot.data == true;
        if (showUpdate) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AppUpdateScreen(),
          );
        }
        return Consumer(
          builder: (context, ref, _) {
            ref.listen<AuthState>(authNotifierProvider, (previous, next) {
              final mrId = next.mr?.mrId;
              ref.read(currentMrIdProvider.notifier).state = mrId;
            });
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                AppRouter.router.go(AppRouter.home);
              },
              child: MaterialApp.router(
                title: 'Medorica MR App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                routerConfig: AppRouter.router,
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _shouldShowUpdateScreen() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentBuildNumber = info.buildNumber;
      if (kDebugMode) {
        print('Current app build number: $currentBuildNumber');
      }
      final data = await AppUpdateServices().fetchLatestVersionInfo();
      if (kDebugMode) {
        print('Backend response: $data');
      }
      final latestVersion = data?['version'];
      if (kDebugMode) {
        print('Latest APK version from backend: $latestVersion');
      }
      if (latestVersion == null) return false;
      // Extract build number from backend APK filename
      final latestBuildNumber = RegExp(r'_(\d+)\.apk').firstMatch(latestVersion)?.group(1);
      if (kDebugMode) {
        print('Extracted latest build number: $latestBuildNumber');
      }
      final needsUpdate = latestBuildNumber != currentBuildNumber;
      if (kDebugMode) {
        print('Needs update? $needsUpdate');
      }
      return needsUpdate;
    } catch (e) {
      if (kDebugMode) {
        print('Error in update check: $e');
      }
      return false;
    }
  }
}
