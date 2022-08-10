import 'package:flutter/material.dart';

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
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
