import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radio_app/model/moderator_rating.dart';
import 'package:radio_app/model/rating.dart';

class FirestoreService {
  final CollectionReference _ratingsCollection = FirebaseFirestore.instance
      .collection('ratings'); // Use a fixed collection name
  // final CollectionReference _moderatorRatingCollection = FirebaseFirestore.instance.collection('moderator_rating');

  String get currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'default';

  Stream<List<Rating>> getRatings() {
    return _ratingsCollection
        .doc('ratings')
        .collection('user_ratings')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        print("getRatings data:  ${data}");
        return Rating(
          id: doc.id,
          title: data['title'] ?? 'kein Titel',
          description: data['description'] ?? 'keine Beschreibung',
          moderatorRating: data['moderatorRating'].toDouble() ?? 0.0,
          playlistRating: data['playlistRating'].toDouble() ?? 0.0,
          date: data['date'],
          completed: data['completed'],
        );
      }).toList();
    });
  }

  Future<void> addRating(Rating rating) {
    // currentUser has been replaced with a standard collection called ratings
    return _ratingsCollection.doc('ratings').collection('user_ratings').add({
      'title': rating.title,
      'description': rating.description,
      'moderatorRating': rating.moderatorRating,
      'playlistRating': rating.playlistRating,
      'date': rating.date,
      'completed': rating.completed,
    });
  }

  Future<void> updateRating(String ratingId, Rating rating) {
    return _ratingsCollection
        .doc('ratings')
        .collection('user_ratings')
        .doc(ratingId)
        .update({
      'title': rating.title,
      'description': rating.description,
      'moderatorRating': rating.moderatorRating,
      'playlistRating': rating.playlistRating,
      'date': rating.date,
      'completed': rating.completed,
    });
  }

  Future<void> deleteRating(String ratingId) {
    return _ratingsCollection
        .doc('ratings')
        .collection('user_ratings')
        .doc(ratingId)
        .delete();
  }

  /*

  // add moderator rating
  Future<void> addModeratorRating(ModeratorRating moderatorRating) {
    return _moderatorRatingCollection.add({
      'rating': moderatorRating.rating,
      'date': moderatorRating.date,
      'shown': moderatorRating.shown,
    });
  }

  Future<List<ModeratorRating>> getModeratorRatings() async {
    QuerySnapshot snapshot = await _moderatorRatingCollection.get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ModeratorRating(
        rating: data['rating'],
        date: data['date'],
        shown: data['shown'],
      );
    }).toList();
  }

*/
}





//  class FirestoreService {

  
//   final CollectionReference _todosCollection =
//   FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!);


//   Stream<List<Todo>> getTodos() {
//     return _todosCollection.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return Todo(
//           id: doc.id,
//           title: data['title'],
//           completed: data['completed'],
//         );
//       }).toList();
//     });
//   }

//   Future<void> addTodo(Todo todo) {
//     return _todosCollection.add({
//       'title': todo.title,
//       'completed': todo.completed,
//     });
//   }

//   Future<void> updateTodo(String todoId,Todo todo) {
//     return _todosCollection.doc(todoId).update({
//       'title': todo.title,
//       'completed': todo.completed,
//     });
//   }
//   Future<void> deleteTodo(String todoId) {
//     return _todosCollection.doc(todoId).delete();
//   }
// }