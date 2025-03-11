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
        emit(LoadingSongState());
        songs = await songRepository.fetchAllDocumentIDs();
        // print document IDs
        print(documentIDs);
        // songs = await Future.wait(documentIDs.map((docId) => songRepository.fetchSong(docId)));
        // print songs
        print("folgendes songs ${songs}");
        if (songs.isNotEmpty) {
          currentIndex = 0;
          print("SongsLoadedState emittiert");
          // printe mir einen Song aus der Liste
          print(songs[0].title);
          emit(SongsLoadedState(songs));
        } else {
          emit(UnSongState());
        } 
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });

    on<LoadSingleSongEvent>((event, emit) async {
      try {
        emit(LoadingSongState());
        songs = await songRepository.fetchAllDocumentIDs();
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

    on<LoadPreviousSongEvent>((event, emit) async {
      try {
        emit(LoadingSongState());
        if (currentIndex > 0) {
          currentIndex--;
        } else {
          currentIndex = songs.length - 1; // Zum letzten Song, wenn der Anfang der Liste erreicht ist
        }
        emit(SongLoadedState(songs[currentIndex]));
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });

    on<InsertSongEvent>((event, emit) async {
      try {
        emit(LoadingSongState());
        await songRepository.insertSong(event.song);
        // refreshs the list of songs with the new inserted one
        List<Song> songs = await songRepository.fetchAllDocumentIDs();
        emit(SongsLoadedState(songs));
      } catch (error) {
        emit(ErrorSongState(error.toString()));
      }
    });

  }
}