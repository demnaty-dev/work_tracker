import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_tracker/src/features/Authentication/models/user_model.dart';

class AuthenticationServices {
  final FirebaseAuth _firebaseAuth;

  AuthenticationServices() : _firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  UserModel? currentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }
}
