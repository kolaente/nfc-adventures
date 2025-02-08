import 'package:flutter/material.dart';
import '../services/nfc_service.dart';
import '../services/storage_service.dart';
import '../services/tag_names_service.dart';
import '../models/nfc_tag.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final StorageService _storageService = StorageService();
  bool _isScanning = false;
  String? _lastScannedTag;

  Future<void> _scanTag() async {
    setState(() {
      _isScanning = true;
      _lastScannedTag = null;
    });

    try {
      final String? tagId = await NfcService.readNfcTag();
      if (tagId != null) {
        final tagNames = await TagNamesService.loadTagNames();
        final name = tagNames[tagId] ?? 'Unknown Tag';

        final tag = NfcTag(
          uid: tagId,
          name: name,
          scannedAt: DateTime.now(),
        );

        await _storageService.saveCollectedTag(tag);
        setState(() => _lastScannedTag = name);
      }
    } finally {
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _isScanning ? null : _scanTag,
            child: Text(_isScanning ? 'Scanning...' : 'Scan NFC Tag'),
          ),
          if (_lastScannedTag != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Last scanned: $_lastScannedTag'),
            ),
        ],
      ),
    );
  }
}
