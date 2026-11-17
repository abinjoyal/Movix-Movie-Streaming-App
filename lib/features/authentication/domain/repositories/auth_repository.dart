import '../entities/app_user.dart';

/// Contract defining authentication operations for Movix.
abstract class AuthRepository {
  Future<AppUser> signUp({
    required String email,
    required String password,
  });

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInWithFacebook();

  Future<void> sendPasswordResetOtp(String email);

  Future<void> verifyOtp({
    required String email,
    required String token,
  });

  Future<void> updatePassword(String newPassword);

  Future<void> signOut();

  AppUser? getCurrentUser();

  Stream<AppUser?> get authStateChanges;
}

