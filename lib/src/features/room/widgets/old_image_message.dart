import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:work_tracker/src/features/room/services/messages_services.dart';
import 'package:work_tracker/src/services/storage_services.dart';

class OldImageMessage extends StatefulWidget {
  const OldImageMessage({
    Key? key,
    this.me = true,
    required this.id,
    required this.messageId,
    required this.name,
    required this.path,
    required this.date,
  }) : super(key: key);

  final bool me;
  final String id;
  final String name;
  final String messageId;
  final String path;
  final DateTime date;

  @override
  State<OldImageMessage> createState() => _OldImageMessageState();
}

class _OldImageMessageState extends State<OldImageMessage> {
  late ImageProvider _image;
  bool _isUploading = false;
  bool _imageIsLoading = false;
  double _progress = 0.0;
  UploadTask? _uploadTask;
  DownloadTask? _downloadTask;

  @override
  void initState() {
    super.initState();
    if (widget.path.contains('com.example.work_tracker')) {
      _image = FileImage(File(widget.path));
      if (widget.path.contains('/cache/')) {
        _renameFile();
      } else {
        _uploadImage();
      }
    } else {
      final path = context.read<StorageServices?>()!.getPathToSync(
            StorageServices.images,
            widget.name,
          );
      final file = File(path);
      if (file.existsSync()) {
        _image = FileImage(File(path));
      } else {
        _downloadImage();
      }
    }
  }

  @override
  void dispose() {
    if (_uploadTask != null) {
      _uploadTask!.cancel();
    }
    if (_downloadTask != null) {
      _downloadTask!.cancel();
    }
    super.dispose();
  }

  Future<void> _renameFile() async {
    final ext = widget.path.substring(widget.path.lastIndexOf('.') + 1);
    final temp = await context.read<StorageServices?>()!.getPathTo(
          StorageServices.images,
          '${widget.messageId}.$ext',
        );
    final sourceFile = File(widget.path);
    await sourceFile.copy(temp).then(
      (value) async {
        await context.read<MessagesServices?>()!.updatePathAndName(
              widget.id,
              widget.messageId,
              temp,
            );
        await sourceFile.delete();
      },
    );
  }

  Future<void> _uploadImage() async {
    _uploadTask = context.read<StorageServices?>()!.uploadImage(widget.path);

    _isUploading = true;
    _uploadTask!.snapshotEvents.listen(
      (taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            taskSnapshot.ref.getDownloadURL().then(
              (value) {
                context.read<MessagesServices?>()!.updatePath(
                      widget.id,
                      widget.messageId,
                      value,
                    );
              },
            );
            _uploadTask = null;
            setState(() => _isUploading = false);

            break;
          case TaskState.canceled:
            setState(() => _isUploading = false);
            break;
          case TaskState.error:
            break;
        }
      },
    );
  }

  Future<void> _downloadImage() async {
    _imageIsLoading = true;
    _downloadTask = context.read<StorageServices?>()!.downloadImage(widget.path, widget.name);

    _downloadTask!.snapshotEvents.listen(
      (taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (taskSnapshot.totalBytes != -1) {
              setState(
                () {
                  _progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
                  debugPrint(_progress.toString());
                },
              );
            }

            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            _downloadTask = null;
            final path = context.read<StorageServices?>()!.getPathToSync(StorageServices.images, widget.name);
            _image = FileImage(File(path));
            setState(() => _imageIsLoading = false);

            break;
          case TaskState.canceled:
            setState(() => _imageIsLoading = false);
            break;
          case TaskState.error:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      alignment: widget.me ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(4),
        constraints: BoxConstraints(maxWidth: size.width * .7),
        decoration: BoxDecoration(
          color: widget.me ? theme.colorScheme.secondary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color.fromARGB(10, 0, 0, 0),
              spreadRadius: .5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _imageIsLoading
                  ? Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: _progress,
                      ),
                    )
                  : Image(
                      image: _image,
                    ),
              Positioned(
                bottom: -40,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(46, 0, 0, 0),
                        Colors.transparent,
                      ],
                      center: Alignment.bottomRight,
                      radius: 1,
                    ),
                  ),
                  width: 80,
                  height: 80,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 6,
                child: Row(
                  children: [
                    Text(
                      DateFormat.Hm().format(widget.date),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
              if (_isUploading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
