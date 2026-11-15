import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../utils/logger.dart';

/// Interceptor that handles logging, request headers, and maps DioErrors to [AppException].
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('--> ${options.method} ${options.uri}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d('<-- ${response.statusCode} ${response.requestOptions.uri}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e('<-- ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}: ${err.message}');

    final appException = _mapDioException(err);
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection timed out. Please check your internet.',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'An unexpected server error occurred.';

        if (data is Map && data.containsKey('status_message')) {
          message = data['status_message'].toString();
        } else if (data is Map && data.containsKey('message')) {
          message = data['message'].toString();
        } else if (statusCode != null) {
          message = 'Server returned status code $statusCode';
        }

        if (statusCode == 401 || statusCode == 403) {
          return AuthException(
            message: message,
            statusCode: statusCode,
            originalError: error,
          );
        }

        return ServerException(
          message: message,
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.cancel:
        return const AppException(message: 'Request was cancelled.');

      default:
        return AppException(
          message: error.message ?? 'Unknown network error occurred.',
          originalError: error,
        );
    }
  }
}

