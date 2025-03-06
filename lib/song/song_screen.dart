import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/song/song_bloc.dart';
import 'package:radio_app/song/song_event.dart';
import 'package:radio_app/song/song_state.dart';
import 'package:radio_app/song/song_repository.dart';

class SongScreen extends StatefulWidget {
  final SongBloc _songBloc;
  final String docId;
  final SongRepository _songRepository;

  const SongScreen({
    Key? key,
    required SongBloc songBloc,
    required this.docId,
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
    _load();
  }

  void _load() {
    widget._songBloc.add(LoadSongEvent(widget.docId, widget._songRepository));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Details'),
      ),
      body: BlocBuilder<SongBloc, SongState>(
        bloc: widget._songBloc,
        builder: (context, state) {
          if (state is UnSongState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is InSongState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(state.title),
                  Text(state.interpreter),
                  Text(state.album),
                  Text(state.songUrl),
                  // Image.network(state.thumbnailUrl),
                ],
              ),
            );
          } else if (state is ErrorSongState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(state.errorMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: ElevatedButton(
                      child: Text('Reload'),
                      onPressed: _load,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}