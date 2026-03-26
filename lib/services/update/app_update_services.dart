import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';
import '../api_url.dart';

class AppUpdateServices {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> fetchLatestVersionInfo() async {
    try {
      final response = await _dio.get(
        ApiUrl.getFullUrl(ApiUrl.mrAppUpdatesLatestVersion),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> fetchAllVersions() async {
    try {
      final response = await _dio.get(
        ApiUrl.getFullUrl(ApiUrl.mrAppUpdatesVersions),
      );
      if (response.statusCode == 200 && response.data['versions'] != null) {
        return List<String>.from(response.data['versions']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<String?> downloadLatestApk({Function(double)? onProgress}) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return null;
      final savePath = '${dir.path}/mr_app_latest.apk';
      await _dio.download(
        ApiUrl.getFullUrl(ApiUrl.mrAppUpdatesDownloadLatest),
        savePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total != -1) {
            onProgress(received / total);
          }
        },
      );
      return savePath;
    } catch (e) {
      return null;
    }
  }

  Future<void> openApkFile(String filePath) async {
    final flutterAppInstaller = FlutterAppInstaller();
    await flutterAppInstaller.installApk(
      filePath: filePath,
    );
  }
}
