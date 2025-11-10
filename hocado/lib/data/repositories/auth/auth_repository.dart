import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/core/utils/xp_helper.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/data/models/models.dart' as hocado_user;

class AuthRepository {
  final AuthService authService;
  final FirebaseFirestore firestore;

  AuthRepository({required this.authService, required this.firestore});

  // Sign in
  Future<hocado_user.User?> signIn(String email, String pwd) async {
    final fbUser = await authService.signIn(email, pwd);
    if (fbUser == null) return null;

    final doc = await firestore.collection('users').doc(fbUser.uid).get();
    if (!doc.exists) return null;

    return hocado_user.User.fromFirestore(doc);
  }

  // Sign up
  Future<hocado_user.User?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final fbUser = await authService.signUp(email, password);
    if (fbUser == null) return null;

    final user = hocado_user.User(
      uid: fbUser.uid,
      email: email,
      avatarUrl: '',
      fullName: fullName,
      phone: phone,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastLogin: DateTime.now(),
      xp: 0,
      nextLevelXp: XpHelper.getXpForLevel(1),
    );

    await authService.addNewUser(user);
    return user;
  }

  Future<void> signOut() {
    return authService.signOut();
  }

  Future<void> resetPwd(String email) {
    return authService.resetPwd(email);
  }
}
