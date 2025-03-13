import 'package:cloud_firestore/cloud_firestore.dart';

class ModeratorRating {
  final int rating;
  final bool shown;
  final Timestamp date;

  ModeratorRating({
    required this.rating,
    required this.shown,
    required this.date,
  });

  factory ModeratorRating.fromMap(Map<String, dynamic> data) {
    return ModeratorRating(
      rating: data['rating'],
      shown: data['shown'],
      date: data['date'],
    );
  }
}
