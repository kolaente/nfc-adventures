import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/tag_names_service.dart';
import '../models/nfc_tag.dart';
import 'tag_detail_screen.dart';
import '../services/image_path_service.dart';

class CollectionScreen extends StatelessWidget {
  final StorageService _storageService = StorageService();
  final String adventurePath;

  CollectionScreen({
    super.key,
    required this.adventurePath,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        _storageService.getCollectedTags(),
        TagNamesService.loadTagNames(adventurePath),
      ]).then((results) async {
        final collectedTags = results[0] as List<ScannedNfcTag>;
        final allTags = results[1] as Map<String, String>;

        // Initialize image paths
        await ImagePathService.initializeImagePaths(
          allTags.keys.toSet(),
          adventurePath,
        );

        return {
          'collectedTags': collectedTags,
          'allTags': allTags,
        };
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Error loading tags'));
        }

        final collectedTags =
            snapshot.data!['collectedTags'] as List<ScannedNfcTag>;
        final allTags = snapshot.data!['allTags'] as Map<String, String>;
        final collectedTagIds = collectedTags.map((t) => t.uid).toSet();

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: allTags.length,
          itemBuilder: (context, index) {
            final tagId = allTags.keys.elementAt(index);
            final tagName = allTags[tagId]!;
            final isCollected = collectedTagIds.contains(tagId);

            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: isCollected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TagDetailScreen(
                              tagId: tagId,
                              tagName: tagName,
                            ),
                          ),
                        );
                      }
                    : null,
                child: ColorFiltered(
                  colorFilter: isCollected
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.matrix([
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ]),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImagePathService.getImage(tagId),
                      if (!isCollected)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
