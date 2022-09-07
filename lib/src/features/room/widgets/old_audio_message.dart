import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/room/services/messages_services.dart';
import 'package:work_tracker/src/features/room/widgets/old_icon_button.dart';
import 'package:work_tracker/src/services/storage_services.dart';

class OldAudioMessage extends StatefulWidget {
  const OldAudioMessage({
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
  State<OldAudioMessage> createState() => _OldAudioMessageState();
}

class _OldAudioMessageState extends State<OldAudioMessage> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isUploading = true;
  bool _isAvailable = true;
  bool _isDownloading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  double _progress = 0;

  UploadTask? _uploadTask;
  DownloadTask? _downloadTask;

  @override
  void initState() {
    super.initState();
    if (widget.path.contains('com.example.work_tracker')) {
      if (widget.path.contains('/cache/')) {
        _renameFile().then((value) {
          _uploadAudio();
          setState(() {});
        });
      } else {
        _uploadAudio();
      }
    } else {
      final path = context.read<StorageServices?>()!.getPathToSync(
            StorageServices.audios,
            widget.name,
          );
      final file = File(path);
      if (file.existsSync()) {
        _player.setFilePath(path).then(
          (value) {
            setState(() {
              _isUploading = false;
            });
            if (value != null) {
              _duration = value;
            } else {
              debugPrint('Error @@@@@@@@@@@@@@@@@@@@@@@@@@');
            }
          },
        );
      } else {
        _isUploading = false;
        _isAvailable = false;
      }
    }

    _player.positionStream.listen(
      (event) {
        _position = event;
        if (_position.inMilliseconds > _duration.inMilliseconds) {
          _position = _duration;

          return;
        }
        setState(() {});
      },
    );

    _player.playerStateStream.listen(
      (event) async {
        if (event.processingState == ProcessingState.completed) {
          await _player.pause();
          await _player.seek(Duration.zero);
          setState(() => _isPlaying = false);
        }
      },
    );
  }

  @override
  void dispose() {
    if (_uploadTask != null) {
      _uploadTask!.cancel();
    }
    if (_downloadTask != null) {
      _downloadTask!.cancel();
    }
    _player.positionStream.listen(null);
    _player.playerStateStream.listen(null);
    _player.dispose();
    super.dispose();
  }

  Future<void> _renameFile() async {
    final temp = await context.read<StorageServices?>()!.getPathTo(
          StorageServices.audios,
          widget.messageId,
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

  Future<void> _uploadAudio() async {
    _uploadTask = context.read<StorageServices?>()!.uploadAudio(widget.path);

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

  Future<void> _downloadAudio() async {
    setState(() => _isDownloading = true);
    _downloadTask = context.read<StorageServices?>()!.downloadAudio(widget.path, widget.name);

    _downloadTask!.snapshotEvents.listen(
      (taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (taskSnapshot.totalBytes != -1) {
              setState(
                () {
                  _progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
                },
              );
            }

            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            _downloadTask = null;
            final path = context.read<StorageServices?>()!.getPathToSync(StorageServices.audios, widget.name);
            _player.setFilePath(path).then(
              (value) {
                if (value != null) {
                  _duration = value;
                  _isAvailable = true;
                } else {
                  _isAvailable = false;
                  debugPrint('Error @@@@@@@@@@@@@@@@@@@@@@@@@@');
                }
                setState(() {
                  _isDownloading = false;
                });
              },
            );

            break;
          case TaskState.canceled:
            _isAvailable = false;
            setState(() => _isDownloading = false);
            break;
          case TaskState.error:
            break;
        }
      },
    );
  }

  _playAudio() async {
    _player.play();
    setState(() => _isPlaying = true);
  }

  _stopAudio() async {
    _player.pause();
    setState(() => _isPlaying = false);
  }

  String _displayTime() {
    final time = (_isPlaying ? _position : _duration);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(time.inMinutes);
    final seconds = twoDigits(time.inSeconds.remainder(60));

    return '$minutes:$seconds';
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
        width: size.width * .6,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _isUploading || _isDownloading
                    ? Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            value: _isDownloading ? _progress : null,
                          ),
                        ),
                      )
                    : OldIconButton(
                        icon: !_isAvailable
                            ? Icons.download
                            : _isPlaying
                                ? Icons.pause
                                : Icons.play_arrow_rounded,
                        onPressed: !_isAvailable
                            ? _downloadAudio
                            : _isPlaying
                                ? _stopAudio
                                : _playAudio,
                        iconSize: 34,
                      ),
                Expanded(
                  child: Slider(
                    onChangeStart: (value) async {
                      await _player.pause();
                    },
                    onChangeEnd: (value) async {
                      await _player.seek(Duration(milliseconds: value.toInt()));
                      await _player.play();
                    },
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    value: _position.inMilliseconds.toDouble(),
                    onChanged: (value) async {
                      setState(() => _position = Duration(milliseconds: value.toInt()));
                    },
                    activeColor: theme.primaryColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 50),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_displayTime()),
                      Text(
                        DateFormat.Hm().format(widget.date),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (widget.me)
                  SizedBox(
                    height: 22,
                    width: 24,
                    child: Icon(
                      Icons.watch_later_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
