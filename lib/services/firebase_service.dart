import 'package:firebase_core/firebase_core.dart';

/// Lightweight Firebase initialization helper for Phase 1.
class FirebaseService {
  static Future<FirebaseApp> init() async {
    return Firebase.initializeApp();
  }
}
