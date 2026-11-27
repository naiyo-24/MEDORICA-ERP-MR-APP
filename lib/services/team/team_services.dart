import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../services/api_url.dart';
import '../../models/team.dart';

class TeamServices {
  final Dio _dio;

  TeamServices({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.interceptors.add(PrettyDioLogger());
  }

  Future<List<Team>> getTeamsByMrId(String mrId) async {
  final url = ApiUrl.getFullUrl(ApiUrl.teamGetByMrId(mrId));

  try {
    final response = await _dio.get(
      url,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // No team available
    if (response.statusCode == 404) {
      return [];
    }

    throw Exception('Failed to load teams');
  } on DioException {
    rethrow;
  }
}
}
