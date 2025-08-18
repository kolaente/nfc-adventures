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
  static const String _adventureTitleKey = 'adventure_title';

  Future<String?> getCurrentAdventure() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentAdventureKey);
  }

  Future<void> setCurrentAdventure(String adventureId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAdventureKey, adventureId);
  }

  Future<String?> getAdventureTitle(String adventureId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_adventureTitleKey:$adventureId');
  }

  Future<void> setAdventureTitle(String adventureId, String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_adventureTitleKey:$adventureId', title);
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
    final response =
        await http.get(Uri.parse('$_baseUrl/adventures/$adventureId.zip'));
    if (response.statusCode != 200) {
      throw Exception('Failed to download adventure');
    }

    // Get the adventure title from the available adventures
    final adventures = await fetchAvailableAdventures();
    final adventure = adventures.where((a) => a.id == adventureId).firstOrNull;
    if (adventure == null) {
      throw Exception('Adventure with ID "$adventureId" not found');
    }
    await setAdventureTitle(adventureId, adventure.title);

    final bytes = response.bodyBytes;
    final archive = ZipDecoder().decodeBytes(bytes);
    final appDir = await getApplicationDocumentsDirectory();
    final adventureDir = Directory('${appDir.path}/adventures/$adventureId');

    if (!await adventureDir.exists()) {
      await adventureDir.create(recursive: true);
    }

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final filePath = '${adventureDir.path}/$filename';
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }

    // Lowercase all image filenames after extraction
    final imagesDir = Directory('${adventureDir.path}/images');
    if (await imagesDir.exists()) {
      await for (final entity in imagesDir.list()) {
        if (entity is File) {
          final fileName = entity.path.split('/').last;
          final lowerCaseFileName = fileName.toLowerCase();
          
          if (fileName != lowerCaseFileName) {
            final newPath = '${imagesDir.path}/$lowerCaseFileName';
            await entity.rename(newPath);
          }
        }
      }
    }

    await setCurrentAdventure(adventureId);
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

  Future<String> getAdventureName(String adventurePath) async {
    final adventureId = adventurePath.split('/').last;
    final title = await getAdventureTitle(adventureId);
    if (title != null) {
      return title;
    }
    return 'Unknown Adventure';
  }
}
