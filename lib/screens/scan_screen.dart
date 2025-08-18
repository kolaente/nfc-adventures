import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

import '../models/nfc_tag.dart';
import '../services/nfc_service.dart';
import '../services/image_path_service.dart';

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

              // Show snackbar for accessibility
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .tagScannedSuccess(tag.name)),
                  duration: const Duration(seconds: 2),
                ),
              );

              // Show image preview dialog
              _showTagImagePreview(tag);
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

  void _showTagImagePreview(ScannedNfcTag tag) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TagImagePreviewDialog(tag: tag);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.scanInstructions),
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

class TagImagePreviewDialog extends StatefulWidget {
  final ScannedNfcTag tag;

  const TagImagePreviewDialog({
    super.key,
    required this.tag,
  });

  @override
  State<TagImagePreviewDialog> createState() => _TagImagePreviewDialogState();
}

class _TagImagePreviewDialogState extends State<TagImagePreviewDialog> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
            maxHeight: 400,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tag name header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  widget.tag.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Image
              Container(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 300,
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImagePathService.getImage(
                      widget.tag.uid,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Tap to close hint
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  AppLocalizations.of(context)!.tapToClose,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
