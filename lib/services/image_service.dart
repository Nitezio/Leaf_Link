import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  // override for tests
  static Future<String?> Function()? pickOverride;

  /// Picks an image from gallery and returns the local file path, or null.
  static Future<String?> pickFromGallery() async {
    if (pickOverride != null) return await pickOverride!();
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    return file?.path;
  }
}
