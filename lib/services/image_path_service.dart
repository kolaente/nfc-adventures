import 'package:flutter/material.dart';
import 'dart:io';

class ImagePathService {
  static final Map<String, String> _imagePathCache = {};
  static const _imageExtensions = ['.png', '.jpg', '.jpeg'];
  static String? _currentAdventurePath;

  static Future<void> initializeImagePaths(
      Set<String> tagIds, String adventurePath) async {
    _currentAdventurePath = adventurePath;
    _imagePathCache.clear();

    for (final tagId in tagIds) {
      String? validPath;

      // Check file system in adventure path
      for (final ext in _imageExtensions) {
        final path = '$adventurePath/images/$tagId$ext';
        try {
          final file = File(path);
          if (await file.exists()) {
            validPath = path;
            break;
          }
        } catch (_) {
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

  static Widget getImage(String tagId, {BoxFit fit = BoxFit.cover}) {
    final imagePath = getImagePath(tagId);
    if (imagePath == null) {
      return const Icon(Icons.broken_image, size: 32);
    }

    return Image.file(
      File(imagePath),
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image $imagePath: $error');
        return const Icon(Icons.broken_image, size: 32);
      },
    );
  }
}
