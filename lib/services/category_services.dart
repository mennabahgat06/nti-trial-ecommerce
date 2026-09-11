import 'package:dio/dio.dart';
import 'package:mannona_try_e_commerce/services/api_client.dart';

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
