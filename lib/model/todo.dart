class Todo {
  String? id;
  String title;
  String description;
  double moderatorRating;
  double playlistRating;
  String date;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.moderatorRating,
    required this.playlistRating,
    required this.date,
    required this.completed,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    double? moderatorRating,
    double? playlistRating,
    String? date,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      moderatorRating: moderatorRating ?? this.moderatorRating,
      playlistRating: playlistRating ?? this.playlistRating,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }
}
