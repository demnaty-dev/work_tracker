import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:work_tracker/src/features/inbox/models/inbox_model.dart';

class InboxServices {
  final CollectionReference _inboxes;
  final FirebaseStorage _storage;
  // ignore: unused_field
  final User _user;

  InboxServices(this._user)
      : _inboxes = FirebaseFirestore.instance.collection('users/${_user.uid}/inboxes'),
        _storage = FirebaseStorage.instance {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<List<InboxModel>?> fetchInboxesFromCache(bool cache) async {
    try {
      final snapshot = await _inboxes.orderBy("date", descending: true).get(
            GetOptions(
              source: cache ? Source.cache : Source.serverAndCache,
            ),
          );
      List<InboxModel> list = [];
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          list.add(InboxModel.fromJson(id: doc.id, json: data));
        }
      }
      return list;
    } catch (err) {
      debugPrint('${err.runtimeType}____________-----------');
    }
    return null;
  }

  Future<void> isSeen(String id) async {
    try {
      await _inboxes.doc(id).update({'isSeen': true});
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<bool> isFavorite(String id, bool state) async {
    try {
      await _inboxes.doc(id).update({'isFavorite': state});
      return true;
    } catch (err) {
      debugPrint(err.toString());
    }
    return false;
  }

  Future<void> addInbox() async {
    try {
      _inboxes.add(
        {
          'date': FieldValue.serverTimestamp(),
          'subject': 'Solar system',
          'content': 'We need to fix some errors',
          'isSeen': false,
        },
      );
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<DownloadTask> downloadFile(String url, String filePath) async {
    final gsReference = _storage.refFromURL(url);
    final file = File(filePath);

    return gsReference.writeToFile(file);
  }
}
