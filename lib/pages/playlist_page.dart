/*import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return const Text("Playlist Page");
  }
} */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/pages/login_page.dart';
import 'package:radio_app/pages/playlist_page.dart';
import 'package:radio_app/pages/radio_page.dart';
// import 'song/song_page.dart';
// import 'song/song_screen.dart';
// import 'song/song_repository.dart';
// import 'song/song_bloc.dart';
// import 'song/song_event.dart';
// import 'song/song_state.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return const Text("Playlist Page");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Playlist',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const PlaylistScreen(),
    );
  }
}

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();

  /// Referenz zur Firestore-Sammlung "songs"
  final CollectionReference songsRef =
      FirebaseFirestore.instance.collection('songs');

  /// Fügt einen Song zur Firestore-Datenbank hinzu
  void _addSong() {
    String title = _songController.text.trim();
    String artist = _artistController.text.trim();

    if (title.isNotEmpty && artist.isNotEmpty) {
      songsRef.add({
        "number": DateTime.now().millisecondsSinceEpoch, // Zeitstempel als ID
        "title": title,
        "artist": artist,
        "image": "assets/headphones-2588056_640.jpg", // Standardbild
        "wished": true // Markierung als gewünscht
      });

      _songController.clear();
      _artistController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playlist"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _artistController,
                  decoration: InputDecoration(
                    labelText: "Interpret",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _songController,
                  decoration: InputDecoration(
                    labelText: "Titel",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _addSong,
                  child: const Text("Song hinzufügen",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const Divider(),

          /// Echtzeit-Daten aus Firestore abrufen und anzeigen
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: songsRef.orderBy("number", descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("Keine Songs in der Playlist"));
                }

                // Firestore-Daten in eine Liste umwandeln
                var songs = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return {
                    "number": data["number"],
                    "title": data["title"],
                    "artist": data["artist"],
                    "image": data["image"],
                    "wished": data["wished"]
                  };
                }).toList();

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Text("${index + 1}.",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          Image.asset(song["image"],
                              width: 50, height: 50, fit: BoxFit.cover),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song["artist"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(song["title"],
                                  style: const TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ],
                          ),
                          const Spacer(),
                          if (song["wished"] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text("wished",
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 12)),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
