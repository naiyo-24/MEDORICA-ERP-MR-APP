import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/visual_ads.dart';
import '../api_url.dart';

class VisualAdsServices {
	VisualAdsServices({Dio? dio})
		: _dio =
					dio ??
					Dio(
						BaseOptions(
							baseUrl: ApiUrl.baseUrl,
							connectTimeout: const Duration(seconds: 20),
							receiveTimeout: const Duration(seconds: 20),
							sendTimeout: const Duration(seconds: 20),
						),
					) {
		if (!_dio.interceptors.any((it) => it is PrettyDioLogger)) {
			_dio.interceptors.add(
				PrettyDioLogger(
					requestBody: true,
					responseBody: true,
					requestHeader: true,
					responseHeader: false,
					compact: true,
					enabled: kDebugMode,
				),
			);
		}
	}

	final Dio _dio;

	Future<List<VisualAd>> fetchAllVisualAds() async {
		final response = await _dio.get(ApiUrl.visualAdsGetAll);
		final data = response.data;
		if (data is! List) {
			throw Exception('Invalid visual ads list response.');
		}

		return data
				.whereType<Map<String, dynamic>>()
				.map(VisualAd.fromJson)
				.toList();
	}

	Future<VisualAd> fetchVisualAdById(String adId) async {
		final response = await _dio.get(ApiUrl.visualAdsGetById(adId));
		final data = response.data;
		if (data is! Map<String, dynamic>) {
			throw Exception('Invalid visual ad response for $adId.');
		}

		return VisualAd.fromJson(data);
	}

	Future<List<VisualAd>> fetchAllVisualAdsOneByOneAndCache() async {
		final list = await fetchAllVisualAds();
		final resolved = <VisualAd>[];

		for (final item in list) {
			VisualAd ad;
			try {
				ad = await fetchVisualAdById(item.adId);
			} catch (_) {
				ad = item;
			}

			final cachedPath = await _downloadAdImageToLocal(ad);
			resolved.add(ad.copyWith(localImagePath: cachedPath));
		}

		return resolved;
	}

	Future<String?> _downloadAdImageToLocal(VisualAd ad) async {
		final imageUrl = _normalizeImageUrl(ad.adImage);
		if (imageUrl == null) {
			return null;
		}

		final dir = await _offlineAdsDirectory();
		if (!await dir.exists()) {
			await dir.create(recursive: true);
		}

		final extension = _extractExtensionFromUrl(imageUrl);
		final file = File('${dir.path}/${ad.adId}$extension');

		if (await file.exists() && await file.length() > 0) {
			return file.path;
		}

		try {
			await _dio.download(imageUrl, file.path);
			if (await file.exists() && await file.length() > 0) {
				return file.path;
			}
		} catch (_) {
			return null;
		}

		return null;
	}

	Future<Directory> _offlineAdsDirectory() async {
		final appDocDir = await getApplicationDocumentsDirectory();
		return Directory('${appDocDir.path}/visual_ads_cache');
	}

	String? _normalizeImageUrl(String? adImage) {
		if (adImage == null || adImage.trim().isEmpty) {
			return null;
		}

		final trimmed = adImage.trim();
		if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
			return trimmed;
		}

		if (trimmed.startsWith('/')) {
			return ApiUrl.getFullUrl(trimmed);
		}

		return ApiUrl.getFullUrl('/$trimmed');
	}

	String _extractExtensionFromUrl(String url) {
		final uri = Uri.tryParse(url);
		final path = uri?.path ?? url;
		final dot = path.lastIndexOf('.');
		if (dot == -1) {
			return '.jpg';
		}
		return path.substring(dot);
	}
}