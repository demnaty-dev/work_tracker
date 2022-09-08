import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OldWaitingMessage extends StatefulWidget {
  const OldWaitingMessage({
    Key? key,
    this.me = true,
    required this.date,
  }) : super(key: key);

  final bool me;
  final DateTime date;

  @override
  State<OldWaitingMessage> createState() => _OldWaitingMessageState();
}

class _OldWaitingMessageState extends State<OldWaitingMessage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      alignment: widget.me ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: widget.me ? theme.colorScheme.secondary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color.fromARGB(10, 0, 0, 0),
              spreadRadius: .5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .6,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Waiting for message',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 21,
              child: Text(
                DateFormat.Hm().format(widget.date),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            if (widget.me)
              SizedBox(
                height: 22,
                width: 24,
                child: Icon(
                  Icons.watch_later_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
