import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radio_app/auth/auth_bloc.dart';
import 'package:radio_app/blocs/todo/todo_bloc.dart';
import 'package:radio_app/pages/homepage.dart';
import 'package:radio_app/repository/auth_repo.dart';
import 'package:radio_app/repository/firestore_repo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TodoBloc>(
            create: (context) => TodoBloc(FirestoreService()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomePage();
              }
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Moderator Login'),
                ),
                body: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _usernameController.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _passwordController.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                // Implement login logic here
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}