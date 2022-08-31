import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_storage/firebase_storage.dart';

import '../../../services/storage_services.dart';
import '../../Authentication/models/user_model.dart';

class ProfileService {
  final User _user;
  final StorageServices _storageService;
  final DatabaseReference _dataRef;
  final Reference _storageRef;
  UserModel? _userModel;

  ProfileService(this._user, this._storageService)
      : _storageRef = FirebaseStorage.instance.ref(),
        _dataRef = FirebaseDatabase.instance.ref();

  FutureOr<UserModel> get userModel async {
    if (_userModel != null) return _userModel!;

    if (!(await _userFromLocalStoreDevice())) {
      await _userFromFirebase();
    }
    return _userModel!;
  }

  Future<bool> _userFromLocalStoreDevice() async {
    final userModel = await _storageService.getProfile(_user.uid);
    if (userModel == null) return false;
    _userModel = userModel;
    return true;
  }

  Future<void> _storeUserOnLocalDevice() async {
    await _storageService.saveProfile(_userModel!);
  }

  Future<void> _userFromFirebase() async {
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

    await _storeUserOnLocalDevice();
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

    _userModel = UserModel(
      uid: _user.uid,
      displayName: displayName,
      email: userModel.email,
      phone: phone,
      photoUrl: imageUrl,
    );

    _storeUserOnLocalDevice();

    await _dataRef.child('users/${_user.uid}').update(userInfo);
  }

  // Does I need this one ??
  // later i will know :)
  Future<void> refreshUserFromFirebase() async {
    await _userFromFirebase();
  }

  Future<UserModel?> _getFromFirebase(String uid) async {
    final snapshot = await _dataRef.child('users/$uid').get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
      final userModel = UserModel(
        uid: uid,
        displayName: userData['Name'],
        email: userData['Email'],
        phone: userData['Phone'],
        photoUrl: userData['imageUrl'],
      );
      await _storageService.saveProfile(userModel);
      return userModel;
    }

    return null;
  }

  Future<UserModel?> getUserModel(String uid) async {
    UserModel? userModel = await _storageService.getProfile(uid);
    if (userModel == null) {
      print("88888888888888885555555555@@@@@@@@@@ It's num");
    }
    userModel ??= await _getFromFirebase(uid);

    return userModel;
  }

  Future<String?> getProfileImage(String uid) async {
    final userModel = await getUserModel(uid);

    if (userModel != null) {
      return userModel.photoUrl;
    }
    return null;
  }
}
