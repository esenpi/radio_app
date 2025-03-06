// FILE: lib/repository/song_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radio_app/model/song.dart';

class SongRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Song> fetchSong(String docId) async {
    DocumentSnapshot snapshot = await _firestore.collection('songs').doc(docId).get();
    if (snapshot.exists) {
      return Song.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('Song not found');
    }
  }
}