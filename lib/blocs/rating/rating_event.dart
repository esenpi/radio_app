import 'package:flutter/material.dart';
import '../../model/rating.dart';

@immutable
abstract class RatingEvent {}

class LoadRatings extends RatingEvent {}

class AddRating extends RatingEvent {
  final Rating rating;

  AddRating(this.rating);
}

class UpdateRating extends RatingEvent {
  final String ratingId;
  final Rating rating;
  UpdateRating(this.ratingId, this.rating);
}

class DeleteRating extends RatingEvent {
  final String ratingId;

  DeleteRating(this.ratingId);
}
