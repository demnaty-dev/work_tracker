import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authentication_services.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              context.read<AuthenticationServices>().signInWithEmailAndPassword('email@email.com', 'password');
            },
          ),
        ),
      ),
    );
  }
}
