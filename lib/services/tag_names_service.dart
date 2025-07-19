import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class TagNamesService {
  static Future<Map<String, String>> loadTagNames(String adventurePath) async {
    final file = File('$adventurePath/tags.json');
    final jsonString = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Map<String, String>.from(
      jsonMap.map((key, value) => MapEntry(key.toString().toLowerCase(), value.toString()))
    );
  }
}
