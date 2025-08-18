import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagePathService {
  static final Map<String, String> _imagePathCache = {};
  static final Set<String> _assetImageCache = {};
  static const _imageExtensions = ['.png', '.jpg', '.jpeg'];
  static String? _currentAdventurePath;

  static Future<void> initializeImagePaths(
      Set<String> tagIds, String adventurePath) async {
    _currentAdventurePath = adventurePath;
    _imagePathCache.clear();
    _assetImageCache.clear();

    for (final tagId in tagIds) {
      String? validPath;
      
      // First check assets/tag_images/
      for (final ext in _imageExtensions) {
        final assetPath = 'assets/tag_images/$tagId$ext';
        try {
          await rootBundle.load(assetPath);
          _assetImageCache.add(tagId);
          validPath = assetPath;
          break;
        } catch (_) {
          continue;
        }
      }
      
      // If not found in assets, check file system
      if (validPath == null) {
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

    // Check if it's an asset image
    if (_assetImageCache.contains(tagId)) {
      return Image.asset(
        imagePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading asset image $imagePath: $error');
          return const Icon(Icons.broken_image, size: 32);
        },
      );
    } else {
      // File system image
      return Image.file(
        File(imagePath),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading file image $imagePath: $error');
          return const Icon(Icons.broken_image, size: 32);
        },
      );
    }
  }
}
