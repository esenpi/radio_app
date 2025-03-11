
import 'package:email_validator/email_validator.dart';
import 'package:radio_app/main.dart';
import 'package:radio_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'signup_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
        title: const Text("SignIn"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            print("Der User ist authentifiziert");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MyApp()));
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            print("Der User ist nicht authentifiziert");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } if (state is UnAuthenticated) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("User nicht authentifiziert")));
            print("Der User ist nicht authentifiziert");
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              // Showing the sign in form if the user is not authenticated
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 38,
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
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                    onPressed: () {
                                    _emailController.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                  ),),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null &&
                                            !EmailValidator.validate(value)
                                        ? 'Enter a valid email'
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    hintText: "Password",
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
                                        ? "Enter min. 6 characters"
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                    },
                                    child: const Text('Sign In'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        
                      const SizedBox(height: 10,),
                       /* InkWell(
                           onTap: () {
                            _authenticateWithGoogle(context);
                          },
                          child: Card(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Image.asset(
                                "assets/google.png",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 10,),
                             const Text("Continue with Google")
                            ]),
                          ),),
                        ), */
                      const SizedBox(height: 10,),
                        const Text("Don't have an account?"),
                        
                      const SizedBox(height: 10,),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            );
                          },
                          child: const Text("Sign Up"),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}