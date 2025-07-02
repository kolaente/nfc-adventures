import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/scan_screen.dart';
import 'screens/collection_screen.dart';
import 'screens/adventure_selection_screen.dart';
import 'services/adventure_service.dart';

void main() {
  runApp(const NfcCollectorApp());
}

class NfcCollectorApp extends StatefulWidget {
  const NfcCollectorApp({super.key});

  @override
  State<NfcCollectorApp> createState() => _NfcCollectorAppState();
}

class _NfcCollectorAppState extends State<NfcCollectorApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final AdventureService _adventureService = AdventureService();
  String? _currentAdventurePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentAdventure();
  }

  Future<void> _checkCurrentAdventure() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentAdventureId = await _adventureService.getCurrentAdventure();

      if (currentAdventureId != null) {
        final isReady =
            await _adventureService.isAdventureReady(currentAdventureId);

        if (isReady) {
          final path =
              await _adventureService.getAdventurePath(currentAdventureId);
          if (!mounted) return;
          setState(() {
            _currentAdventurePath = path;
            _isLoading = false;
          });
          return;
        }
      }

      if (!mounted) return;
      setState(() {
        _currentAdventurePath = null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAdventurePath = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _showAdventureSelection(BuildContext context) async {
    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdventureSelectionScreen(
          onAdventureSelected: _handleAdventureSelected,
          themeMode: _themeMode,
        ),
        settings: RouteSettings(
            name: _currentAdventurePath == null ? '/' : '/select'),
      ),
    );

    if (result == true) {
      await _checkCurrentAdventure();
    }
  }

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _handleAdventureSelected(String adventurePath) {
    setState(() {
      _currentAdventurePath = adventurePath;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Tag Collector',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('de'), // German
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: _themeMode,
      home: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (_currentAdventurePath == null) {
            return AdventureSelectionScreen(
              onAdventureSelected: _handleAdventureSelected,
              themeMode: _themeMode,
            );
          }

          return MainScreen(
            toggleTheme: toggleTheme,
            adventurePath: _currentAdventurePath!,
            onSelectNewAdventure: () => _showAdventureSelection(context),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final String adventurePath;
  final VoidCallback onSelectNewAdventure;
  const MainScreen({
    super.key,
    required this.toggleTheme,
    required this.adventurePath,
    required this.onSelectNewAdventure,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  final AdventureService _adventureService = AdventureService();
  String? _adventureTitle;

  @override
  void initState() {
    super.initState();
    _screens = [
      ScanScreen(adventurePath: widget.adventurePath),
      CollectionScreen(adventurePath: widget.adventurePath),
    ];
    _loadAdventureTitle();
  }

  Future<void> _loadAdventureTitle() async {
    try {
      final title =
          await _adventureService.getAdventureName(widget.adventurePath);
      if (mounted) {
        setState(() {
          _adventureTitle = title;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!
                .errorLoadingAdventureTitle(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(_adventureTitle ?? AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.nfc),
            label: AppLocalizations.of(context)!.bottomNavScan,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.collections),
            label: AppLocalizations.of(context)!.bottomNavCollection,
          ),
        ],
      ),
    );
  }
}
