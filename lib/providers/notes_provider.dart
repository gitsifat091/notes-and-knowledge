import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/folder.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';

class NotesProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final List<Note> _notes = [];
  final List<NoteFolder> _folders = [];
  bool isDark = false;
  bool isLoaded = false;
  List<Note> get notes => List.unmodifiable(_notes);
  List<NoteFolder> get folders => List.unmodifiable(_folders);

  Future<void> load() async {
    _notes..clear()..addAll(_storage.getNotes());
    _folders..clear()..addAll(_storage.getFolders());
    isLoaded = true;
    notifyListeners();
  }

  Future<void> saveNote(Note note) async {
    note.updatedAt = DateTime.now();
    final index = _notes.indexWhere((item) => item.id == note.id);
    if (index < 0) { _notes.add(note); } else { _notes[index] = note; }
    await _storage.saveNote(note);
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _storage.deleteNote(id);
    notifyListeners();
  }

  Future<NoteFolder> createFolder(String name, {String parentId = ''}) async {
    final folder = NoteFolder(id: const Uuid().v4(), name: name, parentId: parentId);
    _folders.add(folder);
    await _storage.saveFolder(folder);
    notifyListeners();
    return folder;
  }

  Future<void> deleteFolder(String id) async {
    final childIds = _folders.where((f) => f.parentId == id).map((f) => f.id).toSet();
    for (final child in childIds) { await deleteFolder(child); }
    for (final note in _notes.where((n) => n.folderId == id).toList()) {
      note.folderId = '';
      await _storage.saveNote(note);
    }
    _folders.removeWhere((folder) => folder.id == id);
    await _storage.deleteFolder(id);
    notifyListeners();
  }

  void toggleFavorite(Note note) {
    note.isFavorite = !note.isFavorite;
    saveNote(note);
  }
  void toggleTheme() { isDark = !isDark; notifyListeners(); }
  NoteFolder? folderById(String id) {
    for (final folder in _folders) { if (folder.id == id) return folder; }
    return null;
  }
  List<NoteFolder> childFolders(String parentId) =>
      _folders.where((folder) => folder.parentId == parentId).toList();
  List<Note> notesInFolder(String folderId) =>
      _notes.where((note) => note.folderId == folderId).toList();
}
