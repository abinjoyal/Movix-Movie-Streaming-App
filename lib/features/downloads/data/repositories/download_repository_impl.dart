import '../../domain/entities/downloaded_movie.dart';
import '../../domain/repositories/download_repository.dart';
import '../datasources/download_local_datasource.dart';
import '../models/download_model.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadLocalDataSource _localDataSource;

  DownloadRepositoryImpl(this._localDataSource);

  @override
  Future<List<DownloadedMovie>> getDownloads() async {
    return _localDataSource.getDownloads();
  }

  @override
  Future<DownloadedMovie> startDownload(DownloadedMovie movie) async {
    final model = DownloadModel.fromEntity(movie);
    return _localDataSource.saveDownload(model);
  }

  @override
  Future<void> pauseDownload(String id) async {
    final list = await _localDataSource.getDownloads();
    final item = list.firstWhere((e) => e.id == id);
    final updated = item.copyWith(status: DownloadStatus.paused);
    await _localDataSource.updateDownload(DownloadModel.fromEntity(updated));
  }

  @override
  Future<void> resumeDownload(String id) async {
    final list = await _localDataSource.getDownloads();
    final item = list.firstWhere((e) => e.id == id);
    final updated = item.copyWith(status: DownloadStatus.downloading);
    await _localDataSource.updateDownload(DownloadModel.fromEntity(updated));
  }

  @override
  Future<void> deleteDownload(String id) async {
    await _localDataSource.deleteDownload(id);
  }
}

