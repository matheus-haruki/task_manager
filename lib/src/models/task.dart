import 'dart:convert';

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isDone;
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isDone = false,
  });

  factory Task.create({
    required int id,
    required String title,
    required String description,
    required DateTime createdAt,
  }) {
    return Task(
      id: id,
      title: title.trim(),
      description: description.trim(),
      createdAt: createdAt,
    );
  }

  Task complete() => isDone ? this : copyWith(isDone: true);
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isDone: map['isDone'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.isDone == isDone;
  }

  @override
  int get hashCode => Object.hash(id, title, description, createdAt, isDone);
}
