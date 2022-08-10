import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forgot_password.dart';
import '../services/authentication_services.dart';

import '../../../common_widgets/old_text_button.dart';
import '../../../common_widgets/old_button.dart';
import '../../../common_widgets/old_text_field.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String _userEmail = '';
  String _password = '';

  Future<void> _trySubmit() async {
    if (_formKey.currentState == null) return;

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);
      try {
        await context.read<AuthenticationServices>().signInWithEmailAndPassword(_userEmail, _password);
      } on FirebaseAuthException catch (err) {
        debugPrint(err.code);
        debugPrint(err.message);
        String message = '';
        if (err.code == 'wrong-password') {
          message = 'The password is wrong';
        } else if (err.code == 'user-not-found') {
          message = 'There is no user with this email';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 249,
                        child: Text(
                          'Please Inter your email address and password for Login',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(height: 40),
                      OldTextField(
                        placeholder: 'Enter your email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final emailForm = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (value != null && (value.isEmpty || !emailForm.hasMatch(value))) {
                            return 'Please provide a valid email !';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      OldTextField(
                        placeholder: 'Enter your password',
                        obscureText: true,
                        validator: (value) {
                          if (value != null && (value.isEmpty)) {
                            return 'Please entre the password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OldTextButton(
                          'Forgot Password?',
                          onPressed: () {
                            Navigator.pushNamed(context, ForgotPassword.routeName);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : OldButton(
                              child: 'Sign In',
                              onPressed: _trySubmit,
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
