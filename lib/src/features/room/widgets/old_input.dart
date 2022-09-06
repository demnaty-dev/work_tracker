import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/room/services/messages_services.dart';

import '../../settings/services/theme_provider.dart';
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
  bool _isTyping = false;

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

  Future<void> _recordVoice() async {}

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
                    child: TextField(
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
          icon: _isTyping ? Icons.send_rounded : Icons.mic,
          onPressed: _isTyping ? _sendMessage : _recordVoice,
          color: theme.primaryColor,
          iconColor: Colors.white,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
