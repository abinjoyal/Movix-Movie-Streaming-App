import '../entities/downloaded_movie.dart';
import '../repositories/download_repository.dart';

class GetDownloadsUseCase {
  final DownloadRepository _repository;

  GetDownloadsUseCase(this._repository);

  Future<List<DownloadedMovie>> call() {
    return _repository.getDownloads();
  }
}

