import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../l10n/app_localizations.dart';

import '../models/nfc_tag.dart';
import '../services/nfc_service.dart';

class ScanScreen extends StatefulWidget {
  final String adventurePath;
  final bool debugMode;

  const ScanScreen({
    super.key,
    required this.adventurePath,
    this.debugMode = false,
  });

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final NfcService _nfcService;
  ScannedNfcTag? _lastScannedTag;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _nfcService = NfcService(adventurePath: widget.adventurePath);

    // Only start continuous scanning on Android
    if (!Platform.isIOS) {
      _startContinuousScanning();
    }
  }

  @override
  void dispose() {
    _nfcService.stopScanning();
    super.dispose();
  }

  Future<void> _startContinuousScanning() async {
    // Only for Android - continuous scanning
    while (mounted && !Platform.isIOS) {
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

  Future<void> _startSingleScan() async {
    // iOS-specific single scan
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    try {
      await _nfcService.readNfcTag(
        onTagScanned: (tag) {
          if (mounted) {
            setState(() {
              _lastScannedTag = tag;
              _isScanning = false;
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show appropriate instructions based on platform and scanning state
          if (Platform.isIOS) ...[
            if (_isScanning)
              Text(AppLocalizations.of(context)!.scanningInProgress)
            else
              Text(AppLocalizations.of(context)!.scanInstructionsIos),
            const SizedBox(height: 24),
            // Show scan button only on iOS
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _startSingleScan,
              icon: _isScanning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.nfc),
              label: Text(AppLocalizations.of(context)!.startScanButton),
            ),
          ] else ...[
            // Android: Show continuous scanning instructions
            Text(AppLocalizations.of(context)!.scanInstructions),
          ],

          // Debug info (shown on all platforms)
          if (widget.debugMode && _lastScannedTag != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(
                    ClipboardData(text: _lastScannedTag!.uid));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tag ID copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Last scanned tag ID: ${_lastScannedTag!.uid}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
