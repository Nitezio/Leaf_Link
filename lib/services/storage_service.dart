import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  /// Uploads a local file to Firebase Storage and returns a public download URL.
  /// If Firebase isn't initialized, returns the original local path.
  static Future<String?> uploadFile(String localPath, {String? destPath}) async {
    if (localPath.isEmpty) return null;
    // If Firebase not initialized, return local path for offline/testing.
    try {
      final initialized = Firebase.apps.isNotEmpty;
      if (!initialized) {
        // Copy the file into app documents so the app can reliably reference it.
        try {
          final file = File(localPath);
          if (!file.existsSync()) return localPath;
          final docs = await getApplicationDocumentsDirectory();
          final name = destPath ?? 'images_${DateTime.now().millisecondsSinceEpoch}_${p.basename(localPath)}';
          final dest = File(p.join(docs.path, name));
          await dest.create(recursive: true);
          await file.copy(dest.path);
          return dest.path;
        } catch (_) {
          return localPath;
        }
      }
    } catch (_) {
      return localPath;
    }

    final file = File(localPath);
    if (!file.existsSync()) return null;
    final name = destPath ?? 'images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
    final ref = FirebaseStorage.instance.ref().child(name);
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
  }
}
