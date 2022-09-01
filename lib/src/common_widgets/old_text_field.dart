import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_tracker/src/features/settings/services/theme_provider.dart';

import '../constants/theme.dart';
import '../constants/palette.dart';

class OldTextField extends StatelessWidget {
  final String placeholder;
  final String? text;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?) onSaved;

  const OldTextField({
    Key? key,
    required this.placeholder,
    this.text,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDarkMode(context);
    return TextFormField(
      initialValue: text,
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
        color: isDark ? textColorDarkTheme : textColorLightTheme,
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
