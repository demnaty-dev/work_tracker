import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/Authentication/services/authentication_services.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            child: const Text('LogOut'),
            onPressed: () {
              context.read<AuthenticationServices>().signOut();
            },
          ),
        ),
      ),
    );
  }
}
