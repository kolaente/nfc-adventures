import 'package:nfc_adventures/services/tag_names_service.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../models/nfc_tag.dart';
import '../services/storage_service.dart';

class NfcService {
  final StorageService _storageService = StorageService();
  final String adventurePath;

  NfcService({required this.adventurePath});

  Future<void> readNfcTag({
    required Function(ScannedNfcTag) onTagScanned,
    String? nfcPrompt,
    String? unknownTagName,
  }) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) return;

    await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        alertMessage: nfcPrompt ?? 'Hold your device near the NFC tag',
        onDiscovered: (NfcTag nfcTag) async {
          String? tagId;
          var tech = NfcA.from(nfcTag);
          if (tech is NfcA) {
            tagId = tech.identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join(':')
                .toLowerCase();
          }
          await NfcManager.instance.stopSession();

          if (tagId == null) {
            return;
          }

          final tagNames = await TagNamesService.loadTagNames(adventurePath);
          final name = tagNames[tagId] ?? unknownTagName ?? 'Unknown Tag';

          final tag = ScannedNfcTag(
            uid: tagId,
            name: name,
            scannedAt: DateTime.now(),
          );

          await _storageService.saveCollectedTag(tag);
          onTagScanned(tag);

          print("found tag: $tagId");
        });
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
