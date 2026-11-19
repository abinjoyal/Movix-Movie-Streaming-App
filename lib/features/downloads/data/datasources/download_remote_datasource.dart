import '../../../../core/network/dio_client.dart';

abstract class DownloadRemoteDataSource {
  Future<Map<String, dynamic>> getMovieDetails(int tmdbId);
}

class DownloadRemoteDataSourceImpl implements DownloadRemoteDataSource {
  final DioClient _dioClient;

  DownloadRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> getMovieDetails(int tmdbId) async {
    final response = await _dioClient.get('/movie/$tmdbId');
    return response.data as Map<String, dynamic>;
  }
}

