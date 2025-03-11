import 'package:equatable/equatable.dart';

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
