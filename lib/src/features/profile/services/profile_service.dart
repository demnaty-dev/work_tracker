import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../Authentication/models/user_model.dart';

class ProfileService {
  final DatabaseReference _dataRef;
  final Reference _storageRef;
  UserModel? _userModel;

  ProfileService()
      : _storageRef = FirebaseStorage.instance.ref(),
        _dataRef = FirebaseDatabase.instance.ref();

  UserModel? get userModel => _userModel;

  Future<UserModel?> userFromFirebase(User? user) async {
    _userModel = null;
    if (user == null) return _userModel;

    final snapshot = await _dataRef.child('users/${user.uid}').get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
      _userModel = UserModel(
        uid: user.uid,
        displayName: userData['Name'],
        email: userData['Email'],
        phone: userData['Phone'],
        photoUrl: userData['imageUrl'],
      );
    }

    return _userModel;
  }

  Future<void> updateUser(
    UserModel user,
    File? image,
    String displayName,
    String phone,
  ) async {
    String imageUrl = user.photoUrl;
    if (image != null) {
      final exts = image.path.substring(image.path.lastIndexOf('.'));
      final ref = _storageRef.child('profiles_image').child('${user.uid}$exts');
      await ref.putFile(image);
      imageUrl = await ref.getDownloadURL();
    }

    final userInfo = {
      'Name': displayName,
      'Phone': phone,
      'imageUrl': imageUrl,
    };

    await _dataRef.child('users/${user.uid}').update(userInfo);
  }
}
