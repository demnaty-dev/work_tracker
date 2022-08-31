import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/profile/services/profile_service.dart';

import 'package:work_tracker/src/features/projects/models/project_model.dart';
import 'package:work_tracker/src/features/projects/services/projects_services.dart';

class OldCardWidget extends StatefulWidget {
  final ProjectModel project;

  const OldCardWidget({Key? key, required this.project}) : super(key: key);

  @override
  State<OldCardWidget> createState() => _OldCardWidgetState();
}

class _OldCardWidgetState extends State<OldCardWidget> {
  late bool _isFavorite;
  bool _isLoading = false;
  bool _isLoadingAvatars = true;

  late Widget _avatars;

  @override
  void initState() {
    super.initState();
    _buildCrewAvatars().then(
      (value) {
        _avatars = value;
        setState(() => _isLoadingAvatars = false);
      },
    );
  }

  @override
  void didChangeDependencies() {
    _isFavorite = widget.project.isFavorite;
    super.didChangeDependencies();
  }

  Widget _buildAvatar(String? image) {
    ImageProvider imageProfile;
    if (image == null || image.startsWith('assets')) {
      imageProfile = const AssetImage('assets/images/user.png');
    } else if (image.contains('/Databases')) {
      imageProfile = FileImage(File(image));
    } else {
      imageProfile = NetworkImage(image);
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 14,
        backgroundImage: imageProfile,
      ),
    );
  }

  Future<Widget> _buildCrewAvatars() async {
    final listAvatars = <Widget>[];

    for (int i = 0; i < widget.project.crew.length; i++) {
      final image = await context.read<ProfileService?>()!.getProfileImage(widget.project.crew[i]);
      if (i == 0) {
        listAvatars.add(_buildAvatar(image));
      } else {
        listAvatars.add(
          Positioned(
            left: (20 * i).toDouble(),
            child: _buildAvatar(image),
          ),
        );
      }
    }

    return SizedBox(
      width: 80,
      child: Stack(
        children: listAvatars,
      ),
    );
  }

  Widget _buildProgressSlide(ThemeData theme, int total, int done) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progress'),
              Text('$done/$total'),
            ],
          ),
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              Container(
                height: 6,
                width: done / total * 100,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ImageProvider projectImage;
    if (widget.project.image.startsWith('assets')) {
      projectImage = const AssetImage('assets/images/google.png');
    } else if (widget.project.image.contains('/Databases')) {
      projectImage = FileImage(File(widget.project.image));
    } else {
      projectImage = NetworkImage(widget.project.image);
    }

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      onTap: () {},
      child: SizedBox(
        width: 260,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                      image: projectImage,
                      height: 40,
                      width: 40,
                    ),
                    _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              splashRadius: 26,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _isFavorite = !_isFavorite;
                                context.read<ProjectsServices?>()!.isFavorite(widget.project.id, _isFavorite).then((value) {
                                  if (!value) {
                                    _isFavorite = !_isFavorite;
                                  }
                                  setState(() => _isLoading = false);
                                  return;
                                });
                                setState(() => _isLoading = true);
                              },
                              icon: Icon(
                                _isFavorite ? Icons.star : Icons.star_border,
                                color: _isFavorite ? Colors.amber.shade400 : Colors.grey.shade400,
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.project.title,
                  style: theme.textTheme.headline3,
                ),
                Text(DateFormat.yMMMMEEEEd().format(widget.project.date)),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isLoadingAvatars
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(),
                            )
                          : _avatars,
                      _buildProgressSlide(
                        theme,
                        widget.project.totalTasks,
                        widget.project.doneTasks,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
