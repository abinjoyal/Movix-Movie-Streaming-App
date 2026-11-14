import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';
import 'tmdb_config.dart';

/// Dedicated client for TMDB API requests.
class TmdbApiClient {
  final DioClient _dioClient;

  TmdbApiClient(this._dioClient);

  /// Performs a GET request to TMDB endpoints with default query parameters.
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    final fullUrl = '${ApiEndpoints.tmdbBaseUrl}$endpoint';
    final mergedParams = <String, dynamic>{
      'api_key': TmdbConfig.apiKey,
      'language': TmdbConfig.defaultLanguage,
      ...?queryParameters,
    };

    final options = Options(
      headers: TmdbConfig.readAccessToken.isNotEmpty
          ? {'Authorization': 'Bearer ${TmdbConfig.readAccessToken}'}
          : null,
    );

    return _dioClient.get<T>(
      fullUrl,
      queryParameters: mergedParams,
      options: options,
      cancelToken: cancelToken,
    );
  }
}

/// Provider exposing [TmdbApiClient].
final tmdbApiClientProvider = Provider<TmdbApiClient>((ref) {
  return TmdbApiClient(ref.watch(dioClientProvider));
});

