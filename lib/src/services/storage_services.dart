import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageServices {
  final _subDirs = [
    '/Media/WorkTrack_Documents',
    '/Media/WorkTrack_Videos',
    '/Media/WorkTrack_Audios',
    '/Media/WorkTrack_Images',
  ];

  static const documents = 0;
  static const videos = 1;
  static const audios = 2;
  static const images = 3;

  String? _appDirectory;

  Future<String> get appDirectory async {
    if (_appDirectory != null) return _appDirectory!;

    final externalSD = await getApplicationDocumentsDirectory();
    _appDirectory = externalSD.path;

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

  String getPathTo(int folder, String fileName) {
    return '${_appDirectory!}${_subDirs[folder]}/$fileName';
  }

  Future<bool> fileExists(int folder, String fileName) async {
    final url = '${await appDirectory}${_subDirs[folder]}/$fileName';
    return await File(url).exists();
  }
}
