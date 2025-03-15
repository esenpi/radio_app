import 'dart:async';
import 'dart:developer' as developer;

import 'package:radio_app/blocs/moderator_page%20(prospective%20feature%20-%20not%20used)/index.dart';
import 'package:meta/meta.dart';
import 'package:radio_app/model/moderator_rating.dart';
@immutable
import 'package:equatable/equatable.dart';

@immutable
abstract class ModeratorRatingEvent extends Equatable {
  const ModeratorRatingEvent();

  @override
  List<Object> get props => [];
}

class LoadModeratorRatingEvent extends ModeratorRatingEvent {
  @override
  const LoadModeratorRatingEvent();
}

class InsertModeratorRatingEvent extends ModeratorRatingEvent {
  final ModeratorRating moderatorRating;
  const InsertModeratorRatingEvent(this.moderatorRating);

  @override
  List<Object> get props => [moderatorRating];
}

class LoadingModeratorRatingState extends ModeratorRatingState {
  LoadingModeratorRatingState();
  @override
  String toString() => 'loadingModeratorRatingState';
}
