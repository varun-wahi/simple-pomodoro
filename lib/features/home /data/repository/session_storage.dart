import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {

  Future<List<Map<String, dynamic>>> retrieveSessionData() async {
  final prefs = await SharedPreferences.getInstance();
  final sessionList = prefs.getStringList('sessions') ?? [];

  return sessionList
      .map((session) => Map<String, dynamic>.from(jsonDecode(session)))
      .toList();
}

Future<void> clearInvalidSessions() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('sessions'); // Clear existing invalid data
}
  
}