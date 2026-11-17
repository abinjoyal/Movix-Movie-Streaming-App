import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signUp(email: email, password: password);
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() {
    return _remoteDataSource.signInWithOAuth(OAuthProvider.google);
  }

  @override
  Future<void> signInWithApple() {
    return _remoteDataSource.signInWithOAuth(OAuthProvider.apple);
  }

  @override
  Future<void> signInWithFacebook() {
    return _remoteDataSource.signInWithOAuth(OAuthProvider.facebook);
  }

  @override
  Future<void> sendPasswordResetOtp(String email) {
    return _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String token,
  }) {
    return _remoteDataSource.verifyOtp(email: email, token: token);
  }

  @override
  Future<void> updatePassword(String newPassword) {
    return _remoteDataSource.updatePassword(newPassword);
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  AppUser? getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges;
  }
}

