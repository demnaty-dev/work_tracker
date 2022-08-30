import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _firebaseAuth;

  AuthenticationServices() : _firebaseAuth = FirebaseAuth.instance;

  Stream<bool> get onAuthStateChanged {
    print('***************@@@@@@@@@@@@@@@@@');
    return _firebaseAuth.authStateChanges().map((user) => user != null);
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    try {
      print('777777777777777777777777');
      await _firebaseAuth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
