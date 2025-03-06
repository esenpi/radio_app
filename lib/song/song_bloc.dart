import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:radio_app/song/index.dart';

class SongBloc extends Bloc<SongEvent, SongState> {

  SongBloc(SongState initialState) : super(initialState){
   on<SongEvent>((event, emit) {
      return emit.forEach<SongState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'SongBloc', error: error, stackTrace: stackTrace);
          return ErrorSongState(error.toString());
        },
      );
    });
  }
}
