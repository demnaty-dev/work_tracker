import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _firebaseAuth;

  AuthenticationServices() : _firebaseAuth = FirebaseAuth.instance;

  Stream<bool> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((user) => user != null);
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
