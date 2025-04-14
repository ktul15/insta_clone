import 'package:client/core/network/server_constants.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    List<Interceptor>? interceptors,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {'Content-Type': 'application/json'},
            connectTimeout: connectTimeout ?? const Duration(milliseconds: 5000),
            receiveTimeout: receiveTimeout ?? const Duration(milliseconds: 5000),
            validateStatus: (status) => status! < 500,
          ),
        ) {
    // Add default interceptors
    _dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
      // Add any other default interceptors here
    ]);

    // Add custom interceptors if provided
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  // Getter for Dio instance
  Dio get dio => _dio;

  // Factory method for creating a default instance
  factory DioClient.defaultInstance() {
    return DioClient(
      baseUrl: ServerConstants.serverBaseUrl,
      interceptors: [
        // Add any default interceptors here
      ],
    );
  }
}
