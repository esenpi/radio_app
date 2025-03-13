import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:bloc/bloc.dart'; // This import is redundant
import 'package:radio_app/blocs/moderator_rating/index.dart';
import 'package:radio_app/model/moderator_rating.dart';
// import '../../repository/firestore_repository.dart';
import 'package:radio_app/blocs/moderator_rating/moderator_rating_repository.dart';

class ModeratorRatingBloc
    extends Bloc<ModeratorRatingEvent, ModeratorRatingState> {
  final ModeratorRatingRepository moderatorRatingRepository;

  List<ModeratorRating> moderatorRatings = [];

  ModeratorRatingBloc(this.moderatorRatingRepository)
      : super(UnModeratorRatingState()) {
    on<LoadModeratorRatingEvent>((event, emit) async {
      try {
        emit(LoadingModeratorRatingState());
        moderatorRatings =
            await moderatorRatingRepository.getModeratorRatings();
        await Future.delayed(const Duration(seconds: 1));
        emit(ModeratorRatingLoadedState(moderatorRatings));
      } catch (error, stackTrace) {
        developer.log('$error',
            name: 'LoadModeratorRatingEvent',
            error: error,
            stackTrace: stackTrace);
        emit(ErrorModeratorRatingState(error.toString()));
      }
    });

    on<InsertModeratorRatingEvent>((event, emit) async {
      try {
        emit(LoadingModeratorRatingState());
        await moderatorRatingRepository
            .insertModeratorRating(event.moderatorRating);
        emit(ModeratorRatingOperationSuccess(
            'ModeratorRating added successfully.'));
      } catch (error, stackTrace) {
        developer.log('$error',
            name: 'InsertModeratorRatingEvent',
            error: error,
            stackTrace: stackTrace);
        emit(ModeratorRatingError('Failed to add moderatorRating.'));
      }
    });
  }
}
