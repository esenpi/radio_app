import 'package:flutter/material.dart';
import 'package:radio_app/song/index.dart';
import 'package:radio_app/song/song_repository.dart';

class SongPage extends StatefulWidget {
  static const String routeName = '/song';

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final _songBloc = SongBloc(SongRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song'),
      ),
      body: SongScreen(songBloc: _songBloc, songRepository: SongRepository()),
    );
  }
}
