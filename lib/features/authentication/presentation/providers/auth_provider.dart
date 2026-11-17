import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

// --- Data & Domain Providers ---

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

// --- State & Notifier ---

class AuthState {
  final bool isLoading;
  final AppUser? user;
  final String? errorMessage;
  final String? successMessage;
  final bool isPasswordResetEmailSent;
  final bool isOtpVerified;
  final bool isPasswordResetSuccessful;
  final bool rememberMe;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.isPasswordResetEmailSent = false,
    this.isOtpVerified = false,
    this.isPasswordResetSuccessful = false,
    this.rememberMe = true,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isLoading,
    AppUser? user,
    String? errorMessage,
    String? successMessage,
    bool? isPasswordResetEmailSent,
    bool? isOtpVerified,
    bool? isPasswordResetSuccessful,
    bool? rememberMe,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isPasswordResetEmailSent:
          isPasswordResetEmailSent ?? this.isPasswordResetEmailSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      isPasswordResetSuccessful:
          isPasswordResetSuccessful ?? this.isPasswordResetSuccessful,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final AuthRepository repository;

  AuthNotifier({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.repository,
  }) : super(AuthState(user: repository.getCurrentUser()));

  void toggleRememberMe([bool? value]) {
    state = state.copyWith(rememberMe: value ?? !state.rememberMe);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  Future<bool> signUp({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Dummy / Mock login fallback when Supabase is not configured
    if (!SupabaseConfig.isConfigured) {
      await Future.delayed(const Duration(milliseconds: 500));
      final dummyUser = AppUser(
        id: 'dummy_${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim().isNotEmpty ? email.trim() : 'user@movix.com',
        displayName: 'Movix User',
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        isLoading: false,
        user: dummyUser,
        successMessage: 'Account created successfully!',
      );
      return true;
    }

    try {
      final user = await signUpUseCase(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        user: user,
        successMessage:
            'Account created successfully! Check your email to verify.',
      );
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Dummy / Mock login fallback when Supabase is not configured
    if (!SupabaseConfig.isConfigured) {
      await Future.delayed(const Duration(milliseconds: 500));
      final dummyUser = AppUser(
        id: 'dummy_${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim().isNotEmpty ? email.trim() : 'user@movix.com',
        displayName: 'Movix User',
        createdAt: DateTime.now(),
      );
      state = state.copyWith(isLoading: false, user: dummyUser);
      return true;
    }

    try {
      final user = await signInUseCase(email: email, password: password);
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    if (!SupabaseConfig.isConfigured) {
      state = state.copyWith(
        user: const AppUser(
          id: 'dummy_google_user',
          email: 'google.user@movix.com',
          displayName: 'Google User',
        ),
      );
      return;
    }

    try {
      await repository.signInWithGoogle();
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  Future<void> signInWithApple() async {
    if (!SupabaseConfig.isConfigured) {
      state = state.copyWith(
        user: const AppUser(
          id: 'dummy_apple_user',
          email: 'apple.user@movix.com',
          displayName: 'Apple User',
        ),
      );
      return;
    }

    try {
      await repository.signInWithApple();
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  Future<void> signInWithFacebook() async {
    if (!SupabaseConfig.isConfigured) {
      state = state.copyWith(
        user: const AppUser(
          id: 'dummy_facebook_user',
          email: 'facebook.user@movix.com',
          displayName: 'Facebook User',
        ),
      );
      return;
    }

    try {
      await repository.signInWithFacebook();
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (!SupabaseConfig.isConfigured) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        isLoading: false,
        isPasswordResetEmailSent: true,
        successMessage: 'Reset code sent to $email',
      );
      return true;
    }

    try {
      await resetPasswordUseCase.sendOtp(email);
      state = state.copyWith(
        isLoading: false,
        isPasswordResetEmailSent: true,
        successMessage: 'Reset code sent to $email',
      );
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp({required String email, required String token}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (!SupabaseConfig.isConfigured) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        isLoading: false,
        isOtpVerified: true,
        successMessage: 'Code verified successfully',
      );
      return true;
    }

    try {
      await resetPasswordUseCase.verifyOtp(email: email, token: token);
      state = state.copyWith(
        isLoading: false,
        isOtpVerified: true,
        successMessage: 'Code verified successfully',
      );
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (!SupabaseConfig.isConfigured) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        isLoading: false,
        isPasswordResetSuccessful: true,
        successMessage: 'Password successfully updated!',
      );
      return true;
    }

    try {
      await resetPasswordUseCase.updatePassword(newPassword);
      state = state.copyWith(
        isLoading: false,
        isPasswordResetSuccessful: true,
        successMessage: 'Password successfully updated!',
      );
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    if (SupabaseConfig.isConfigured) {
      await signOutUseCase();
    }
    state = const AuthState(user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signUpUseCase: ref.watch(signUpUseCaseProvider),
    signInUseCase: ref.watch(signInUseCaseProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
    resetPasswordUseCase: ref.watch(resetPasswordUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
  );
});
