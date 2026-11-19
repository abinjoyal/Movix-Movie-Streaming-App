import '../repositories/download_repository.dart';

class DeleteDownloadUseCase {
  final DownloadRepository _repository;

  DeleteDownloadUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteDownload(id);
  }
}

