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
            child: ImagePathService.getImage(
              tagId,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
