class Song {
  final String title;
  final String interpreter;
  final String album;
  final String thumbnailUrl;
  final String songUrl;
  final bool wished;

  Song({
    required this.title,
    required this.interpreter,
    required this.album,
    required this.thumbnailUrl,
    required this.songUrl,
    required this.wished,
  });

  factory Song.fromMap(Map<String, dynamic> data) {
    return Song(
      title: data['title'],
      interpreter: data['interpreter'],
      album: data['album'],
      thumbnailUrl: data['thumbnailUrl'],
      songUrl: data['songUrl'],
      wished: data['wished'],
    );
  }
}
