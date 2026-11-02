class NoteFolder {
  final String id;
  String name;
  String parentId;
  int colorValue;
  DateTime createdAt;
  NoteFolder({required this.id, required this.name, this.parentId = '',
    this.colorValue = 0xFFC2502A, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  factory NoteFolder.fromJson(Map<String, dynamic> json) => NoteFolder(
    id: json['id'] as String, name: json['name'] as String? ?? 'Untitled',
    parentId: json['parentId'] as String? ?? '',
    colorValue: json['colorValue'] as int? ?? 0xFFC2502A,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
  );
  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'parentId': parentId,
    'colorValue': colorValue, 'createdAt': createdAt.toIso8601String(),
  };
}
