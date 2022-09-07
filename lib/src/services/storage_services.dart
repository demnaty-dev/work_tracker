import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../features/Authentication/models/user_model.dart';

class StorageServices {
  final _subDirs = [
    '/Media/WorkTrack_Documents',
    '/Media/WorkTrack_Videos',
    '/Media/WorkTrack_Audios',
    '/Media/WorkTrack_Images',
    '/Databases/Profiles/Images',
    '/Databases/Profiles/Data',
  ];

  static const documents = 0;
  static const videos = 1;
  static const audios = 2;
  static const images = 3;
  static const profilesImages = 4;
  static const profilesData = 5;

  final FirebaseStorage _storage;

  StorageServices() : _storage = FirebaseStorage.instance;

  String? _appDirectory;

  Future<String> get appDirectory async {
    if (_appDirectory != null) return _appDirectory!;

    final externalSD = await getExternalStorageDirectory();
    _appDirectory = externalSD!.path;

    return _appDirectory!;
  }

  Future<void> initDirectories() async {
    await requestPermission(Permission.storage);
    // ! Throw error if user not accepted

    var path = Directory(await appDirectory);
    if (!(await path.exists())) {
      path.create(recursive: true);
    }

    for (String subDir in _subDirs) {
      path = Directory(_appDirectory! + subDir);
      if (!(await path.exists())) {
        path.create(recursive: true);
      }
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  String getPathToSync(int folder, String fileName) {
    return '${_appDirectory!}${_subDirs[folder]}/$fileName';
  }

  Future<String> getPathTo(int folder, String fileName) async {
    return '${_appDirectory!}${_subDirs[folder]}/$fileName';
  }

  Future<bool> fileExists(int folder, String fileName) async {
    await appDirectory;
    final url = '${await appDirectory}${_subDirs[folder]}/$fileName';
    return await File(url).exists();
  }

  Future<void> saveProfile(UserModel user) async {
    await initDirectories();

    final jsonPath = getPathToSync(profilesData, '${user.uid}.json');
    final json = File(jsonPath);

    String imagePath = user.photoUrl;
    if (!user.photoUrl.contains('assets')) {
      imagePath = getPathToSync(profilesImages, '${user.uid}.png');
      final image = File(imagePath);

      final gsReference = _storage.refFromURL(user.photoUrl);
      final downloadTask = gsReference.writeToFile(image);

      await downloadTask.whenComplete(() => null);

      if (!json.existsSync()) {
        json.createSync(recursive: true);
      }
    }

    json.writeAsStringSync(user.toJson(imagePath));
  }

  Future<UserModel?> getProfile(String uid) async {
    await initDirectories();
    final jsonPath = getPathToSync(profilesData, '$uid.json');
    final jsonFile = File(jsonPath);

    if (!jsonFile.existsSync()) return null;

    final jsonData = jsonFile.readAsStringSync();
    final user = UserModel.fromJson(uid: uid, json: json.decode(jsonData));
    return user;
  }

  Future<void> deleteFiles() async {
    // ! Throw error if user not accepted

    var path = Directory(await appDirectory);
    if (await path.exists()) {
      path.delete(recursive: true);
    }
  }

  UploadTask uploadImage(String path) {
    final file = File(path);

    return _storage.ref('media/image/').child(path.substring(path.lastIndexOf('/') + 1)).putFile(file);
  }

  UploadTask uploadAudio(String path) {
    final file = File(path);

    return _storage.ref('media/audio/').child(path.substring(path.lastIndexOf('/') + 1)).putFile(file);
  }

  DownloadTask downloadImage(String path, String name) {
    final imagePath = getPathToSync(images, name);
    final image = File(imagePath);

    final gsReference = _storage.refFromURL(path);
    return gsReference.writeToFile(image);
  }

  DownloadTask downloadAudio(String path, String name) {
    final audioPath = getPathToSync(audios, name);
    final audio = File(audioPath);

    final gsReference = _storage.refFromURL(path);
    return gsReference.writeToFile(audio);
  }
}
