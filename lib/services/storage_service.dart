import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nfc_tag.dart';

class StorageService {
  static const String _key = 'collected_tags';

  Future<List<NfcTag>> getCollectedTags() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tagsJson = prefs.getString(_key);
    if (tagsJson == null) return [];

    List<dynamic> tagsList = jsonDecode(tagsJson);
    return tagsList.map((json) => NfcTag.fromJson(json)).toList();
  }

  Future<void> saveCollectedTag(NfcTag tag) async {
    final prefs = await SharedPreferences.getInstance();
    List<NfcTag> existingTags = await getCollectedTags();

    if (!existingTags.any((t) => t.uid == tag.uid)) {
      existingTags.add(tag);
      final String tagsJson =
          jsonEncode(existingTags.map((t) => t.toJson()).toList());
      await prefs.setString(_key, tagsJson);
    }
  }
}
