import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/gift.dart';
import '../api_url.dart';

class GiftServices {
  final Dio _dio;

  GiftServices()
      : _dio = Dio()
          ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

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
