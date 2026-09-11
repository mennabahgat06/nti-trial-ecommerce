import 'package:dio/dio.dart';
import 'package:mannona_try_e_commerce/services/api_client.dart';

class UserApiService {
  final Dio _dio = ApiClient.dio;

// register endpoint
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

  // login endpoint

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

// refresh token endpoint

  Future<Response> refreshToken(String customRefreshToken) async {
    return await _dio.post(
      'refresh_token',
      options: Options(
        headers: {'Authorization': 'Bearer $customRefreshToken'},
      ),
    );
  }

// get user data endpoint
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

  // delete user endpoint

  Future<Response> deleteUser() async {
    return await _dio.delete('delete_user');
  }
}
