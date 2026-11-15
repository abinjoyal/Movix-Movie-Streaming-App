import '../constants/app_constants.dart';

/// Network configuration settings for HTTP operations.
class NetworkConfig {
  NetworkConfig._();

  static const Duration connectTimeout = AppConstants.connectTimeout;
  static const Duration receiveTimeout = AppConstants.receiveTimeout;
  static const Duration sendTimeout = AppConstants.sendTimeout;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

