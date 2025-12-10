import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class SignInViewModel extends Notifier<SignInState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  SignInState build() => SignInState();

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _authRepository.signIn(email, password);
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
