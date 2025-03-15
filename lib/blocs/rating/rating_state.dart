import 'package:flutter/material.dart';
import '../../model/rating.dart';

@immutable
abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingLoaded extends RatingState {
  final List<Rating> ratings;

  RatingLoaded(this.ratings);
}

class RatingOperationSuccess extends RatingState {
  final String message;

  RatingOperationSuccess(this.message);
}

class RatingError extends RatingState {
  final String errorMessage;

  RatingError(this.errorMessage);
}
