import '../entities/downloaded_movie.dart';
import '../repositories/download_repository.dart';

class StartDownloadUseCase {
  final DownloadRepository _repository;

  StartDownloadUseCase(this._repository);

  Future<DownloadedMovie> call(DownloadedMovie movie) {
    return _repository.startDownload(movie);
  }
}

