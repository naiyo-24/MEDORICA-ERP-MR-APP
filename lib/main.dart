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
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final showUpdate = snapshot.data == true;
        if (showUpdate) {
          return const MaterialApp(home: AppUpdateScreen());
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
                if (didPop) {
                  return;
                }
                // Prevent app from exiting - navigate to home instead
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
      final currentVersion = info.version;
      final data = await AppUpdateServices().fetchLatestVersionInfo();
      final latestVersion = data?['version'];
      if (latestVersion == null) return false;
      final latest = latestVersion.replaceAll('.apk', '');
      return latest != currentVersion;
    } catch (_) {
      return false;
    }
  }
}
