import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/adventure.dart';
import '../services/adventure_service.dart';

class AdventureSelectionScreen extends StatefulWidget {
  final Function(String) onAdventureSelected;
  final ThemeMode themeMode;

  const AdventureSelectionScreen({
    super.key,
    required this.onAdventureSelected,
    required this.themeMode,
  });

  @override
  State<AdventureSelectionScreen> createState() =>
      _AdventureSelectionScreenState();
}

class _AdventureSelectionScreenState extends State<AdventureSelectionScreen> {
  final AdventureService _adventureService = AdventureService();
  late Future<List<Adventure>> _adventuresFuture;

  @override
  void initState() {
    super.initState();
    _adventuresFuture = _adventureService.fetchAvailableAdventures();
  }

  void _retryLoading() {
    setState(() {
      _adventuresFuture = _adventureService.fetchAvailableAdventures();
    });
  }

  Future<void> _downloadAndNavigate(Adventure adventure) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await _adventureService.downloadAndInstallAdventure(adventure.id);

      if (!mounted) return;

      // Get the adventure path
      final adventurePath =
          await _adventureService.getAdventurePath(adventure.id);

      // Remove loading indicator
      Navigator.of(context).pop();

      widget.onAdventureSelected(adventurePath);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Remove loading indicator

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.errorGeneric(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button if this is the initial screen
      onWillPop: () async => ModalRoute.of(context)?.settings.name != '/',
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.adventureSelectionTitle),
          // Only show back button if this isn't the initial screen
          automaticallyImplyLeading:
              ModalRoute.of(context)?.settings.name != '/',
        ),
        body: FutureBuilder<List<Adventure>>(
          future: _adventuresFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!
                        .errorGeneric(snapshot.error.toString())),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryLoading,
                      child: Text(AppLocalizations.of(context)!.retryButton),
                    ),
                  ],
                ),
              );
            }

            final adventures = snapshot.data!;
            return ListView.builder(
              itemCount: adventures.length,
              itemBuilder: (context, index) {
                final adventure = adventures[index];
                return ListTile(
                  title: Text(adventure.title),
                  onTap: () => _downloadAndNavigate(adventure),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
