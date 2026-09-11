import 'package:dio/dio.dart';

class ApiClient {
  static String baseUrl = 'https://api.yourdomain.com/'; // قم بتغييره للرابط الفعلي أو من الواجهة
  static String? accessToken;
  static String? refreshToken;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = baseUrl;
          if (accessToken != null && accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // محاولة تجديد التوكن في حال انتهاء الصلاحية 401
          if (error.response?.statusCode == 401 && refreshToken != null && refreshToken!.isNotEmpty) {
            final refreshed = await refreshAccessToken();
            if (refreshed) {
              error.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
              try {
                final response = await dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

  static Future<bool> refreshAccessToken() async {
    try {
      final response = await Dio().post(
        '${baseUrl}refresh_token',
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );
      if (response.statusCode == 200) {
        accessToken = response.data['access_token'] ?? response.data['token'];
        return true;
      }
    } catch (_) {}
    return false;
  }
}
