import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';
import 'package:work_tracker/src/features/projects/models/complaint_model.dart';

import '../models/project_model.dart';

class ProjectsServices {
  final CollectionReference _complaint;
  final CollectionReference _projects;
  final CollectionReference _userProject;
  // ignore: unused_field
  final User _user;

  ProjectsServices(this._user)
      : _complaint = FirebaseFirestore.instance.collection('complaints'),
        _projects = FirebaseFirestore.instance.collection('projects'),
        _userProject = FirebaseFirestore.instance.collection('users/${_user.uid}/projects') {
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
      return list;
    } on FirebaseException catch (err) {
      debugPrint('Firebase Exception $err @@@@@@@@@@@');
    } catch (err) {
      debugPrint('Unknown Exception 1 $err @@@@@@@@@@@');
    }
    return null;
  }

  Future<List<ComplaintModel>?> fetchComplaintsByProjectFromCache(
    bool cache,
    bool isLimit,
    int limit,
    String id,
  ) async {
    try {
      final getOption = GetOptions(
        source: cache ? Source.cache : Source.serverAndCache,
      );

      Query<Object?> query;

      if (isLimit) {
        query = _complaint
            .where("projectId", isEqualTo: id)
            .orderBy(
              "date",
              descending: true,
            )
            .limit(limit);
      } else {
        query = _complaint
            .where(
              "projectId",
              isEqualTo: id,
            )
            .orderBy(
              "date",
              descending: true,
            );
      }
      final snapshot = await query.get(getOption);

      List<ComplaintModel> list = [];
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          list.add(ComplaintModel.fromJson(id: doc.id, json: data));
        }
      }
      return list;
    } on FirebaseException catch (err) {
      debugPrint('Firebase Exception $err @@@@@@@@@@@');
    } catch (err) {
      debugPrint('Unknown Exception 2 $err @@@@@@@@@@@');
    }
    return null;
  }

  Future<List<ComplaintModel>?> fetchComplaintsHasUserFromCache(
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
        query = _complaint
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
        query = _complaint
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

      List<ComplaintModel> list = [];
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          list.add(ComplaintModel.fromJson(id: doc.id, json: data));
        }
      }

      return list;
    } on FirebaseException catch (err) {
      debugPrint('Firebase Exception $err @@@@@@@@@@@');
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

  Future<void> createComplaint(
    String id,
    String title,
    String complaint,
    List<String> crow,
  ) async {
    await _complaint.add(
      {
        'title': title,
        'date': FieldValue.serverTimestamp(),
        'createdBy': _user.uid,
        'complaint': complaint,
        'projectId': id,
        'crew': crow,
      },
    );
  }
}
