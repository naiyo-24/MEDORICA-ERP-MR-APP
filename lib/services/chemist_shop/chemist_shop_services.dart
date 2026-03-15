import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/chemist_shop.dart';
import '../api_url.dart';

class ChemistShopServices {
  ChemistShopServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  // GET /chemist-shop/mr/get-by-mr/{mr_id}
  Future<List<ChemistShop>> fetchShopsByMrId(String mrId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.chemistShopMrGetByMrId(mrId),
      );

      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid chemist shop response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(ChemistShop.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  // GET /chemist-shop/mr/get-all
  Future<List<ChemistShop>> fetchAllShops() async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.chemistShopMrGetAll,
      );

      final dynamic body = response.data;
      if (body is! List) {
        throw Exception('Invalid chemist shop response from server');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(ChemistShop.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  // GET /chemist-shop/mr/get-by/{mr_id}/{shop_id}
  Future<ChemistShop> fetchShopByMrIdAndShopId({
    required String mrId,
    required String shopId,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.chemistShopMrGetByMrIdAndShopId(mrId, shopId),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid chemist shop response from server');
      }

      return ChemistShop.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  // GET /chemist-shop/mr/get-by-shop/{shop_id}
  Future<ChemistShop> fetchShopByShopId(String shopId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiUrl.chemistShopMrGetByShopId(shopId),
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid chemist shop response from server');
      }

      return ChemistShop.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  // POST /chemist-shop/mr/post
  Future<ChemistShop> createShop({
    required String mrId,
    required String shopName,
    required String phoneNo,
    String? address,
    String? email,
    String? description,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    try {
      final Map<String, dynamic> fields = <String, dynamic>{
        'mr_id': mrId,
        'shop_name': shopName,
        'phone_no': phoneNo,
      };

      if (address != null && address.trim().isNotEmpty) {
        fields['address'] = address;
      }
      if (email != null && email.trim().isNotEmpty) {
        fields['email'] = email;
      }
      if (description != null && description.trim().isNotEmpty) {
        fields['description'] = description;
      }
      if (photoPath != null && photoPath.trim().isNotEmpty) {
        fields['photo'] = await MultipartFile.fromFile(
          photoPath,
          filename: photoPath.split('/').last,
        );
      }
      if (bankPassbookPhotoPath != null &&
          bankPassbookPhotoPath.trim().isNotEmpty) {
        fields['bank_passbook_photo'] = await MultipartFile.fromFile(
          bankPassbookPhotoPath,
          filename: bankPassbookPhotoPath.split('/').last,
        );
      }

      final FormData payload = FormData.fromMap(fields);
      final Response<dynamic> response = await _dio.post(
        ApiUrl.chemistShopMrPost,
        data: payload,
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid chemist shop response from server');
      }

      return ChemistShop.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  // PUT /chemist-shop/mr/update-by/{mr_id}/{shop_id}
  Future<ChemistShop> updateShop({
    required String mrId,
    required String shopId,
    String? shopName,
    String? phoneNo,
    String? address,
    String? email,
    String? description,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    try {
      final Map<String, dynamic> fields = <String, dynamic>{};

      if (shopName != null && shopName.trim().isNotEmpty) {
        fields['shop_name'] = shopName;
      }
      if (phoneNo != null && phoneNo.trim().isNotEmpty) {
        fields['phone_no'] = phoneNo;
      }
      if (address != null && address.trim().isNotEmpty) {
        fields['address'] = address;
      }
      if (email != null && email.trim().isNotEmpty) {
        fields['email'] = email;
      }
      if (description != null && description.trim().isNotEmpty) {
        fields['description'] = description;
      }
      if (photoPath != null && photoPath.trim().isNotEmpty) {
        fields['photo'] = await MultipartFile.fromFile(
          photoPath,
          filename: photoPath.split('/').last,
        );
      }
      if (bankPassbookPhotoPath != null &&
          bankPassbookPhotoPath.trim().isNotEmpty) {
        fields['bank_passbook_photo'] = await MultipartFile.fromFile(
          bankPassbookPhotoPath,
          filename: bankPassbookPhotoPath.split('/').last,
        );
      }

      final FormData payload = FormData.fromMap(fields);
      final Response<dynamic> response = await _dio.put(
        ApiUrl.chemistShopMrUpdateByMrIdAndShopId(mrId, shopId),
        data: payload,
      );

      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid chemist shop response from server');
      }

      return ChemistShop.fromJson(body);
    } on DioException catch (e) {
      throw Exception(_readDioError(e));
    }
  }

  // DELETE /chemist-shop/mr/delete-by/{mr_id}/{shop_id}
  Future<void> deleteShop({
    required String mrId,
    required String shopId,
  }) async {
    try {
      await _dio.delete(
        ApiUrl.chemistShopMrDeleteByMrIdAndShopId(mrId, shopId),
      );
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
