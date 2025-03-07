import 'dart:async';
import 'dart:developer' as developer;

import 'package:radio_app/song/song_repository.dart';
import 'package:radio_app/song/index.dart';
import 'package:meta/meta.dart';
import 'package:radio_app/model/song.dart';


@immutable
abstract class SongEvent {
  Stream<SongState> applyAsync({SongState currentState, SongBloc bloc});
}

class UnSongEvent extends SongEvent {
  @override
  Stream<SongState> applyAsync({SongState? currentState, SongBloc? bloc}) async* {
    yield UnSongState();
  }
}

class LoadSongEvent extends SongEvent {
  final String docId;
  final SongRepository _songRepository;

  LoadSongEvent(this.docId, this._songRepository);
   
  @override
  Stream<SongState> applyAsync(
      {SongState? currentState, SongBloc? bloc}) async* {
    try {
      yield UnSongState();
      Song song = await _songRepository.fetchSong(docId);
      yield InSongState(
        song.title,
        song.interpreter,
        song.album,
        song.thumbnailUrl,
        song.songUrl);
    } catch (error, stackTrace) {
      developer.log('$error', name: 'LoadSongEvent', error: error, stackTrace: stackTrace);
      yield ErrorSongState(error.toString());
    }
  }
}

class LoadAllSongsEvent extends SongEvent {
  final SongRepository _songRepository;

  LoadAllSongsEvent(this._songRepository);

  @override
  Stream<SongState> applyAsync(
      {SongState? currentState, SongBloc? bloc}) async* {
    try {
      yield UnSongState();
      List<String> documentIDs = await _songRepository.fetchAllDocumentIDs();
      yield AllSongsLoadedState(documentIDs);
    } catch (error, stackTrace) {
      developer.log('$error', name: 'LoadAllSongsEvent', error: error, stackTrace: stackTrace);
      yield ErrorSongState(error.toString());
    }
  }
}

class LoadNextSongEvent extends SongEvent {
  final String docId;
  final SongRepository _songRepository;

  LoadNextSongEvent(this.docId, this._songRepository);

  @override
  Stream<SongState> applyAsync(
      {SongState? currentState, SongBloc? bloc}) async* {
    try {
      yield UnSongState();
      Song song = await _songRepository.fetchSong(docId);
      yield InSongState(
        song.title,
        song.interpreter,
        song.album,
        song.thumbnailUrl,
        song.songUrl);
    } catch (error, stackTrace) {
      developer.log('$error', name: 'LoadNextSongEvent', error: error, stackTrace: stackTrace);
      yield ErrorSongState(error.toString());
    }
  }
}

