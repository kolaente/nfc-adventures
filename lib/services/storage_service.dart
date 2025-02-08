import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nfc_tag.dart';

class StorageService {
  static const String _key = 'collected_tags';

  Future<List<ScannedNfcTag>> getCollectedTags() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tagsJson = prefs.getString(_key);
    if (tagsJson == null) return [];

    List<dynamic> tagsList = jsonDecode(tagsJson);
    return tagsList.map((json) => ScannedNfcTag.fromJson(json)).toList();
  }

  Future<void> saveCollectedTag(ScannedNfcTag tag) async {
    final prefs = await SharedPreferences.getInstance();
    List<ScannedNfcTag> existingTags = await getCollectedTags();

    int existingIndex = existingTags.indexWhere((t) => t.uid == tag.uid);
    if (existingIndex >= 0) {
      existingTags[existingIndex] = tag;
    } else {
      existingTags.add(tag);
    }

    final String tagsJson =
        jsonEncode(existingTags.map((t) => t.toJson()).toList());
    await prefs.setString(_key, tagsJson);
  }
}
