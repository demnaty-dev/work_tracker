import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/old_button.dart';
import '../../../common_widgets/old_text_field.dart';
import '../services/authentication_services.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgot_password';
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';

  Future<void> _trySubmit(VoidCallback onSuccess) async {
    if (_formKey.currentState == null) return;

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);
      try {
        await context.read<AuthenticationServices>().resetPassword(_userEmail);
        onSuccess();
      } on FirebaseAuthException catch (err) {
        debugPrint(err.code);
        debugPrint(err.message);
        String message = '';
        if (err.code == 'user-not-found') {
          message = 'There is no user with this email';
        } else if (err.code == 'network-request-failed') {
          message = 'Check your connection';
        }

        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 249,
                child: Text(
                  'Enter your email account to reset your password',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(height: 40),
              OldTextField(
                placeholder: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final emailForm = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (value != null && (value.isEmpty || !emailForm.hasMatch(value))) {
                    return 'Please provide a valid email !';
                  }
                  return null;
                },
                onSaved: (value) => _userEmail = value!,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const SizedBox(
                      height: 48,
                      child: Center(
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : OldButton(
                      child: 'Reset Password',
                      onPressed: () => _trySubmit(() => Navigator.pop(context)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
