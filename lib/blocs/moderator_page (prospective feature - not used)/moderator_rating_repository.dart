import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:radio_app/blocs/moderator_page%20(prospective%20feature%20-%20not%20used)/moderator_rating_event.dart';
import 'package:radio_app/blocs/moderator_page%20(prospective%20feature%20-%20not%20used)/moderator_rating_state.dart';
import 'package:radio_app/model/moderator_rating.dart';

class ModeratorRatingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ModeratorRating>> getModeratorRatings() async {
    final moderatorRatingCollection =
        await _firestore.collection('moderator_rating').get();
    return moderatorRatingCollection.docs
        .map((doc) => ModeratorRating.fromMap(doc.data()))
        .toList();
  }

  Future<void> insertModeratorRating(ModeratorRating moderatorRating) async {
    await _firestore.collection('moderator_rating').add({
      'rating': moderatorRating.rating,
      'shown': moderatorRating.shown,
      'date': moderatorRating.date,
    });
  }
}
