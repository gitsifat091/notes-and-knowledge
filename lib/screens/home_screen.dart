import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/neu_card.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _query = '';
  String _filter = 'All';
  String _folderId = '';
  @override
  void dispose() { _search.dispose(); super.dispose(); }

  Future<void> _newNote() async {
    final provider = context.read<NotesProvider>();
    final note = Note(id: const Uuid().v4(), title: '', content: '', folderId: _folderId);
    await Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)));
  }
  Future<void> _newFolder() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(context: context, builder: (context) => AlertDialog(
      title: const Text('New folder'), content: TextField(controller: controller,
        autofocus: true, decoration: const InputDecoration(hintText: 'Folder name')),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('Create'))]));
    if (name != null && name.isNotEmpty && mounted) {
      await context.read<NotesProvider>().createFolder(name, parentId: _folderId);
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(builder: (context, state, _) {
      final folder = _folderId.isEmpty ? null : state.folderById(_folderId);
      final folders = state.childFolders(_folderId);
      final notes = state.notes.where((note) {
        final matchesFolder = note.folderId == _folderId;
        final matchesSearch = note.title.toLowerCase().contains(_query.toLowerCase()) ||
          note.content.toLowerCase().contains(_query.toLowerCase()) ||
          note.tags.any((tag) => tag.toLowerCase().contains(_query.toLowerCase()));
        final matchesFilter = _filter == 'All' || (_filter == 'Favorites' && note.isFavorite) ||
          (_filter == 'Untagged' && note.tags.isEmpty);
        return matchesFolder && matchesSearch && matchesFilter;
      }).toList()..sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
      return Scaffold(
        appBar: AppBar(leading: _folderId.isNotEmpty ? IconButton(icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _folderId = folder?.parentId ?? '')) : null,
          title: Text(folder?.name ?? 'My Knowledge', style: const TextStyle(fontWeight: FontWeight.w800)),
          actions: [IconButton(tooltip: 'Toggle theme', onPressed: state.toggleTheme,
            icon: Icon(state.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined))]),
        floatingActionButton: FloatingActionButton.extended(onPressed: _newNote,
          icon: const Icon(Icons.add), label: const Text('New note')),
        body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            Text('Capture ideas. Build knowledge.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            TextField(controller: _search, onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search),
                hintText: 'Search notes, content, or tags')),
            const SizedBox(height: 16),
            Row(children: ['All', 'Favorites', 'Untagged'].map((filter) => Padding(
              padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(filter),
                selected: _filter == filter, onSelected: (_) => setState(() => _filter = filter)))).toList()),
            const SizedBox(height: 20),
            Row(children: [Text('Folders', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(), TextButton.icon(onPressed: _newFolder, icon: const Icon(Icons.create_new_folder_outlined),
                label: const Text('New folder'))]),
            if (folders.isEmpty) Text('No folders here yet.', style: Theme.of(context).textTheme.bodySmall),
            ...folders.map((folder) => Padding(padding: const EdgeInsets.only(bottom: 10),
              child: NeuCard(onTap: () => setState(() => _folderId = folder.id),
                child: Row(children: [Icon(Icons.folder_rounded, color: Color(folder.colorValue)),
                  const SizedBox(width: 12), Expanded(child: Text(folder.name,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
                  Text('${state.notesInFolder(folder.id).length}'), const Icon(Icons.chevron_right)])))),
            const SizedBox(height: 12),
            Text('Notes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            if (notes.isEmpty) NeuCard(child: Column(children: [
              const Icon(Icons.note_add_outlined, size: 36), const SizedBox(height: 8),
              Text(_query.isEmpty ? 'No notes yet' : 'No matching notes'),
              const SizedBox(height: 4), const Text('Create a note to get started.'),
            ])),
            ...notes.map((note) => Padding(padding: const EdgeInsets.only(bottom: 14),
              child: NoteCard(note: note, onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note))),
                onFavorite: () => state.toggleFavorite(note)))),
          ]))),
    );
  }
}
