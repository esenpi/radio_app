import 'dart:async';
import 'dart:developer' as developer;

import 'package:radio_app/song/song_repository.dart';
import 'package:radio_app/song/index.dart';
import 'package:meta/meta.dart';
import 'package:radio_app/model/song.dart';

@immutable
import 'package:equatable/equatable.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class LoadAllSongsEvent extends SongEvent {
  const LoadAllSongsEvent();
}

class LoadNextSongEvent extends SongEvent {
  const LoadNextSongEvent();
}

class LoadingSongState extends SongState {
  LoadingSongState();
  @override
  String toString() => 'LoadingSongState';
}
