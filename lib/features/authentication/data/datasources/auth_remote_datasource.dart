import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/errors/app_exception.dart';
import '../../../../core/supabase/supabase_service.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({required String email, required String password});
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signInWithOAuth(sb.OAuthProvider provider);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> verifyOtp({required String email, required String token});
  Future<void> updatePassword(String newPassword);
  Future<void> signOut();
  UserModel? getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  sb.SupabaseClient _getClient() {
    final client = SupabaseService.client;
    if (client == null) {
      throw const AuthException(
        message:
            'Supabase is not configured yet. Please configure your credentials in SupabaseConfig.',
      );
    }
    return client;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final client = _getClient();
      final response = await client.auth.signUp(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException(
            message: 'Sign up failed. Please check your details.');
      }

      return UserModel.fromSupabase(user);
    } on sb.AuthException catch (e) {
      AppLogger.e('Supabase SignUp Error: ${e.message}');
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException) rethrow;
      AppLogger.e('SignUp unexpected error: $e');
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = _getClient();
      final response = await client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException(message: 'Invalid email or password.');
      }

      return UserModel.fromSupabase(user);
    } on sb.AuthException catch (e) {
      AppLogger.e('Supabase SignIn Error: ${e.message}');
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException) rethrow;
      AppLogger.e('SignIn unexpected error: $e');
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signInWithOAuth(sb.OAuthProvider provider) async {
    try {
      final client = _getClient();
      await client.auth.signInWithOAuth(
        provider,
        redirectTo: 'movix://login-callback',
      );
    } on sb.AuthException catch (e) {
      AppLogger.e('OAuth Error: ${e.message}');
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException) rethrow;
      AppLogger.e('OAuth unexpected error: $e');
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final client = _getClient();
      await client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'movix://reset-callback',
      );
      AppLogger.i('Password reset OTP/email sent to $email');
    } on sb.AuthException catch (e) {
      AppLogger.e('Password reset error: ${e.message}');
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException) rethrow;
      AppLogger.e('Password reset unexpected error: $e');
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final client = _getClient();
      final response = await client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: sb.OtpType.recovery,
      );

      if (response.session == null && response.user == null) {
        throw const AuthException(message: 'Invalid or expired OTP token.');
      }
      AppLogger.i('OTP successfully verified for $email');
    } on sb.AuthException catch (e) {
      AppLogger.e('OTP verification error: ${e.message}');
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException) rethrow;
      AppLogger.e('OTP verification unexpected error: $e');
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final client = _getClient();
      await client.auth.updateUser(
        sb.UserAttributes(password: newPassword),
      );
      AppLogger.i('Password successfully updated.');
    } on sb.AuthException catch (e) {
      AppLogger.e('Update password error: ${e.message}');
      throw AuthException(message: e.message);
    } catch (e) {
      if (e is AuthException) rethrow;
      AppLogger.e('Update password unexpected error: $e');
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final client = _getClient();
      await client.auth.signOut();
      AppLogger.i('User signed out.');
    } catch (e) {
      AppLogger.e('SignOut error: $e');
    }
  }

  @override
  UserModel? getCurrentUser() {
    if (!SupabaseService.isInitialized) return null;
    final user = SupabaseService.client?.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabase(user);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    if (!SupabaseService.isInitialized) {
      return Stream.value(null);
    }
    return SupabaseService.client!.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? UserModel.fromSupabase(user) : null;
    });
  }
}
