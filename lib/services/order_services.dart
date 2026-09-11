import 'package:dio/dio.dart';
import 'package:mannona_try_e_commerce/utils/api_client.dart';

class OrderApiService {
  final Dio _dio = ApiClient.dio;

  Future<Response> getOrders() async {
    return await _dio.get('orders');
  }

  Future<Response> placeOrder({
    required List<Map<String, dynamic>> items,
  }) async {
    return await _dio.post(
      'place_order',
      data: {'items': items},
    );
  }

  Future<Response> cancelOrder(String orderId) async {
    return await _dio.post('orders/cancel/$orderId');
  }

  Future<Response> completeOrder(String orderId) async {
    return await _dio.post('orders/complete/$orderId');
  }
}
