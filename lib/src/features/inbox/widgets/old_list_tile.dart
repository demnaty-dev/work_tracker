import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OldListTile extends StatelessWidget {
  final VoidCallback onTap;
  final TextTheme textTheme;
  final Color color;
  final int charAvatar;
  final String title;
  final String subtitle;
  final bool isSeen;
  final DateTime date;

  const OldListTile({
    Key? key,
    required this.onTap,
    required this.textTheme,
    required this.color,
    required this.charAvatar,
    required this.title,
    required this.subtitle,
    required this.isSeen,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(
          String.fromCharCode(charAvatar),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      title: Text(
        title,
        style: textTheme.subtitle1!.copyWith(
          fontWeight: isSeen ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text('$subtitle...'),
      trailing: Text(
        DateFormat.yMMMd().format(date),
        style: textTheme.subtitle2,
      ),
    );
  }
}
