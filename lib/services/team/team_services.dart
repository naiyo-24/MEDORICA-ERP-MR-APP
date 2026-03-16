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
    final response = await _dio.get(url);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load teams');
    }
  }
}
