import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


Future<void> enregistrer(List<Map<String, dynamic>> notes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String notesJson = json.encode(notes);
  await prefs.setString('notes', notesJson);
}

Future<List<Map<String, dynamic>>> loadNotes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? notesJson = prefs.getString('notes');
  if (notesJson != null) {
    List<Map<String, dynamic>> notes = List<Map<String, dynamic>>.from(json.decode(notesJson));
    triDate(notes);
    return notes;
  }
  return [];
}

void triDate(List<Map<String, dynamic>> notes) {
  notes.sort((a, b) {
    DateTime dateA = DateTime.parse(a['dateTime']);
    DateTime dateB = DateTime.parse(b['dateTime']);
    return dateB.compareTo(dateA);
  });
}
