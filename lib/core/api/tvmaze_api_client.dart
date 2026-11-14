import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';

/// Keyless REST client for the free public TVmaze API (`https://api.tvmaze.com`).
class TvMazeApiClient {
  final DioClient _dioClient;

  TvMazeApiClient(this._dioClient);

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    final fullUrl = '${ApiEndpoints.tvmazeBaseUrl}$endpoint';
    return _dioClient.get<T>(
      fullUrl,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }
}

final tvmazeApiClientProvider = Provider<TvMazeApiClient>((ref) {
  return TvMazeApiClient(ref.watch(dioClientProvider));
});

