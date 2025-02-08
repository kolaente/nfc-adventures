import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/nfc_tag.dart';

class CollectionScreen extends StatelessWidget {
  final StorageService _storageService = StorageService();

  CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScannedNfcTag>>(
      future: _storageService.getCollectedTags(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tags collected yet'));
        }

        final tags = snapshot.data!;
        return ListView.builder(
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            return ListTile(
              title: Text(tag.name),
              subtitle: Text('UID: ${tag.uid}'),
              trailing: Text(
                '${tag.scannedAt.day}/${tag.scannedAt.month}/${tag.scannedAt.year} ${tag.scannedAt.hour}:${tag.scannedAt.minute.toString().padLeft(2, '0')}:${tag.scannedAt.second.toString().padLeft(2, '0')}',
              ),
            );
          },
        );
      },
    );
  }
}
