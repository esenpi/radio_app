import 'package:bloc/bloc.dart';
import 'package:radio_app/song/song_event.dart';
import 'package:radio_app/song/song_state.dart';
import 'package:radio_app/song/song_repository.dart';
import 'package:radio_app/model/song.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository songRepository;
  List<String> documentIDs = [];
  List<Song> songs = [];
  int currentIndex = -1;

  SongBloc(this.songRepository) : super(UnSongState()) {
    on<LoadAllSongsEvent>((event, emit) async {
      try {
        List<String> documentIDs = await songRepository.fetchAllDocumentIDs();
        songs = await Future.wait(documentIDs.map((docId) => songRepository.fetchSong(docId)));
        if (songs.isNotEmpty) {
          currentIndex = 0;
          print("SongsLoadedState emittiert");
          // printe mir einen Song aus der Liste
          print(songs[0].title);
          emit(SongLoadedState(songs[0]));
        } else {
          emit(UnSongState());
        } 
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });

    on<LoadNextSongEvent>((event, emit) async {
      try {
        // printe den aktuellen Index
        emit(LoadingSongState()); // Zwischenzustand
        print("Current clicked Index: $currentIndex");
        if (currentIndex < songs.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0; // Zurück zum ersten Song, wenn das Ende der Liste erreicht ist
        }
        print("songtitel des aktuellen Index: ${songs[currentIndex].title}");
        emit(SongLoadedState(songs[currentIndex]));
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });

  }
}