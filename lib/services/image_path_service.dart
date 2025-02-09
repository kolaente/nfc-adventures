import 'package:flutter/services.dart';

class ImagePathService {
  static final Map<String, String> _imagePathCache = {};
  static const _imageExtensions = ['.png', '.jpg', '.jpeg'];

  static Future<void> initializeImagePaths(Set<String> tagIds) async {
    for (final tagId in tagIds) {
      String? validPath;
      for (final ext in _imageExtensions) {
        final path = 'assets/tag_images/$tagId$ext';
        try {
          final asset = await rootBundle.load(path);
          if (asset.lengthInBytes > 0) {
            validPath = path;
            break;
          }
        } catch (_) {
          // Asset doesn't exist with this extension, try next
          continue;
        }
      }
      if (validPath != null) {
        _imagePathCache[tagId] = validPath;
      }
    }
  }

  static String? getImagePath(String tagId) {
    return _imagePathCache[tagId];
  }
} 