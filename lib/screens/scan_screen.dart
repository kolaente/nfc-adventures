import 'package:flutter/material.dart';
import '../services/nfc_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final NfcService _nfcService = NfcService();
  String? _lastScannedTag;

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
        await _nfcService.readNfcTag();
        // Add a small delay to prevent excessive scanning
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        // Handle any errors silently and continue scanning
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
              child: Text('Last scanned: $_lastScannedTag'),
            ),
        ],
      ),
    );
  }
}
