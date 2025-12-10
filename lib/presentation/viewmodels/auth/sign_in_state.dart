// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/models.dart';

class SignInState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  SignInState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  SignInState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
