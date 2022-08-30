import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/Authentication/models/user_model.dart';
import 'package:work_tracker/src/features/profile/services/profile_service.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late final UserModel _userModel;
  late final ImageProvider _imageProfile;

  bool _isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    Future.value(context.read<ProfileService?>()!.userModel).then((value) {
      _userModel = value;

      if (value.photoUrl.startsWith('assets')) {
        _imageProfile = const AssetImage('assets/images/user.png');
      } else if (value.photoUrl.contains('/Databases')) {
        _imageProfile = FileImage(File(value.photoUrl));
      } else {
        _imageProfile = NetworkImage(value.photoUrl);
      }

      setState(() => _isLoadingUserData = false);
    });
  }

  Widget _buildNotification(ThemeData theme, int num) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            debugPrint('Open notifications page');
          },
          icon: Icon(
            Icons.notifications,
            color: theme.primaryColor,
          ),
        ),
        if (num > 0)
          Positioned(
            top: 12,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.red.shade400,
              radius: 7,
              child: Text(
                '$num',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isLoadingUserData
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: _imageProfile,
                      backgroundColor: Colors.transparent,
                      radius: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _userModel.displayName,
                      style: theme.textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
          _buildNotification(theme, 0),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.transparent,
        child: Image.asset('assets/images/user.png'),
      ),
    );
  }

  Widget _buildCrewAvatars(ThemeData theme) {
    return SizedBox(
      width: 80,
      child: Stack(
        children: [
          _buildAvatar(),
          Positioned(
            left: 20,
            child: _buildAvatar(),
          ),
          Positioned(
            left: 40,
            child: _buildAvatar(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSlide(ThemeData theme) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Progress'),
              Text('3/6'),
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
                width: 3 / 6 * 100,
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

  Widget _buildProjectsList(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      //padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
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
                        const Image(
                          image: AssetImage('assets/images/google.png'),
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            splashRadius: 26,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              //setState(() => _isFavorite = true);
                            },
                            icon: Icon(
                              Icons.star_border,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create system solar',
                      style: theme.textTheme.headline3,
                    ),
                    Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCrewAvatars(theme),
                          _buildProgressSlide(theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 20);
        },
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
      ),
    );
  }

  Widget _buildProjects(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Projects',
                style: theme.textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Show All',
                  style: theme.textTheme.subtitle2!.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildProjectsList(theme),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInProgress(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'In Progress',
                  style: theme.textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: theme.primaryColor,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          _buildList(theme),
        ],
      ),
    );
  }

  Widget _buildList(ThemeData theme) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          debugPrint('Refresh List');
        },
        child: ListView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildHeader(theme),
        _buildProjects(theme),
        Expanded(
          child: _buildInProgress(theme),
        ),
      ],
    );
  }
}
