import 'package:flutter/material.dart';

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
    // a login page with input fields for username and password and a login button 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderator Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              // an x button on the right side within the input field in order to clear the input field
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
              const SizedBox(height: 10),
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
              ),
              ElevatedButton(
                onPressed: () {
                  // login logic
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


