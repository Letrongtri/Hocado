// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/user.dart';

class SignUpState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  SignUpState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  SignUpState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
