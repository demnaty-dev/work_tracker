import 'package:flutter/material.dart';
import 'package:work_tracker/src/constants/theme.dart';

class OldButton extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;

  const OldButton({Key? key, required this.child, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(child,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: medium,
            fontFamily: 'Poppins',
          )),
    );
  }
}
