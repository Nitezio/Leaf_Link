import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Firebase initialization helper.
///
/// Strategy:
/// - Prefer explicit options from `.env` so web/mobile can run without
///   generated firebase options files.
/// - Fall back to default platform initialization if env options are absent.
class FirebaseService {
  static Future<bool> init() async {
    if (Firebase.apps.isNotEmpty) {
      return true;
    }

    try {
      // In this project, `.env` contains the web config. Native platforms
      // should use their platform files (google-services.json / plist).
      if (kIsWeb) {
        final options = _optionsFromEnv();
        if (options == null) {
          throw StateError('Missing required web Firebase env values.');
        }
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp();
      }
      return true;
    } catch (e, st) {
      debugPrint('Firebase init skipped: $e');
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

  static FirebaseOptions? _optionsFromEnv() {
    String value(String key) => (dotenv.env[key] ?? '').trim();

    final apiKey = value('FIREBASE_API_KEY');
    final appId = value('FIREBASE_APP_ID');
    final messagingSenderId = value('FIREBASE_MESSAGING_SENDER_ID');
    final projectId = value('FIREBASE_PROJECT_ID');

    if (apiKey.isEmpty || appId.isEmpty || messagingSenderId.isEmpty || projectId.isEmpty) {
      return null;
    }

    final storageBucket = value('FIREBASE_STORAGE_BUCKET');
    final authDomain = value('FIREBASE_AUTH_DOMAIN');
    final measurementId = value('FIREBASE_MEASUREMENT_ID');

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
      authDomain: kIsWeb && authDomain.isNotEmpty ? authDomain : null,
      measurementId: kIsWeb && measurementId.isNotEmpty ? measurementId : null,
    );
  }
}
