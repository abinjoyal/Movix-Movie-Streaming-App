import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/logger.dart';
import 'supabase_config.dart';

/// Service responsible for managing Supabase initialization and lifecycle.
class SupabaseService {
  SupabaseService._();

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  /// Safely initializes Supabase without crashing if credentials are not yet set.
  static Future<void> init() async {
    if (!SupabaseConfig.isConfigured) {
      AppLogger.w('Supabase credentials not configured yet. Skipping Supabase.initialize.');
      return;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        // ignore: deprecated_member_use
        anonKey: SupabaseConfig.anonKey,
      );
      _isInitialized = true;
      AppLogger.i('Supabase successfully initialized.');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to initialize Supabase: $e', error: e, stackTrace: stackTrace);
    }
  }

  /// Get active SupabaseClient if initialized, otherwise returns null.
  static SupabaseClient? get client {
    if (!_isInitialized) return null;
    return Supabase.instance.client;
  }
}

/// Provider exposing [SupabaseClient] when available.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  return SupabaseService.client;
});

