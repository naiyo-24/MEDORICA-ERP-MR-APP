import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/gift.dart';
import '../api_url.dart';

class GiftServices {
    final Dio _dio;

    GiftServices()
      : _dio = Dio()
          ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));
  
    // Post a new MR Gift Application
    Future<Map<String, dynamic>> postMrGiftApplication({
      required String mrId,
      required String doctorId,
      required int giftId,
      String? occassion,
      String? message,
      DateTime? giftDate,
      String? remarks,
    }) async {
      final url = ApiUrl.getFullUrl(ApiUrl.mrGiftApplicationPost);
      final formData = FormData.fromMap({
        'mr_id': mrId,
        'doctor_id': doctorId,
        'gift_id': giftId,
        'occassion': ?occassion,
        'message': ?message,
        if (giftDate != null) 'gift_date': giftDate.toIso8601String(),
        'remarks': ?remarks,
      });
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to post MR Gift Application');
      }
    }

    // Get MR Gift Applications by MR ID
    Future<List<Map<String, dynamic>>> getMrGiftApplicationsByMrId(String mrId) async {
      final url = ApiUrl.getFullUrl(ApiUrl.mrGiftApplicationGetByMrId(mrId));
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to fetch MR Gift Applications');
      }
    }

    // Update MR Gift Application by MR ID and Request ID
    Future<Map<String, dynamic>> updateMrGiftApplication({
      required String mrId,
      required int requestId,
      String? doctorId,
      String? occassion,
      String? message,
      DateTime? giftDate,
      String? remarks,
      String? status,
    }) async {
      final url = ApiUrl.getFullUrl(ApiUrl.mrGiftApplicationUpdateByMrId(mrId, requestId));
      final formData = FormData.fromMap({
        'doctor_id': ?doctorId,
        'occassion': ?occassion,
        'message': ?message,
        if (giftDate != null) 'gift_date': giftDate.toIso8601String(),
        'remarks': ?remarks,
        'status': ?status,
      });
      final response = await _dio.put(url, data: formData);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update MR Gift Application');
      }
    }

    // Delete MR Gift Application by Request ID
    Future<void> deleteMrGiftApplication(int requestId) async {
      final url = ApiUrl.getFullUrl(ApiUrl.mrGiftApplicationDeleteByRequestId(requestId));
      final response = await _dio.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete MR Gift Application');
      }
    }

  // Fetch gift inventory items for dropdown
  Future<List<GiftItem>> fetchGiftInventory() async {
    final url = ApiUrl.getFullUrl(ApiUrl.giftInventoryGetAll);
    final response = await _dio.get(url);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => GiftItem(
                id: item['gift_id'].toString(),
                name: item['product_name'] ?? '',
                description: item['description'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to load gift inventory');
    }
  }

  Future<GiftItem> fetchGiftInventoryById(String giftId) async {
    final url = ApiUrl.getFullUrl(ApiUrl.giftInventoryGetById(int.parse(giftId)));
    final response = await _dio.get(url);
    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final item = response.data;
      return GiftItem(
        id: item['gift_id'].toString(),
        name: item['product_name'] ?? '',
        description: item['description'] ?? '',
      );
    } else {
      throw Exception('Failed to load gift inventory item');
    }
  }
}
