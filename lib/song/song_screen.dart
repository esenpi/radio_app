import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/song/song_bloc.dart';
import 'package:radio_app/song/song_event.dart';
import 'package:radio_app/song/song_state.dart';
import 'package:radio_app/song/song_repository.dart';

class SongScreen extends StatefulWidget {
  final SongBloc _songBloc;
  final SongRepository _songRepository;

  const SongScreen({
    Key? key,
    required SongBloc songBloc,
    required SongRepository songRepository,
  })  : _songBloc = songBloc,
        _songRepository = songRepository,
        super(key: key);

  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  @override
  void initState() {
    super.initState();
    _loadAllSongs();
  }

  void _loadAllSongs() {
    widget._songBloc.add(LoadAllSongsEvent(widget._songRepository));
  }

  void _loadNextSong() {
    widget._songBloc.add(LoadNextSongEvent("FJRJZCVV74YjGuiG2sLL", widget._songRepository));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Details'),
      ),
      body: Center(
        child: BlocBuilder<SongBloc, SongState>(
          bloc: widget._songBloc,
          builder: (context, state) {
            print('Current state: $state'); // Log the current state

            if (state is UnSongState) {
              return CircularProgressIndicator();
            } else if (state is AllSongsLoadedState) {
              return Text('All songs loaded. Click Next to fetch song details.');
            } else if (state is SongLoadedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Title: ${state.song.title}'),
                  Text('Album: ${state.song.album}'),
                  Text('Interpreter: ${state.song.interpreter}'),
                  Text('Song URL: ${state.song.songUrl}'),
                  Text('Thumbnail URL: ${state.song.thumbnailUrl}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadNextSong,
                    child: Text('Next'),
                  ),
                ],
              );
            } else if (state is ErrorSongState) {
              return Text('Error: ${state.errorMessage}');
            } else {
              return Text('Unknown state');
            }
          },
        ),
      ),
    );
  }
}