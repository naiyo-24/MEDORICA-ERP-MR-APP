import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/doctor.dart';
import '../api_url.dart';

class DoctorServices {
  DoctorServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  Future<List<Doctor>> fetchDoctorsByMrId(String mrId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.doctorNetworkMrGetByMrId(mrId),
      );

      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid doctor response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(Doctor.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<List<Doctor>> fetchAllDoctors() async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.doctorNetworkMrGetAll,
      );

      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid doctor response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(Doctor.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<Doctor> fetchDoctorByMrIdAndDoctorId({
    required String mrId,
    required String doctorId,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.doctorNetworkMrGetByMrIdAndDoctorId(mrId, doctorId),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid doctor response from server');
      }

      return Doctor.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<Doctor> createDoctor({
    required String mrId,
    required String doctorName,
    required String doctorPhoneNo,
    DateTime? doctorBirthday,
    String? doctorSpecialization,
    String? doctorQualification,
    String? doctorExperience,
    String? doctorDescription,
    List<DoctorChamber>? doctorChambers,
    String? doctorEmail,
    String? doctorAddress,
    String? doctorPhotoPath,
  }) async {
    try {
      final Map<String, dynamic> fields = <String, dynamic>{
        'mr_id': mrId,
        'doctor_name': doctorName,
        'doctor_phone_no': doctorPhoneNo,
      };

      if (doctorBirthday != null) {
        fields['doctor_birthday'] = _formatDateOnly(doctorBirthday);
      }
      if (doctorSpecialization != null &&
          doctorSpecialization.trim().isNotEmpty) {
        fields['doctor_specialization'] = doctorSpecialization;
      }
      if (doctorQualification != null &&
          doctorQualification.trim().isNotEmpty) {
        fields['doctor_qualification'] = doctorQualification;
      }
      if (doctorExperience != null && doctorExperience.trim().isNotEmpty) {
        fields['doctor_experience'] = doctorExperience;
      }
      if (doctorDescription != null && doctorDescription.trim().isNotEmpty) {
        fields['doctor_description'] = doctorDescription;
      }
      if (doctorChambers != null && doctorChambers.isNotEmpty) {
        fields['doctor_chambers'] = jsonEncode(
          doctorChambers
              .map((DoctorChamber chamber) => chamber.toJson())
              .toList(),
        );
      }
      if (doctorEmail != null && doctorEmail.trim().isNotEmpty) {
        fields['doctor_email'] = doctorEmail;
      }
      if (doctorAddress != null && doctorAddress.trim().isNotEmpty) {
        fields['doctor_address'] = doctorAddress;
      }
      if (doctorPhotoPath != null && doctorPhotoPath.trim().isNotEmpty) {
        fields['doctor_photo'] = await MultipartFile.fromFile(
          doctorPhotoPath,
          filename: doctorPhotoPath.split('/').last,
        );
      }

      final Response<dynamic> response = await _dio.post(
        ApiUrl.doctorNetworkMrPost,
        data: FormData.fromMap(fields),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid doctor response from server');
      }

      return Doctor.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<Doctor> updateDoctor({
    required String mrId,
    required String doctorId,
    String? doctorName,
    String? doctorPhoneNo,
    DateTime? doctorBirthday,
    String? doctorSpecialization,
    String? doctorQualification,
    String? doctorExperience,
    String? doctorDescription,
    List<DoctorChamber>? doctorChambers,
    String? doctorEmail,
    String? doctorAddress,
    String? doctorPhotoPath,
  }) async {
    try {
      final Map<String, dynamic> fields = <String, dynamic>{};

      if (doctorName != null && doctorName.trim().isNotEmpty) {
        fields['doctor_name'] = doctorName;
      }
      if (doctorPhoneNo != null && doctorPhoneNo.trim().isNotEmpty) {
        fields['doctor_phone_no'] = doctorPhoneNo;
      }
      if (doctorBirthday != null) {
        fields['doctor_birthday'] = _formatDateOnly(doctorBirthday);
      }
      if (doctorSpecialization != null &&
          doctorSpecialization.trim().isNotEmpty) {
        fields['doctor_specialization'] = doctorSpecialization;
      }
      if (doctorQualification != null &&
          doctorQualification.trim().isNotEmpty) {
        fields['doctor_qualification'] = doctorQualification;
      }
      if (doctorExperience != null && doctorExperience.trim().isNotEmpty) {
        fields['doctor_experience'] = doctorExperience;
      }
      if (doctorDescription != null && doctorDescription.trim().isNotEmpty) {
        fields['doctor_description'] = doctorDescription;
      }
      if (doctorChambers != null) {
        fields['doctor_chambers'] = jsonEncode(
          doctorChambers
              .map((DoctorChamber chamber) => chamber.toJson())
              .toList(),
        );
      }
      if (doctorEmail != null && doctorEmail.trim().isNotEmpty) {
        fields['doctor_email'] = doctorEmail;
      }
      if (doctorAddress != null && doctorAddress.trim().isNotEmpty) {
        fields['doctor_address'] = doctorAddress;
      }
      if (doctorPhotoPath != null && doctorPhotoPath.trim().isNotEmpty) {
        fields['doctor_photo'] = await MultipartFile.fromFile(
          doctorPhotoPath,
          filename: doctorPhotoPath.split('/').last,
        );
      }

      final Response<dynamic> response = await _dio.put(
        ApiUrl.doctorNetworkMrUpdateByMrIdAndDoctorId(mrId, doctorId),
        data: FormData.fromMap(fields),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid doctor response from server');
      }

      return Doctor.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  Future<void> deleteDoctor(String doctorId) async {
    try {
      await _dio.delete(ApiUrl.doctorNetworkMrDeleteByDoctorId(doctorId));
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

  String _formatDateOnly(DateTime value) {
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
