/// Base class for all domain-level failures in Clean Architecture.
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

/// Represents failure from network or remote API services.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Represents internet connection failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please verify your connection.',
    super.statusCode,
  });
}

/// Represents authentication failures (e.g. Supabase auth).
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

/// Represents local database / cache failures.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Unable to read or write local cached data.',
    super.statusCode,
  });
}

