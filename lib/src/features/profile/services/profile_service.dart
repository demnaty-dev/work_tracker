import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_storage/firebase_storage.dart';

import '../../Authentication/models/user_model.dart';

class ProfileService {
  final DatabaseReference _dataRef;
  final Reference _storageRef;
  final User _user;
  UserModel? _userModel;

  ProfileService(this._user)
      : _storageRef = FirebaseStorage.instance.ref(),
        _dataRef = FirebaseDatabase.instance.ref();

  UserModel? get userModel => _userModel;

  Future<UserModel?> userFromFirebase() async {
    final snapshot = await _dataRef.child('users/${_user.uid}').get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
      _userModel = UserModel(
        uid: _user.uid,
        displayName: userData['Name'],
        email: userData['Email'],
        phone: userData['Phone'],
        photoUrl: userData['imageUrl'],
      );
    }

    return _userModel;
  }

  Future<void> updateUser(
    UserModel userModel,
    File? image,
    String displayName,
    String phone,
  ) async {
    String imageUrl = userModel.photoUrl;
    if (image != null) {
      final exts = image.path.substring(image.path.lastIndexOf('.'));
      final ref = _storageRef.child('profiles_image').child('${_user.uid}$exts');
      await ref.putFile(image);
      imageUrl = await ref.getDownloadURL();
    }

    final userInfo = {
      'Name': displayName,
      'Phone': phone,
      'imageUrl': imageUrl,
    };

    await _dataRef.child('users/${_user.uid}').update(userInfo);
  }
}
