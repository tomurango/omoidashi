class Memo {
  final String id;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final List<String> tags;

  const Memo({
    required this.id,
    required this.content,
    this.type = 'memo',
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
      'tags': tags,
    };
  }

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as String,
      content: json['content'] as String,
      type: json['type'] as String? ?? 'memo',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  Memo copyWith({
    String? id,
    String? content,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    List<String>? tags,
  }) {
    return Memo(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          type == other.type &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isFavorite == other.isFavorite &&
          tags.toString() == other.tags.toString();

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isFavorite.hashCode ^
      tags.hashCode;

  @override
  String toString() {
    return 'Memo(id: $id, content: $content, type: $type, '
        'createdAt: $createdAt, updatedAt: $updatedAt, isFavorite: $isFavorite, tags: $tags)';
  }
}