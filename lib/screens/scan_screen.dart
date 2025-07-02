import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  content: Text(AppLocalizations.of(context)!
                      .tagScannedSuccess(tag.name)),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          nfcPrompt: AppLocalizations.of(context)!.nfcPrompt,
          unknownTagName: AppLocalizations.of(context)!.unknownTag,
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
          Text(AppLocalizations.of(context)!.scanInstructions),
        ],
      ),
    );
  }
}
