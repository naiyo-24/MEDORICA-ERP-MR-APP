import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/mr.dart';
import '../api_url.dart';

class ProfileService {
  ProfileService({Dio? dio}) : _dio = dio ?? _buildDio();

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

  Future<MedicalRepresentative> fetchProfileByMrId(String mrId) async {
    try {
      final Response<dynamic> response = await _dio.get(ApiUrl.mrGetById(mrId));
      final dynamic body = response.data;

      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid profile response from server');
      }

      final MedicalRepresentative parsed = MedicalRepresentative.fromJson(body);
      return parsed.copyWith(
        profileImage: _toAbsolutePhotoUrl(parsed.profileImage),
      );
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<MedicalRepresentative> updateProfileByMrId({
    required String mrId,
    required String fullName,
    required String phoneNo,
    required String password,
    String? altPhoneNo,
    String? email,
    String? address,
    DateTime? joiningDate,
    String? bankName,
    String? bankAccountNo,
    String? ifscCode,
    String? branchName,
    required bool active,
    String? profilePhotoPath,
  }) async {
    try {
      final Map<String, dynamic> fields = {
        'full_name': fullName,
        'phone_no': phoneNo,
        'password': password,
        'active': active.toString(),
      };

      if (altPhoneNo != null) {
        fields['alt_phone_no'] = altPhoneNo;
      }
      if (email != null) {
        fields['email'] = email;
      }
      if (address != null) {
        fields['address'] = address;
      }
      if (joiningDate != null) {
        fields['joining_date'] = DateFormat('yyyy-MM-dd').format(joiningDate);
      }
      if (bankName != null) {
        fields['bank_name'] = bankName;
      }
      if (bankAccountNo != null) {
        fields['bank_account_no'] = bankAccountNo;
      }
      if (ifscCode != null) {
        fields['ifsc_code'] = ifscCode;
      }
      if (branchName != null) {
        fields['branch_name'] = branchName;
      }
      if (profilePhotoPath != null && profilePhotoPath.trim().isNotEmpty) {
        fields['profile_photo'] = await MultipartFile.fromFile(
          profilePhotoPath,
        );
      }

      final FormData data = FormData.fromMap(fields);

      final Response<dynamic> response = await _dio.put(
        ApiUrl.mrUpdateById(mrId),
        data: data,
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid updated profile response from server');
      }

      final MedicalRepresentative parsed = MedicalRepresentative.fromJson(body);
      return parsed.copyWith(
        profileImage: _toAbsolutePhotoUrl(parsed.profileImage),
      );
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  String? _toAbsolutePhotoUrl(String? path) {
    if (path == null || path.isEmpty) {
      return path;
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (path.startsWith('assets/')) {
      return path;
    }

    final String normalizedPath = path.startsWith('/') ? path : '/$path';
    return '${ApiUrl.baseUrl}$normalizedPath';
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
