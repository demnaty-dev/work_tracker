import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/projects/models/complaint_model.dart';
import 'package:work_tracker/src/features/room/services/messages_services.dart';
import 'package:work_tracker/src/features/room/widgets/old_image_message.dart';
import 'package:work_tracker/src/features/room/widgets/old_input.dart';
import 'package:work_tracker/src/features/room/widgets/old_text_message.dart';

import '../../../constants/palette.dart';
import '../../settings/services/theme_provider.dart';

class Room extends StatefulWidget {
  static const routeName = "/room";

  const Room({Key? key}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  late ComplaintModel _complaint;
  late String _uid;

  @override
  void didChangeDependencies() {
    _complaint = ModalRoute.of(context)!.settings.arguments as ComplaintModel;
    _uid = context.read<MessagesServices?>()!.uid;
    super.didChangeDependencies();
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Material(
      elevation: 1,
      color: Colors.white,
      shadowColor: const Color.fromARGB(80, 0, 0, 0),
      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.chevron_left,
                    color: isDark ? textColorDarkTheme : textColorLightTheme,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                _complaint.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headline6,
              ),
            ),
            const Expanded(
              child: Text(''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(ThemeData theme, bool isDark) {
    return Expanded(
      child: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final json = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final type = json['contentType'] as int;

              if (type == 0) {
                return OldTextMessage(
                  me: _uid == json['sentBy'],
                  date: (json['sentAt']! as Timestamp).toDate(),
                  content: json['content'],
                );
              } else if (type == 1) {
                return OldImageMessage(
                  me: _uid == json['sentBy'],
                  id: _complaint.id,
                  name: json['name'],
                  messageId: snapshot.data!.docs[index].id,
                  date: (json['sentAt']! as Timestamp).toDate(),
                  path: json['content'],
                );
              } else {
                return OldTextMessage(
                  me: _uid == json['sentBy'],
                  date: (json['sentAt']! as Timestamp).toDate(),
                  content: json['content'],
                );
              }
            },
            physics: const ScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            primary: true,
          );
        },
        stream: context.read<MessagesServices?>()!.getMessagesStream(_complaint.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeProvider>().isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme, isDark),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildMessages(theme, isDark),
                  OldInput(id: _complaint.id),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
