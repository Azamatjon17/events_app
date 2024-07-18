import 'package:firebase_auth/firebase_auth.dart';

class AuthUserFairbases {
  final firaebase = FirebaseAuth.instance;

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return firaebase.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return firaebase.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
