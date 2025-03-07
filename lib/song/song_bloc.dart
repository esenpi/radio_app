import 'package:bloc/bloc.dart';
import 'package:radio_app/song/song_event.dart';
import 'package:radio_app/song/song_state.dart';
import 'package:radio_app/song/song_repository.dart';
import 'package:radio_app/model/song.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository songRepository;
  List<String> documentIDs = [];
  int currentIndex = -1;

  SongBloc(this.songRepository) : super(UnSongState()) {
    on<LoadAllSongsEvent>((event, emit) async {
      try {
        documentIDs = await songRepository.fetchAllDocumentIDs();
        if (documentIDs.isNotEmpty) {
          currentIndex = 0;
          Song song = await songRepository.fetchSong(documentIDs[currentIndex]);
          emit(SongLoadedState(song));
        } else {
          emit(UnSongState());
        }
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });

    on<LoadNextSongEvent>((event, emit) async {
      try {
        if (currentIndex < documentIDs.length - 1) {
          currentIndex++;
          Song song = await songRepository.fetchSong(documentIDs[currentIndex]);
          emit(SongLoadedState(song));
        }
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });
  }
}