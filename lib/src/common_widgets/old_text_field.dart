import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/settings/services/dark_theme_provider.dart';

import '../constants/theme.dart';
import '../constants/palette.dart';

class OldTextField extends StatelessWidget {
  final String placeholder;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?) onSaved;

  const OldTextField({
    Key? key,
    required this.placeholder,
    required this.obscureText,
    this.keyboardType,
    this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: secondaryColorLightTheme,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        hintText: placeholder,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: regular,
          fontFamily: 'Poppins',
          color: textField,
        ),
      ),
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      style: TextStyle(
        fontSize: 16,
        fontWeight: medium,
        fontFamily: 'Poppins',
        color: context.read<DarkThemeProvider>().darkTheme ? textColorDarkTheme : textColorLightTheme,
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
