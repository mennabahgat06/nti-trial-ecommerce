import 'package:dio/dio.dart';
import 'package:mannona_try_e_commerce/services/api_client.dart';

class ProductApiService {
  final Dio _dio = ApiClient.dio;

  Future<Response> getProducts() async {
    return await _dio.get('products');
  }

  Future<Response> searchProducts(String query) async {
    return await _dio.get('products/search', queryParameters: {'q': query});
  }

  Future<Response> getBestSellers() async {
    return await _dio.get('best_seller_products');
  }

  Future<Response> getTopRated() async {
    return await _dio.get('top_rated_products');
  }

  Future<Response> addProduct({
    required String name,
    required String description,
    required String rating,
    required String price,
    required String categoryId,
    required bool isBestSeller,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'rating': rating,
      'best_seller': isBestSeller ? '1' : '0',
      'price': price,
      'category_id': categoryId,
    });
    return await _dio.post('new_product', data: formData);
  }

  Future<Response> editProduct({
    required String id,
    required String name,
    required String description,
    required String price,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'price': price,
    });
    return await _dio.put('product/$id', data: formData);
  }

  Future<Response> deleteProduct(String id) async {
    return await _dio.delete('product/$id');
  }

  Future<Response> addToFavorite(String productId) async {
    final formData = FormData.fromMap({
      'product_id': productId,
    });
    return await _dio.post('add_to_favorite', data: formData);
  }
}
