import 'package:flutter/material.dart';

import '../models/nfc_tag.dart';
import '../services/nfc_service.dart';

class ScanScreen extends StatefulWidget {
  final String adventurePath;

  const ScanScreen({
    super.key,
    required this.adventurePath,
  });

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final NfcService _nfcService;
  ScannedNfcTag? _lastScannedTag;

  @override
  void initState() {
    super.initState();
    _nfcService = NfcService(adventurePath: widget.adventurePath);
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tag scanned: ${tag.name}'),
                  duration: const Duration(seconds: 2),
                ),
              );
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hold your tag near the reader...'),
        ],
      ),
    );
  }
}
