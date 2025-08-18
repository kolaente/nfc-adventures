import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/adventure_service.dart';

class QrScannerScreen extends StatefulWidget {
  final Function(String) onAdventureSelected;
  final ThemeMode themeMode;

  const QrScannerScreen({
    super.key,
    required this.onAdventureSelected,
    required this.themeMode,
  });

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final AdventureService _adventureService = AdventureService();
  bool _isProcessing = false;
  MobileScannerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _processQrCode(String adventureId) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // Check if adventure is already installed
      final isReady = await _adventureService.isAdventureReady(adventureId);
      if (isReady) {
        final adventurePath = await _adventureService.getAdventurePath(adventureId);
        widget.onAdventureSelected(adventurePath);
        return;
      }

      // Download and install the adventure
      await _adventureService.downloadAndInstallAdventure(adventureId);
      
      if (!mounted) return;

      // Get the adventure path and navigate
      final adventurePath = await _adventureService.getAdventurePath(adventureId);
      widget.onAdventureSelected(adventurePath);
    } catch (e) {
      if (!mounted) return;
      
      // Show error as toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Reset processing state and resume scanning
      setState(() {
        _isProcessing = false;
      });
      await _controller?.start();
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty || _isProcessing) return;

    final barcode = barcodes.first;
    final adventureId = barcode.rawValue;
    
    if (adventureId == null || adventureId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.errorInvalidQrCode ?? 'Invalid QR code'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Stop scanner while processing valid QR code
    await _controller?.stop();
    await _processQrCode(adventureId);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button if this is the initial screen  
      onWillPop: () async => ModalRoute.of(context)?.settings.name != '/',
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.adventureSelectionTitle ?? 'Scan QR Code'),
          automaticallyImplyLeading: ModalRoute.of(context)?.settings.name != '/',
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _onDetect,
                    ),
                  if (_isProcessing)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  // Overlay with instructions
                  if (!_isProcessing)
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.qrScanInstructions ?? 'Point camera at QR code to scan adventure',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}