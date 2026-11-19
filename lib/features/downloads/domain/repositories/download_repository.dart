import '../entities/downloaded_movie.dart';

abstract class DownloadRepository {
  Future<List<DownloadedMovie>> getDownloads();
  Future<DownloadedMovie> startDownload(DownloadedMovie movie);
  Future<void> pauseDownload(String id);
  Future<void> resumeDownload(String id);
  Future<void> deleteDownload(String id);
}

