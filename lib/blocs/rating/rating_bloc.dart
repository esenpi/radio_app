import 'package:radio_app/blocs/rating/rating_event.dart';
import 'package:radio_app/blocs/rating/rating_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/firestore_repository.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final FirestoreService _firestoreService;

  RatingBloc(this._firestoreService) : super(RatingInitial()) {
    on<LoadRatings>((event, emit) async {
      try {
        emit(RatingLoading());
        final ratings = await _firestoreService.getRatings().first;
        print("ratings im rating_bloc.dart");
        print(ratings);
        emit(RatingLoaded(ratings));
      } catch (e, stackTrace) {
        print("Error loading ratings: $e");
        print(stackTrace);
        emit(RatingError('Failed to load ratings.'));
      }
    });

    on<AddRating>((event, emit) async {
      try {
        emit(RatingLoading());
        await _firestoreService.addRating(event.rating);
        emit(RatingOperationSuccess('rating added successfully.'));
      } catch (e) {
        emit(RatingError('Failed to add rating.'));
      }
    });

    on<UpdateRating>((event, emit) async {
      try {
        emit(RatingLoading());
        await _firestoreService.updateRating(event.ratingId, event.rating);
        emit(RatingOperationSuccess('Rating updated successfully.'));
      } catch (e) {
        emit(RatingError('Failed to update rating.'));
      }
    });

    on<DeleteRating>((event, emit) async {
      try {
        emit(RatingLoading());
        await _firestoreService.deleteRating(event.ratingId);
        emit(RatingOperationSuccess('Rating deleted successfully.'));
      } catch (e) {
        emit(RatingError('Failed to delete rating.'));
      }
    });
  }
}
