import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../settings/services/theme_provider.dart';
import '../services/messages_services.dart';
import 'old_icon_button.dart';

class OldInput extends StatefulWidget {
  const OldInput({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<OldInput> createState() => _OldInputState();
}

class _OldInputState extends State<OldInput> {
  final _messageController = TextEditingController();
  final _recorder = FlutterSoundRecorder();
  bool _isTyping = false;
  bool _isRecording = false;
  bool _isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await _recorder.openRecorder();
    _isRecorderReady = true;

    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _pickPictureFromCam() async {
    final ImagePicker picker = ImagePicker();
    await picker
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    )
        .then(
      (value) {
        if (value == null) return;
        context.read<MessagesServices?>()!.sendImageMessage(widget.id, value.path);
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    await picker
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    )
        .then(
      (value) {
        if (value == null) return;
        context.read<MessagesServices?>()!.sendImageMessage(widget.id, value.path);
      },
    );
  }

  Future<void> _sendMessage() async {
    context.read<MessagesServices?>()!.sendTextMessage(
          widget.id,
          _messageController.text,
        );

    FocusScope.of(context).unfocus();
    _messageController.clear();
    setState(() => _isTyping = false);
  }

  Future<void> _recordVoice() async {
    if (!_isRecorderReady) return;
    await _recorder.startRecorder(toFile: widget.id);

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder().then(
      (value) {
        if (value == null) return;
        context.read<MessagesServices?>()!.sendAudioMessage(widget.id, value);
      },
    );
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeProvider>().isDarkMode(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Color.fromARGB(15, 0, 0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: _isRecording
                        ? StreamBuilder<RecordingDisposition>(
                            stream: _recorder.onProgress,
                            builder: (context, snapshot) {
                              final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                              String twoDigits(int n) => n.toString().padLeft(2, '0');
                              final twoDigitMinutes = twoDigits(duration.inMinutes);
                              final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

                              return TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: '$twoDigitMinutes:$twoDigitSeconds',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              );
                            },
                          )
                        : TextField(
                            controller: _messageController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() => _isTyping = false);
                              } else {
                                setState(() => _isTyping = true);
                              }
                            },
                          ),
                  ),
                  if (!_isTyping)
                    OldIconButton(
                      icon: Icons.camera,
                      onPressed: _pickPictureFromCam,
                    ),
                  if (!_isTyping) const SizedBox(width: 4),
                  if (!_isTyping)
                    OldIconButton(
                      icon: Icons.image,
                      onPressed: _pickImageFromGallery,
                    ),
                  if (_isTyping) const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        OldIconButton(
          icon: _isTyping
              ? Icons.send_rounded
              : _isRecording
                  ? Icons.stop
                  : Icons.mic,
          onPressed: _isTyping
              ? _sendMessage
              : _isRecording
                  ? _stopRecording
                  : _recordVoice,
          color: theme.primaryColor,
          iconColor: Colors.white,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
