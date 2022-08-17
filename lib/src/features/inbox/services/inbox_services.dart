import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

class InboxServices {
  final CollectionReference _inboxes;
  final User _user;

  InboxServices(this._user) : _inboxes = FirebaseFirestore.instance.collection('inboxes');

  void fetchInboxes() async {
    _inboxes.add({
      'uid': _user.uid,
      'date': DateTime.now().toIso8601String(),
      'subject': 'subject',
      'content': 'content',
      'isSeen': false,
    });
  }
}
