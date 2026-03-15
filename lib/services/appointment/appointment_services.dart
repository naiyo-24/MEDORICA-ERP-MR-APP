import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/appointment.dart';
import '../api_url.dart';

class AppointmentServices {
  AppointmentServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 30),
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
  final DateFormat _dateOnly = DateFormat('yyyy-MM-dd');

  Future<List<Appointment>> fetchAppointmentsBymrId(String mrId) async {
    try {
      final response = await _dio.get(ApiUrl.appointmentGetBymrId(mrId));
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid appointment list response from server.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(Appointment.fromJson)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load appointments right now.');
    }
  }

  Future<Appointment> fetchAppointmentById(String appointmentId) async {
    try {
      final response = await _dio.get(ApiUrl.appointmentGetById(appointmentId));
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid appointment response from server.');
      }

      return Appointment.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load appointment details right now.');
    }
  }

  Future<Appointment> createAppointment({
    required String mrId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    try {
      final formData = await _buildAppointmentFormData(
        mrId: mrId,
        appointment: appointment,
        includeRequired: true,
        completionPhotoProofPath: completionPhotoProofPath,
      );

      final response = await _dio.post(
        ApiUrl.appointmentAsmPost,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid appointment create response from server.');
      }

      return Appointment.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to create appointment right now.');
    }
  }

  Future<Appointment> updateAppointmentById({
    required String appointmentId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    try {
      final formData = await _buildAppointmentFormData(
        mrId: null,
        appointment: appointment,
        includeRequired: false,
        completionPhotoProofPath: completionPhotoProofPath,
      );

      final response = await _dio.put(
        ApiUrl.appointmentUpdateById(appointmentId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid appointment update response from server.');
      }

      return Appointment.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to update appointment right now.');
    }
  }

  Future<void> deleteAppointmentById(String appointmentId) async {
    try {
      await _dio.delete(ApiUrl.appointmentDeleteById(appointmentId));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to delete appointment right now.');
    }
  }

  Future<FormData> _buildAppointmentFormData({
    required String? mrId,
    required Appointment appointment,
    required bool includeRequired,
    String? completionPhotoProofPath,
  }) async {
    final fields = <MapEntry<String, dynamic>>[];

    if (includeRequired && mrId != null) {
      fields.add(MapEntry('mr_id', mrId));
      fields.add(MapEntry('doctor_id', appointment.doctorId));
      fields.add(
        MapEntry('appointment_date', _dateOnly.format(appointment.date)),
      );
      fields.add(MapEntry('appointment_time', appointment.time));
    } else {
      fields.add(
        MapEntry('appointment_date', _dateOnly.format(appointment.date)),
      );
      fields.add(MapEntry('appointment_time', appointment.time));
    }

    if (appointment.message.trim().isNotEmpty) {
      fields.add(MapEntry('place', appointment.message.trim()));
    }

    fields.add(MapEntry('status', appointment.status.apiValue));

    if (appointment.visualAds.isNotEmpty) {
      final serialized = jsonEncode(
        appointment.visualAds.map((ad) => ad.toJson()).toList(),
      );
      fields.add(MapEntry('visual_ads', serialized));
    }

    final formData = FormData.fromMap(Map.fromEntries(fields));

    if (completionPhotoProofPath != null &&
        completionPhotoProofPath.trim().isNotEmpty) {
      final trimmedPath = completionPhotoProofPath.trim();
      final file = File(trimmedPath);
      if (await file.exists()) {
        formData.files.add(
          MapEntry(
            'completion_photo_proof',
            await MultipartFile.fromFile(
              trimmedPath,
              filename: trimmedPath.split('/').last,
            ),
          ),
        );
      }
    }

    return formData;
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        return detail.toString();
      }
    }
    return error.message ?? 'An unexpected error occurred.';
  }
}