import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/pages/login_page.dart';
import 'package:radio_app/pages/playlist_page.dart';
import 'package:radio_app/pages/radio_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'song/song_page.dart';
import 'song/song_screen.dart';
import 'song/song_repository.dart';
import 'song/song_bloc.dart';
import 'song/song_event.dart';
import 'song/song_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'radio app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Radio App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;
  final SongRepository _songRepository = SongRepository();
  late final SongBloc _songBloc;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _songBloc = SongBloc(_songRepository);

    _songBloc.add(LoadAllSongsEvent());
    //_songBloc.add(LoadSingleSongEvent());
    
    _pages = <Widget>[
      // SongScreen(songBloc: _songBloc),
      LoginPage(),
      RadioPage(songBloc: _songBloc),
      //const PlaylistPage(),
      PlaylistScreen(songBloc: _songBloc),
    ];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _songBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar_outlined),
              label: 'Radio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.queue_music),
              label: 'Playlist',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}