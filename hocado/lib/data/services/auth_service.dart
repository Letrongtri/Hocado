import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hocado/data/models/models.dart' as hocado_user;

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  // Stream for auth state change like login/logout
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Sign in
  Future<User?> signIn(String email, String pwd) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: pwd,
    );
    return cred.user;
  }

  // Sign up
  Future<User?> signUp(String email, String pwd) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pwd,
    );
    return cred.user;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPwd(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Add user to firestore
  Future<void> addNewUser(hocado_user.User user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }
}
