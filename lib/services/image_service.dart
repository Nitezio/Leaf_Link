import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  // override for tests that need an XFile
  static Future<XFile?> Function()? pickXFileOverride;
  // legacy override for path-based tests
  static Future<String?> Function()? pickOverride;

  /// Returns an [XFile] for the selected image (works on web and mobile).
  static Future<XFile?> pickXFile(ImageSource source) async {
    if (pickXFileOverride != null) return await pickXFileOverride!();
    final XFile? file = await _picker.pickImage(source: source, imageQuality: 50, maxWidth: 800, maxHeight: 800);
    return file;
  }

  static Future<XFile?> pickXFileFromGallery() => pickXFile(ImageSource.gallery);
  static Future<XFile?> pickXFileFromCamera() => pickXFile(ImageSource.camera);

  // Backwards-compatible path-based APIs (may be null on web)
  static Future<String?> _pick(ImageSource source) async {
    if (pickOverride != null) return await pickOverride!();
    final XFile? file = await pickXFile(source);
    return file?.path;
  }

  /// Picks an image from the gallery and returns the local file path, or null.
  static Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  /// Captures an image using the camera and returns the local file path, or null.
  static Future<String?> pickFromCamera() => _pick(ImageSource.camera);
}
