import '../repositories/download_repository.dart';

class ResumeDownloadUseCase {
  final DownloadRepository _repository;

  ResumeDownloadUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.resumeDownload(id);
  }
}

