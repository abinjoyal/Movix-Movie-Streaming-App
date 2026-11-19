import '../repositories/download_repository.dart';

class PauseDownloadUseCase {
  final DownloadRepository _repository;

  PauseDownloadUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.pauseDownload(id);
  }
}

