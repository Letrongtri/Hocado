import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:riverpod/legacy.dart';

// provide the authService instance
final authServiceProvider = Provider<AuthService>((ref) {
  final fireAuth = ref.read(firebaseAuthProvider);
  final fireStore = ref.read(firestoreProvider);
  return AuthService(auth: fireAuth, firestore: fireStore);
});

// provide the auth state
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});

// provide current user snapshot
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

// provide the auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final fireStore = ref.read(firestoreProvider);
  return AuthRepository(authService: authService, firestore: fireStore);
});

// provide sign in view model
final signInViewModelProvider =
    StateNotifierProvider<SignInViewModel, SignInState>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return SignInViewModel(authRepository);
    });

// provide sign up view model
final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return SignUpViewModel(authRepository);
    });
