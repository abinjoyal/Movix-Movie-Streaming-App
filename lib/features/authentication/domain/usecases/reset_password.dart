import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> sendOtp(String email) {
    return _repository.sendPasswordResetOtp(email);
  }

  Future<void> verifyOtp({required String email, required String token}) {
    return _repository.verifyOtp(email: email, token: token);
  }

  Future<void> updatePassword(String newPassword) {
    return _repository.updatePassword(newPassword);
  }
}

