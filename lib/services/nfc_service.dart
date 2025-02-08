import 'package:nfc_collector_app/services/tag_names_service.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../models/nfc_tag.dart';
import '../services/storage_service.dart';

class NfcService {
  final StorageService _storageService = StorageService();

  Future<ScannedNfcTag?> readNfcTag() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) return null;

    String? tagId;
    await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        alertMessage: 'Hold your device near the NFC tag',
        onDiscovered: (NfcTag nfcTag) async {
          var tech = NfcA.from(nfcTag);
          if (tech is NfcA) {
            tagId = tech.identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join(':');
          }
          await NfcManager.instance.stopSession();

          if (tagId == null) {
            return;
          }

          print("found tag: $tagId");

          final tagNames = await TagNamesService.loadTagNames();
          final name = tagNames[tagId] ?? 'Unknown Tag';

          final tag = ScannedNfcTag(
            uid: tagId!,
            name: name,
            scannedAt: DateTime.now(),
          );

          await _storageService.saveCollectedTag(tag);
        });

    if (tagId != null) {
      final tagNames = await TagNamesService.loadTagNames();
      final name = tagNames[tagId] ?? 'Unknown Tag';
      return ScannedNfcTag(
        uid: tagId!,
        name: name,
        scannedAt: DateTime.now(),
      );
    }
    return null;
  }

  Future<void> stopScanning() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      // Ignore errors during stop - session might already be stopped
      print('Error stopping NFC session: $e');
    }
  }
}
