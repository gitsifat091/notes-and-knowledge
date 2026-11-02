class Note {
  final String id;
  String title;
  String content;
  String folderId;
  List<String> tags;
  bool isFavorite;
  DateTime updatedAt;
  Note({required this.id, required this.title, required this.content,
    this.folderId = '', List<String>? tags, this.isFavorite = false, DateTime? updatedAt})
      : tags = tags ?? [], updatedAt = updatedAt ?? DateTime.now();

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String, title: json['title'] as String? ?? '',
    content: json['content'] as String? ?? '', folderId: json['folderId'] as String? ?? '',
    tags: List<String>.from(json['tags'] as List? ?? []),
    isFavorite: json['isFavorite'] as bool? ?? false,
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
  );
  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'content': content, 'folderId': folderId,
    'tags': tags, 'isFavorite': isFavorite, 'updatedAt': updatedAt.toIso8601String(),
  };
}
