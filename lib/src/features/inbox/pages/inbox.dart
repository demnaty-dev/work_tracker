import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inbox_model.dart';
import '../services/inbox_services.dart';
import '../widgets/old_list_tile.dart';
import 'inbox_detail.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  List<InboxModel>? _inboxes;
  final List<Color> _colors = [
    Colors.red.shade400,
    Colors.blue.shade400,
    Colors.orange.shade400,
    Colors.green.shade400,
    Colors.yellow.shade400,
    Colors.indigo.shade400,
    Colors.lightBlue.shade400,
    Colors.purple.shade400,
    Colors.deepOrange.shade400,
    Colors.teal.shade400,
  ];
  final _random = Random();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<InboxServices?>()!.fetchInboxesFromCache(true).then((value) {
      _inboxes = value;
      setState(() => _isLoading = false);
      return;
    });
  }

  Widget _buildErrorMsg() {
    return Stack(
      children: [
        ListView(),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.error,
                color: Color(0xFF848A94),
              ),
              SizedBox(width: 4),
              Text("Something went wrong"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMsg() {
    return Stack(
      children: [
        ListView(),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.inbox,
                color: Color(0xFF848A94),
              ),
              SizedBox(width: 4),
              Text("Inbox is empty"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView(ThemeData theme) {
    return ListView.builder(
      itemCount: _inboxes!.length,
      itemBuilder: (context, index) {
        final im = _inboxes!.elementAt(index);
        return OldListTile(
          onTap: () {
            Navigator.pushNamed(context, InboxDetail.routeName, arguments: im).then(
              (value) {
                context.read<InboxServices?>()!.fetchInboxesFromCache(true).then((value) {
                  _inboxes = value;
                  setState(() => _isLoading = false);
                  return;
                });
                setState(() => _isLoading = true);
              },
            );
          },
          textTheme: theme.textTheme,
          color: _colors[_random.nextInt(_colors.length)],
          charAvatar: im.subject.codeUnitAt(0),
          title: im.subject,
          subtitle: im.content.length > 13 ? im.content.substring(0, 13) : im.content,
          isSeen: im.isSeen,
          date: im.date,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Inboxes',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline6,
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _inboxes = await context.read<InboxServices?>()!.fetchInboxesFromCache(false);
                      setState(() {});
                    },
                    child: _inboxes == null
                        ? _buildErrorMsg()
                        : _inboxes!.isEmpty
                            ? _buildEmptyMsg()
                            : _buildListView(theme),
                  ),
                ),
        ],
      ),
    );
  }
}
