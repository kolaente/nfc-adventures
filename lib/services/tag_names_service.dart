import 'dart:convert';
import 'package:flutter/services.dart';

class TagNamesService {
  static Future<Map<String, String>> loadTagNames() async {
    final String jsonString = await rootBundle.loadString('assets/tags.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Map<String, String>.from(jsonMap);
  }
}
