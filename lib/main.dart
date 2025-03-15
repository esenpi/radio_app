import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/pages/playlist_page.dart';
import 'package:radio_app/pages/radio_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'song/song_repository.dart';
import 'song/song_bloc.dart';
import 'song/song_event.dart';
import 'package:radio_app/blocs/auth/auth_bloc.dart';
import 'package:radio_app/blocs/rating/rating_bloc.dart';
import 'package:radio_app/pages/homepage.dart';
import 'package:radio_app/pages/signin_page.dart';
import 'package:radio_app/repository/auth_repository.dart';
import 'package:radio_app/repository/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RatingBloc>(
            create: (context) => RatingBloc(FirestoreService()),
          ),
          BlocProvider(
              create: (context) => AuthBloc(
                    authRepository:
                        RepositoryProvider.of<AuthRepository>(context),
                  )),
        ],
        child: MaterialApp(
          title: 'radio app',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  // If the moderator is signed in show the moderator page.
                  return MyHomePage(title: '(Moderator) Radio App');
                }
                // Otherwise, they're not signed in. Show the audience page.
                return MyHomePage(title: 'Als Zuhörer angemeldet');
              }),
        ),
      ),
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

    _pages = <Widget>[
      HomePage(),
      RadioPage(songBloc: _songBloc),
      PlaylistScreen(songBloc: _songBloc),
    ];
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
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: 'Bewertung',
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
