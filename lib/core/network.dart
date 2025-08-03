import 'package:dio/dio.dart';

class NetworkService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  NetworkService() {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      print('GET Error: ${e.message}');
      throw Exception('Failed to GET $endpoint');
    }
  }
}
