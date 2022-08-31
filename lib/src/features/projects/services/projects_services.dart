import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:work_tracker/src/features/projects/models/project_model.dart';

class ProjectsServices {
  final CollectionReference _projects;
  final CollectionReference _userProject;
  final FirebaseStorage _storage;
  // ignore: unused_field
  final User _user;

  ProjectsServices(this._user)
      : _projects = FirebaseFirestore.instance.collection('projects'),
        _userProject = FirebaseFirestore.instance.collection('users/${_user.uid}/projects'),
        _storage = FirebaseStorage.instance {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<List<ProjectModel>?> fetchProjectsFromCache(
    bool cache,
    bool isLimit,
    int limit,
  ) async {
    try {
      final getOption = GetOptions(
        source: cache ? Source.cache : Source.serverAndCache,
      );

      Query<Object?> query;

      if (isLimit) {
        query = _projects
            .where(
              "crew",
              arrayContains: _user.uid,
            )
            .orderBy(
              "date",
              descending: true,
            )
            .limit(limit);
      } else {
        query = _projects
            .where(
              "crew",
              arrayContains: _user.uid,
            )
            .orderBy(
              "date",
              descending: true,
            );
      }
      final snapshot = await query.get(getOption);

      List<ProjectModel> list = [];
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          bool isFavorite = false;

          final subSnapshot = await _userProject.doc(doc.id).get(getOption);
          if (subSnapshot.exists) {
            final subData = subSnapshot.data() as Map<String, dynamic>;
            isFavorite = subData['isFavorite'];
          }

          list.add(ProjectModel.fromJson(id: doc.id, json: data, isFavorite: isFavorite));
        }
      }

      debugPrint('List length ${list.length}');
      return list;
    } on FirebaseException catch (err) {
      debugPrint('Firebase Exception $err @@@@@@@@@@@');
    } catch (err) {
      debugPrint('Unknown Exception $err @@@@@@@@@@@');
    }
    return null;
  }

  Future<bool> isFavorite(String id, bool state) async {
    try {
      await _userProject.doc(id).update({'isFavorite': state});
      return true;
    } catch (err) {
      debugPrint(err.toString());
    }
    return false;
  }

  // Future<void> addInbox() async {
  //   try {
  //     _inboxes.add(
  //       {
  //         'date': FieldValue.serverTimestamp(),
  //         'subject': 'Solar system',
  //         'content': 'We need to fix some errors',
  //         'isSeen': false,
  //       },
  //     );
  //   } catch (err) {
  //     debugPrint(err.toString());
  //   }
  // }

  // Future<DownloadTask> downloadFile(String url, String filePath) async {
  //   final gsReference = _storage.refFromURL(url);
  //   final file = File(filePath);

  //   return gsReference.writeToFile(file);
  // }
}
