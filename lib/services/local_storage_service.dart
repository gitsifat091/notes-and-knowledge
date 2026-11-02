import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/folder.dart';
import '../models/note.dart';

class LocalStorageService {
  Box<String> get _notes => Hive.box<String>('notes');
  Box<String> get _folders => Hive.box<String>('folders');

  List<Note> getNotes() => _notes.values
      .map((value) => Note.fromJson(jsonDecode(value) as Map<String, dynamic>)).toList();
  List<NoteFolder> getFolders() => _folders.values
      .map((value) => NoteFolder.fromJson(jsonDecode(value) as Map<String, dynamic>)).toList();

  Future<void> saveNote(Note note) => _notes.put(note.id, jsonEncode(note.toJson()));
  Future<void> deleteNote(String id) => _notes.delete(id);
  Future<void> saveFolder(NoteFolder folder) => _folders.put(folder.id, jsonEncode(folder.toJson()));
  Future<void> deleteFolder(String id) => _folders.delete(id);
}
