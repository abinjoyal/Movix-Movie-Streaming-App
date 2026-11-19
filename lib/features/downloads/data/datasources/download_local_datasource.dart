import '../models/download_model.dart';
import '../../domain/entities/downloaded_movie.dart';

abstract class DownloadLocalDataSource {
  Future<List<DownloadModel>> getDownloads();
  Future<DownloadModel> saveDownload(DownloadModel download);
  Future<void> updateDownload(DownloadModel download);
  Future<void> deleteDownload(String id);
}

class DownloadLocalDataSourceImpl implements DownloadLocalDataSource {
  final List<DownloadModel> _storage = [
    DownloadModel(
      id: 'dl_1',
      tmdbId: 718789,
      title: 'Lightyear',
      backdropPath: '/2k9tBsv5NOtMzYVRbyeNTXpq7Al.jpg',
      posterPath: '/vpILbP9eOQEtdQgl4vgjZUNY07r.jpg',
      duration: '1h 45m 32s',
      fileSize: '1.4 GB',
      status: DownloadStatus.downloaded,
      progress: 1.0,
      downloadedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    DownloadModel(
      id: 'dl_2',
      tmdbId: 361743,
      title: 'Top Gun: Maverick',
      backdropPath: '/odJ4hx6g6vBt4lBWKFD1tI8WS4x.jpg',
      posterPath: '/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      duration: '2h 10m 47s',
      fileSize: '2.7 GB',
      status: DownloadStatus.downloaded,
      progress: 1.0,
      downloadedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DownloadModel(
      id: 'dl_3',
      tmdbId: 616037,
      title: 'Thor: Love & Thunder',
      backdropPath: '/jsoz1HlxczSuTx0mDl2h0lxy36l.jpg',
      posterPath: '/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg',
      duration: '1h 58m 42s',
      fileSize: '1.9 GB',
      status: DownloadStatus.downloaded,
      progress: 1.0,
      downloadedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DownloadModel(
      id: 'dl_4',
      tmdbId: 66732,
      title: 'Stranger Things 4 Epi...',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
      duration: '52m 45s',
      fileSize: '842 MB',
      status: DownloadStatus.downloaded,
      progress: 1.0,
      downloadedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DownloadModel(
      id: 'dl_5',
      tmdbId: 76600,
      title: 'Avatar: The Way of Wa...',
      backdropPath: '/8YFL5QQDJqGrSVoeegQ35cW7ZIX.jpg',
      posterPath: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      duration: '3h 12m 15s',
      fileSize: '3.4 GB',
      status: DownloadStatus.downloaded,
      progress: 1.0,
      downloadedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    DownloadModel(
      id: 'dl_6',
      tmdbId: 453395,
      title: 'Doctor Strange in the ...',
      backdropPath: '/wcKFYIiVDvRURrzglV9kGu7fpfY.jpg',
      posterPath: '/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      duration: '2h 06m 36s',
      fileSize: '2.1 GB',
      status: DownloadStatus.downloaded,
      progress: 1.0,
      downloadedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Future<List<DownloadModel>> getDownloads() async {
    return List.unmodifiable(_storage);
  }

  @override
  Future<DownloadModel> saveDownload(DownloadModel download) async {
    final index = _storage.indexWhere((e) => e.id == download.id);
    if (index >= 0) {
      _storage[index] = download;
    } else {
      _storage.insert(0, download);
    }
    return download;
  }

  @override
  Future<void> updateDownload(DownloadModel download) async {
    final index = _storage.indexWhere((e) => e.id == download.id);
    if (index >= 0) {
      _storage[index] = download;
    }
  }

  @override
  Future<void> deleteDownload(String id) async {
    _storage.removeWhere((e) => e.id == id);
  }
}

