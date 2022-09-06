import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesServices {
  final CollectionReference _firestore;
  final User _user;

  MessagesServices(this._user) : _firestore = FirebaseFirestore.instance.collection('complaints');

  String get uid => _user.uid;

  Stream<QuerySnapshot> getMessagesStream(String id) {
    return _firestore.doc(id).collection('messages').orderBy('sentAt').snapshots();
  }

  Future<void> sendTextMessage(String id, String content) async {
    await _firestore.doc(id).collection('messages').add({
      "content": content,
      "contentType": 0,
      "sentAt": Timestamp.fromDate(DateTime.now()),
      "sentBy": uid,
    });
  }

  Future<void> sendImageMessage(String id, String path) async {
    await _firestore.doc(id).collection('messages').add({
      "content": path,
      "contentType": 1,
      "sentAt": Timestamp.fromDate(DateTime.now()),
      "sentBy": uid,
      "name": "nan",
    });
  }

  Future<void> updatePathAndName(String id, String messageId, String path) async {
    await _firestore.doc(id).collection('messages').doc(messageId).update(
      {
        "content": path,
        "name": path.substring(path.lastIndexOf('/') + 1),
      },
    );
  }

  Future<void> updatePath(String id, String messageId, String path) async {
    await _firestore.doc(id).collection('messages').doc(messageId).update(
      {
        "content": path,
      },
    );
  }
}
