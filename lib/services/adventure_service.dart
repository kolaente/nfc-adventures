import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import '../models/adventure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdventureService {
  static const String _baseUrl = 'https://nfc-adventures.pages.dev';
  static const String _currentAdventureKey = 'current_adventure';

  Future<String?> getCurrentAdventure() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentAdventureKey);
  }

  Future<void> setCurrentAdventure(String adventureId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAdventureKey, adventureId);
  }

  Future<List<Adventure>> fetchAvailableAdventures() async {
    final response = await http.get(Uri.parse('$_baseUrl/adventures.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.entries
          .map((e) => Adventure.fromJson(e.key, e.value as String))
          .toList();
    }
    throw Exception('Failed to load adventures');
  }

  Future<void> downloadAndInstallAdventure(String adventureId) async {
    print("Downloading adventure: $adventureId");
    final response =
        await http.get(Uri.parse('$_baseUrl/adventures/$adventureId.zip'));
    if (response.statusCode != 200) {
      print("Download failed with status: ${response.statusCode}");
      throw Exception('Failed to download adventure');
    }

    print("Download successful, extracting...");
    final bytes = response.bodyBytes;
    final archive = ZipDecoder().decodeBytes(bytes);
    final appDir = await getApplicationDocumentsDirectory();
    final adventureDir = Directory('${appDir.path}/adventures/$adventureId');

    print("Creating directory: ${adventureDir.path}");
    if (!await adventureDir.exists()) {
      await adventureDir.create(recursive: true);
    }

    print("Extracting files...");
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final filePath = '${adventureDir.path}/$filename';
        print("Extracting: $filePath");
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }

    print("Setting current adventure...");
    await setCurrentAdventure(adventureId);
    print("Adventure installation complete");
  }

  Future<bool> isAdventureReady(String adventureId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final adventureDir = Directory('${appDir.path}/adventures/$adventureId');
    final tagsFile = File('${adventureDir.path}/tags.json');
    return await tagsFile.exists();
  }

  Future<String> getAdventurePath(String adventureId) async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/adventures/$adventureId';
  }
} 