import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:work_tracker/src/features/room/pages/room.dart';

import '../../profile/services/profile_service.dart';
import '../models/complaint_model.dart';

class OldListItem extends StatefulWidget {
  final ComplaintModel complaint;

  const OldListItem({Key? key, required this.complaint}) : super(key: key);

  @override
  State<OldListItem> createState() => _OldListItemState();
}

class _OldListItemState extends State<OldListItem> {
  late final String _complaint;
  late final ImageProvider imageProfile;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _complaint = widget.complaint.complaint.length > 20 ? '${widget.complaint.complaint.substring(0, 20)}...' : widget.complaint.complaint;

    context.read<ProfileService?>()!.getProfileImage(widget.complaint.createdBy).then(
      (image) {
        if (image == null || image.startsWith('assets')) {
          imageProfile = const AssetImage('assets/images/user.png');
        } else if (image.contains('/Databases')) {
          imageProfile = FileImage(File(image));
        } else {
          imageProfile = NetworkImage(image);
        }
        setState(() => _isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: _isLoading
          ? const CircularProgressIndicator()
          : CircleAvatar(
              backgroundImage: imageProfile,
            ),
      onTap: () => Navigator.pushNamed(
        context,
        Room.routeName,
        arguments: widget.complaint,
      ),
      title: Text(widget.complaint.title),
      subtitle: Text(_complaint),
      trailing: Text(
        DateFormat.yMMMd().format(widget.complaint.date),
        style: theme.textTheme.subtitle2,
      ),
    );
  }
}
