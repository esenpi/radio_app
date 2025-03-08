import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/song/song_bloc.dart';
import 'package:radio_app/song/song_event.dart';
import 'package:radio_app/song/song_state.dart';

class RadioPage extends StatefulWidget {
  final SongBloc _songBloc;

  const RadioPage({
    Key? key,
    required SongBloc songBloc,
  })  : _songBloc = songBloc,
        super(key: key);


  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
  }

  void _playPause(String url) {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(url); // Replace with your stream URL
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _stop() {
    _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      _position = Duration.zero;
    });
  }

  void _forward() {
    widget._songBloc.add(LoadNextSongEvent());
  }

  void _backward() {
    // Implement backward functionality if applicable
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: BlocBuilder<SongBloc, SongState>(
          bloc: widget._songBloc,
          builder: (context, state) {
            if (state is SongLoadedState) {
            return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${state.song.thumbnailUrl}",
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "${state.song.title } · ${state.song.interpreter } · ${ state.song.album }", 
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 16),
            Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_position.toString().split('.').first),
                Text(_duration.toString().split('.').first),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.fast_rewind),
                  onPressed: _backward,
                  iconSize: 48.0,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () => _playPause(state.song.songUrl),
                  iconSize: 64.0,
                ),
                IconButton(
                  icon: Icon(Icons.fast_forward),
                  onPressed: _forward,
                  iconSize: 48.0,
                ),
              ],
            ),
          ],
        ),
      );} else 
    {
      return Text("No song loaded");
    }
          },
        ),
    );
  }
}


