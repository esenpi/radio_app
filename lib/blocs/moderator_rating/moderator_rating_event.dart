import 'dart:async';
import 'dart:developer' as developer;

import 'package:radio_app/blocs/moderator_rating/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ModeratorRatingEvent {
  Stream<ModeratorRatingState> applyAsync(
      {ModeratorRatingState currentState, ModeratorRatingBloc bloc});
}

class UnModeratorRatingEvent extends ModeratorRatingEvent {
  @override
  Stream<ModeratorRatingState> applyAsync(
      {ModeratorRatingState? currentState, ModeratorRatingBloc? bloc}) async* {
    yield UnModeratorRatingState();
  }
}

class LoadModeratorRatingEvent extends ModeratorRatingEvent {
  @override
  Stream<ModeratorRatingState> applyAsync(
      {ModeratorRatingState? currentState, ModeratorRatingBloc? bloc}) async* {
    try {
      yield UnModeratorRatingState();
      await Future.delayed(const Duration(seconds: 1));
      yield InModeratorRatingState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadModeratorRatingEvent', error: _, stackTrace: stackTrace);
      yield ErrorModeratorRatingState(_.toString());
    }
  }
}
