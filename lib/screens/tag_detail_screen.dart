import 'package:flutter/material.dart';
import '../services/image_path_service.dart';

class TagDetailScreen extends StatelessWidget {
  final String tagId;
  final String tagName;

  const TagDetailScreen({
    super.key,
    required this.tagId,
    required this.tagName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tagName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              _getTagImagePath(tagId),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 48),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTagImagePath(String tagId) {
    return ImagePathService.getImagePath(tagId) ?? 'assets/tag_images/$tagId.png';
  }
} 