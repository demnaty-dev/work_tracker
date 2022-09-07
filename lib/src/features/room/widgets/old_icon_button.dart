import 'package:flutter/material.dart';

class OldIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color iconColor;
  final double? iconSize;

  const OldIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.color = Colors.transparent,
    this.iconColor = Colors.grey,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Material(
        color: color,
        child: IconButton(
          splashRadius: 30,
          onPressed: onPressed,
          iconSize: iconSize,
          icon: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
