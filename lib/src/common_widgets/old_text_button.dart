import 'package:flutter/material.dart';
import 'package:work_tracker/src/constants/palette.dart';
import 'package:work_tracker/src/constants/theme.dart';

class OldTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const OldTextButton(this.text, {Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: textColorLightTheme,
          fontWeight: medium,
          fontSize: 14,
        ),
      ),
    );
  }
}
