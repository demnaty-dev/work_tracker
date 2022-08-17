import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/inbox_services.dart';
import '../../../common_widgets/old_button.dart';

class Inbox extends StatelessWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OldButton(
        child: 'Add Data',
        onPressed: () {
          context.read<InboxServices>().fetchInboxes();
        },
      ),
    );
  }
}
