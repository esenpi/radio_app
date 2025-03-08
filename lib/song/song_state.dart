import 'package:equatable/equatable.dart';
import 'package:radio_app/model/song.dart';

abstract class SongState extends Equatable {
  SongState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnSongState extends SongState {
  UnSongState();

  @override
  String toString() => 'UnSongState';
}

/// Initialized
class InSongState extends SongState {
  final String title;
  final String interpreter;
  final String album;
  final String thumbnailUrl;
  final String songUrl;

  InSongState(this.title, this.interpreter, this.album, this.thumbnailUrl, this.songUrl);

  @override
  String toString() => 'InSongState {title: $title, interpreter: $interpreter, album: $album, thumbnailUrl: $thumbnailUrl, songUrl: $songUrl}';

  @override
  List<Object> get props => [title, interpreter, album, thumbnailUrl, songUrl];
}

class AllSongsLoadedState extends SongState {
  final List<String> documentIDs;

  AllSongsLoadedState(this.documentIDs);
}

class SongLoadedState extends SongState {
  final Song song;

  SongLoadedState(this.song);
}

class SongsLoadedState extends SongState {
  final List<Song> songs;
  SongsLoadedState(this.songs);
  @override
  List<Object> get props => [songs];
}

class ErrorSongState extends SongState {
  ErrorSongState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorSongState';

  @override
  List<Object> get props => [errorMessage];
}

class LoadingNextSongState extends SongState {}
