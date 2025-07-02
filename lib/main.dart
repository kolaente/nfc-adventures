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
  final AdventureService _adventureService = AdventureService();
  String? _adventureTitle;

  // Debug mode state
  bool _debugMode = false;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _loadAdventureTitle();
  }

  List<Widget> get _screens => [
        ScanScreen(
          adventurePath: widget.adventurePath,
          debugMode: _debugMode,
        ),
        CollectionScreen(
          adventurePath: widget.adventurePath,
          debugMode: _debugMode,
        ),
      ];

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

  void _handleTitleTap() {
    final now = DateTime.now();

    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    if (_tapCount >= 10) {
      setState(() {
        _debugMode = !_debugMode;
        _tapCount = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(_debugMode ? 'Debug mode enabled' : 'Debug mode disabled'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _handleTitleTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_adventureTitle ?? AppLocalizations.of(context)!.appTitle),
              if (_debugMode) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Debug',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
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
