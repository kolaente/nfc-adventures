import 'package:flutter/material.dart';

import '../models/nfc_tag.dart';
import '../services/nfc_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final NfcService _nfcService = NfcService();
  ScannedNfcTag? _lastScannedTag;

  @override
  void initState() {
    super.initState();
    _startContinuousScanning();
  }

  @override
  void dispose() {
    _nfcService.stopScanning();
    super.dispose();
  }

  Future<void> _startContinuousScanning() async {
    while (mounted) {
      try {
        await _nfcService.readNfcTag(
          onTagScanned: (tag) {
            if (mounted) {
              setState(() {
                _lastScannedTag = tag;
              });
            }
          },
        );
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Hold your tag near the reader...'),
          if (_lastScannedTag != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  'Last scanned: ${_lastScannedTag!.name} (${_lastScannedTag!.uid})'),
            ),
        ],
      ),
    );
  }
}
