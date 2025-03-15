class Rating {
  String? id;
  String title;
  String description;
  double moderatorRating;
  double playlistRating;
  String date;
  bool completed;

  Rating({
    required this.id,
    required this.title,
    required this.description,
    required this.moderatorRating,
    required this.playlistRating,
    required this.date,
    required this.completed,
  });

  Rating copyWith({
    String? id,
    String? title,
    String? description,
    double? moderatorRating,
    double? playlistRating,
    String? date,
    bool? completed,
  }) {
    return Rating(
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
