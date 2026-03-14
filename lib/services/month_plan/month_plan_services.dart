import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/month_plan.dart';
import '../api_url.dart';

class MonthPlanServices {
  MonthPlanServices({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );

    return dio;
  }

  Future<List<MonthPlan>> fetchMonthPlansByMrId(String mrId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.monthlyPlanGetByMr(mrId),
      );

      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid monthly plan response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(MonthPlan.fromBackendMrPlanJson)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<MonthPlan> fetchMonthPlanByMrIdAndDate({
    required String mrId,
    required DateTime planDate,
  }) async {
    try {
      final String dateStr =
          '${planDate.year.toString().padLeft(4, '0')}-'
          '${planDate.month.toString().padLeft(2, '0')}-'
          '${planDate.day.toString().padLeft(2, '0')}';

      final Response<dynamic> response = await _dio.get(
        ApiUrl.monthlyPlanGetByMrAndDate(mrId, dateStr),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid monthly plan response from server');
      }

      return MonthPlan.fromBackendMrPlanJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  String _readDioError(DioException e) {
    final dynamic body = e.response?.data;
    if (body is Map<String, dynamic>) {
      final dynamic detail = body['detail'] ?? body['message'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        return detail.toString();
      }
    }
    return e.message ?? 'Request failed';
  }
}
