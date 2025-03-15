import 'package:equatable/equatable.dart';
import 'package:radio_app/model/moderator_rating.dart';

abstract class ModeratorRatingState extends Equatable {
  ModeratorRatingState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnModeratorRatingState extends ModeratorRatingState {
  UnModeratorRatingState();

  @override
  String toString() => 'UnModeratorRatingState';
}

/// Initialized
class InModeratorRatingState extends ModeratorRatingState {
  InModeratorRatingState(this.hello);

  final String hello;

  @override
  String toString() => 'InModeratorRatingState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorModeratorRatingState extends ModeratorRatingState {
  ErrorModeratorRatingState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorModeratorRatingState';

  @override
  List<Object> get props => [errorMessage];
}

class ModeratorRatingLoadedState extends ModeratorRatingState {
  final List<ModeratorRating> documentIDs;

  ModeratorRatingLoadedState(this.documentIDs);
}

class ModeratorRatingOperationSuccess extends ModeratorRatingState {
  final String message;

  ModeratorRatingOperationSuccess(this.message);

  @override
  String toString() => 'ModeratorRatingOperationSuccess';

  @override
  List<Object> get props => [message];
}

class ModeratorRatingError extends ModeratorRatingState {
  final String errorMessage;

  ModeratorRatingError(this.errorMessage);

  @override
  String toString() => 'ModeratorRatingError';

  @override
  List<Object> get props => [errorMessage];
}
