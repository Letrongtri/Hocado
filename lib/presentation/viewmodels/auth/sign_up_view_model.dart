import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class SignUpViewModel extends Notifier<SignUpState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  SignUpState build() {
    return SignUpState();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
