import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/download_local_datasource.dart';
import '../../data/datasources/download_remote_datasource.dart';
import '../../data/repositories/download_repository_impl.dart';
import '../../domain/entities/downloaded_movie.dart';
import '../../domain/repositories/download_repository.dart';
import '../../domain/usecases/delete_download.dart';
import '../../domain/usecases/get_downloads.dart';
import '../../domain/usecases/pause_download.dart';
import '../../domain/usecases/resume_download.dart';
import '../../domain/usecases/start_download.dart';

class DownloadState {
  final bool isLoading;
  final List<DownloadedMovie> downloads;
  final String? errorMessage;

  const DownloadState({
    this.isLoading = false,
    this.downloads = const [],
    this.errorMessage,
  });

  DownloadState copyWith({
    bool? isLoading,
    List<DownloadedMovie>? downloads,
    String? errorMessage,
  }) {
    return DownloadState(
      isLoading: isLoading ?? this.isLoading,
      downloads: downloads ?? this.downloads,
      errorMessage: errorMessage,
    );
  }
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  final GetDownloadsUseCase _getDownloads;
  final StartDownloadUseCase _startDownload;
  final PauseDownloadUseCase _pauseDownload;
  final ResumeDownloadUseCase _resumeDownload;
  final DeleteDownloadUseCase _deleteDownload;

  Timer? _progressSimulationTimer;

  DownloadNotifier(
    this._getDownloads,
    this._startDownload,
    this._pauseDownload,
    this._resumeDownload,
    this._deleteDownload,
  ) : super(const DownloadState()) {
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final items = await _getDownloads();
      state = state.copyWith(isLoading: false, downloads: items);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load downloads.',
      );
    }
  }

  Future<void> addDownload(DownloadedMovie movie) async {
    try {
      await _startDownload(movie);
      final updatedList = await _getDownloads();
      state = state.copyWith(downloads: updatedList);
      _startSimulatedDownload(movie.id);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to start download');
    }
  }

  Future<void> pause(String id) async {
    try {
      await _pauseDownload(id);
      final updated = state.downloads.map((m) {
        if (m.id == id) {
          return m.copyWith(status: DownloadStatus.paused);
        }
        return m;
      }).toList();
      state = state.copyWith(downloads: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to pause download');
    }
  }

  Future<void> resume(String id) async {
    try {
      await _resumeDownload(id);
      final updated = state.downloads.map((m) {
        if (m.id == id) {
          return m.copyWith(status: DownloadStatus.downloading);
        }
        return m;
      }).toList();
      state = state.copyWith(downloads: updated);
      _startSimulatedDownload(id);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to resume download');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _deleteDownload(id);
      final updated = state.downloads.where((m) => m.id != id).toList();
      state = state.copyWith(downloads: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete download');
    }
  }

  void _startSimulatedDownload(String id) {
    _progressSimulationTimer?.cancel();
    _progressSimulationTimer =
        Timer.periodic(const Duration(milliseconds: 600), (timer) {
      final movie = state.downloads.firstWhere(
        (m) => m.id == id,
        orElse: () => DownloadedMovie(
          id: '',
          tmdbId: 0,
          title: '',
          backdropPath: '',
          posterPath: '',
          duration: '',
          fileSize: '',
          status: DownloadStatus.failed,
          downloadedAt: DateTime.now(),
        ),
      );

      if (movie.id.isEmpty || movie.status != DownloadStatus.downloading) {
        timer.cancel();
        return;
      }

      final nextProgress = (movie.progress + 0.08).clamp(0.0, 1.0);
      final isDone = nextProgress >= 1.0;

      final updated = state.downloads.map((m) {
        if (m.id == id) {
          return m.copyWith(
            progress: nextProgress,
            status: isDone
                ? DownloadStatus.downloaded
                : DownloadStatus.downloading,
          );
        }
        return m;
      }).toList();

      state = state.copyWith(downloads: updated);

      if (isDone) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _progressSimulationTimer?.cancel();
    super.dispose();
  }
}

// ---------------- Riverpod Providers ----------------

final downloadLocalDataSourceProvider =
    Provider<DownloadLocalDataSource>((ref) {
  return DownloadLocalDataSourceImpl();
});

final downloadRemoteDataSourceProvider =
    Provider<DownloadRemoteDataSource>((ref) {
  return DownloadRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepositoryImpl(
    ref.watch(downloadLocalDataSourceProvider),
  );
});

final getDownloadsUseCaseProvider = Provider<GetDownloadsUseCase>((ref) {
  return GetDownloadsUseCase(ref.watch(downloadRepositoryProvider));
});

final startDownloadUseCaseProvider = Provider<StartDownloadUseCase>((ref) {
  return StartDownloadUseCase(ref.watch(downloadRepositoryProvider));
});

final pauseDownloadUseCaseProvider = Provider<PauseDownloadUseCase>((ref) {
  return PauseDownloadUseCase(ref.watch(downloadRepositoryProvider));
});

final resumeDownloadUseCaseProvider = Provider<ResumeDownloadUseCase>((ref) {
  return ResumeDownloadUseCase(ref.watch(downloadRepositoryProvider));
});

final deleteDownloadUseCaseProvider = Provider<DeleteDownloadUseCase>((ref) {
  return DeleteDownloadUseCase(ref.watch(downloadRepositoryProvider));
});

final downloadProvider =
    StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  return DownloadNotifier(
    ref.watch(getDownloadsUseCaseProvider),
    ref.watch(startDownloadUseCaseProvider),
    ref.watch(pauseDownloadUseCaseProvider),
    ref.watch(resumeDownloadUseCaseProvider),
    ref.watch(deleteDownloadUseCaseProvider),
  );
});

