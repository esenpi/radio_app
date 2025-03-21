import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radio_app/main.dart';
import 'package:radio_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'signin_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp"),
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("User Data email");
              print(snapshot.data!.email);
            }
            return BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  // Navigating to the dashboard screen if the user is authenticated
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                }
                if (state is AuthError) {
                  // Displaying the error message if the user is not authenticated
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                if (state is Loading) {
                  // Displaying the loading indicator while the user is signing up
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UnAuthenticated) {
                  // Displaying the sign up form if the user is not authenticated
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Moderator Registrierung",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Center(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        border: OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _emailController.clear();
                                          },
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return value != null &&
                                                !EmailValidator.validate(value)
                                            ? 'Gültige E-Mail eingeben'
                                            : null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        hintText: "Passwort",
                                        border: OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _passwordController.clear();
                                          },
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return value != null && value.length < 6
                                            ? "Min. 6 Zeichen"
                                            : null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _createAccountWithEmailAndPassword(
                                              context);
                                        },
                                        child: const Text('Registrieren'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Text("Du hast bereits einen Account?"),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()),
                                );
                              },
                              child: const Text("Login"),
                            ),
                            const Text("Oder"),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                              },
                              child: const Text("Als Zuhörer"),
                            ),
                            /* 
                            InkWell(
                              onTap: () {
                                _authenticateWithGoogle(context);
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/google.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text("Continue with Google")
                                      ]),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            );
          }),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          _emailController.text,
          _passwordController.text,
        ),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}
