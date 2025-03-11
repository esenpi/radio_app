import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:radio_app/blocs/moderator_rating/index.dart';

class ModeratorRatingBloc extends Bloc<ModeratorRatingEvent, ModeratorRatingState> {

  ModeratorRatingBloc(ModeratorRatingState initialState) : super(initialState){
   on<ModeratorRatingEvent>((event, emit) {
      return emit.forEach<ModeratorRatingState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'ModeratorRatingBloc', error: error, stackTrace: stackTrace);
          return ErrorModeratorRatingState(error.toString());
        },
      );
    });
  }
}
