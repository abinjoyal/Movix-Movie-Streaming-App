/// Base exception class for all Movix application errors.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

/// Thrown when a network connectivity failure occurs.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
    super.originalError,
  });
}

/// Thrown when a remote server returns an error response.
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Thrown when an authentication or authorization failure occurs.
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// Thrown when local cache or storage operation fails.
class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to load local cached data.',
    super.statusCode,
    super.originalError,
  });
}

