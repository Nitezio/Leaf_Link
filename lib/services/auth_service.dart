import 'package:firebase_auth/firebase_auth.dart';

/// Simple AuthService wrapping Firebase Auth for email/password and Google.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Google sign-in is not wired in the current local-first prototype.
    // Returning null keeps the service compilable on web until the flow is reintroduced.
    return null;
  }
}
