// FILE: lib/repository/song_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radio_app/model/song.dart';

class SongRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchAllDocumentIDs() async {
    QuerySnapshot snapshot = await _firestore.collection('songs2').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<Song> fetchSong(String docId) async {
    DocumentSnapshot doc = await _firestore.collection('songs2').doc(docId).get();
    return Song(
      title: doc['title'],
      album: doc['album'],
      interpreter: doc['interpreter'],
      songUrl: doc['songUrl'],
      thumbnailUrl: doc['thumbnailUrl'],
    );
  }

  Future<String> fetchNextDocumentID(String currentDocId) async {
    List<String> documentIDs = await fetchAllDocumentIDs();
    int currentIndex = documentIDs.indexOf(currentDocId);
    if (currentIndex != -1 && currentIndex < documentIDs.length - 1) {
      return documentIDs[currentIndex + 1];
    } else {
      throw Exception("No next document ID found");
    }
  }
}