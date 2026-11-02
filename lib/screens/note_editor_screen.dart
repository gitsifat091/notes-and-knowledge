import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;
  const NoteEditorScreen({super.key, required this.note});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}
class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  late final TextEditingController _tags;
  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note.title);
    _content = TextEditingController(text: widget.note.content);
    _tags = TextEditingController(text: widget.note.tags.join(', '));
  }
  @override
  void dispose() { _title.dispose(); _content.dispose(); _tags.dispose(); super.dispose(); }

  Future<void> _save() async {
    widget.note.title = _title.text.trim();
    widget.note.content = _content.text.trim();
    widget.note.tags = _tags.text.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toSet().toList();
    await context.read<NotesProvider>().saveNote(widget.note);
    if (mounted) Navigator.pop(context);
  }
  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Delete note?'), content: const Text('This note will be removed from this device.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))]));
    if (confirmed == true && mounted) {
      await context.read<NotesProvider>().deleteNote(widget.note.id);
      if (mounted) Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit note'), actions: [
      if (widget.note.title.isNotEmpty || widget.note.content.isNotEmpty)
        IconButton(onPressed: _delete, icon: const Icon(Icons.delete_outline)),
      IconButton(onPressed: _save, icon: const Icon(Icons.check), tooltip: 'Save')]),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      TextField(controller: _title, maxLines: null, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        decoration: const InputDecoration(hintText: 'Note title', border: InputBorder.none, filled: false)),
      const SizedBox(height: 12),
      TextField(controller: _content, minLines: 12, maxLines: null, keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(hintText: 'Start writing your thoughts...', alignLabelWithHint: true)),
      const SizedBox(height: 18),
      Text('TAGS', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      TextField(controller: _tags, decoration: const InputDecoration(prefixIcon: Icon(Icons.sell_outlined),
        hintText: 'research, ideas, learning')),
      const SizedBox(height: 12),
      Text('Separate tags with commas.', style: Theme.of(context).textTheme.bodySmall),
    ])),
  );
}
