import 'package:dio/dio.dart';
import 'package:mannona_try_e_commerce/utils/api_client.dart';

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
