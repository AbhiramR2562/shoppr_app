import 'dart:developer';

import 'package:dio/dio.dart';

// A service class to handle network requests
class NetworkService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  NetworkService() {
    // This helps in printing the request and response details in the debug console
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // GET request method
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      log('GET Error: ${e.message}');
      throw Exception('Failed to GET $endpoint');
    }
  }
}
