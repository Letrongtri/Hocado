import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsViewModel extends AsyncNotifier<void> {
  UserRepository get _userRepo => ref.read(userRepositoryProvider);
  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepo.signOut();
    });
  }

  Future<void> resetPwd(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepo.resetPwd(email);
    });
  }

  Future<void> deleteAccount(String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepo.deleteUser(password);
    });
  }

  Future<void> updateProfile(User updatedUser, XFile? avatar) async {
    final uid = _currentUser!.uid;
    if (uid != updatedUser.uid) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _userRepo.updateUser(updatedUser, avatar);
    });
  }
}
