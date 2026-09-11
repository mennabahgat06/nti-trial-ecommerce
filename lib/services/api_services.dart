import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_client.dart';

class UserApiService {
  final Dio _dio = ApiClient.dio;

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
    return await _dio.post('register', data: formData);
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    final formData = FormData.fromMap({
      'email': email,
      'password': password,
    });
    return await _dio.post('login', data: formData);
  }

  Future<Response> refreshToken(String customRefreshToken) async {
    return await _dio.post(
      'refresh_token',
      options: Options(
        headers: {'Authorization': 'Bearer $customRefreshToken'},
      ),
    );
  }

  Future<Response> getUserData() async {
    return await _dio.get('get_user_data');
  }

  Future<Response> updateProfile({
    required String name,
    required String phone,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'phone': phone,
    });
    return await _dio.put('update_profile', data: formData);
  }

  Future<Response> deleteUser() async {
    return await _dio.delete('delete_user');
  }
}

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

class CategoryApiService {
  final Dio _dio = ApiClient.dio;

  Future<Response> getCategories() async {
    return await _dio.get('categories');
  }

  Future<Response> addCategory({
    required String title,
    required String description,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
    });
    return await _dio.post('new_category', data: formData);
  }

  Future<Response> editCategory({
    required String id,
    required String title,
    required String description,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
    });
    return await _dio.put('category/$id', data: formData);
  }

  Future<Response> deleteCategory(String id) async {
    return await _dio.delete('category/$id');
  }
}

class SliderApiService {
  final Dio _dio = ApiClient.dio;

  Future<Response> getSliders() async {
    return await _dio.get('sliders');
  }

  Future<Response> addSlider({
    required String title,
    required String description,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
    });
    return await _dio.post('new_slider', data: formData);
  }

  Future<Response> editSlider({
    required String id,
    required String title,
    required String description,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
    });
    return await _dio.put('slider/$id', data: formData);
  }

  Future<Response> deleteSlider(String id) async {
    return await _dio.delete('slider/$id');
  }
}

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
