import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import 'neu_card.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  const NoteCard({super.key, required this.note, required this.onTap, required this.onFavorite});
  @override
  Widget build(BuildContext context) => NeuCard(onTap: onTap, padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(note.title.isEmpty ? 'Untitled note' : note.title,
        maxLines: 1, overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
        IconButton(visualDensity: VisualDensity.compact, onPressed: onFavorite,
          icon: Icon(note.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: note.isFavorite ? const Color(0xFFC2502A) : null))]),
      if (note.content.isNotEmpty) Text(note.content, maxLines: 3, overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
      const SizedBox(height: 12),
      Row(children: [if (note.tags.isNotEmpty) ...note.tags.take(2).map((tag) => Padding(
        padding: const EdgeInsets.only(right: 6), child: Chip(
          label: Text(tag, style: const TextStyle(fontSize: 11)), visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero))),
        const Spacer(), Text(DateFormat('MMM d').format(note.updatedAt),
          style: Theme.of(context).textTheme.labelSmall)]),
    ]));
}
