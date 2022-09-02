import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/projects/models/complaint_model.dart';
import 'package:work_tracker/src/features/projects/widgets/old_list_item.dart';

import '../../Authentication/models/user_model.dart';
import '../../profile/services/profile_service.dart';
import '../models/project_model.dart';
import '../pages/projects_list.dart';
import '../services/projects_services.dart';
import '../widgets/old_card_widget.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late final UserModel _userModel;
  late List<ProjectModel> _projectsModel;
  late List<ComplaintModel>? _complaintModel;
  late final ImageProvider _imageProfile;

  bool _isLoadingUserData = true;
  bool _isLoadingProjects = true;
  bool _isLoadingComplaints = true;

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

    context.read<ProjectsServices?>()!.fetchProjectsFromCache(true, true, 2).then((value) {
      _projectsModel = value ?? [];
      setState(() => _isLoadingProjects = false);
    });

    context.read<ProjectsServices?>()!.fetchComplaintsHasUserFromCache(true, true, 5).then((value) {
      _complaintModel = value;
      setState(() => _isLoadingComplaints = false);
    });
  }

  void _onValue(Object? object) {
    context.read<ProjectsServices?>()!.fetchProjectsFromCache(true, true, 2).then((value) {
      _projectsModel = value ?? [];
      setState(() => _isLoadingProjects = false);
      return;
    });
    setState(() => _isLoadingProjects = true);
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

  Widget _buildProjectsList(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      //padding: const EdgeInsets.symmetric(vertical: 8),
      child: _isLoadingProjects
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                return OldCardWidget(
                  project: _projectsModel.elementAt(index),
                  onValue: _onValue,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 20);
              },
              itemCount: _projectsModel.length,
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
                onPressed: () {
                  Navigator.pushNamed(context, ProjectsList.routeName);
                },
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

  Widget _buildComplaints(ThemeData theme) {
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
                  'Recent Complaints',
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
          _isLoadingComplaints ? const CircularProgressIndicator() : _buildList(theme),
        ],
      ),
    );
  }

  Widget _buildErrorMsg() {
    return Stack(
      children: [
        ListView(),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.error,
                color: Color(0xFF848A94),
              ),
              SizedBox(width: 4),
              Text("Something went wrong"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMsg() {
    return Stack(
      children: [
        ListView(),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.inbox,
                color: Color(0xFF848A94),
              ),
              SizedBox(width: 4),
              Text("Inbox is empty"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView(ThemeData theme) {
    return ListView.builder(
      itemCount: _complaintModel!.length,
      itemBuilder: (context, index) {
        return OldListItem(complaint: _complaintModel!.elementAt(index));
      },
    );
  }

  Widget _buildList(ThemeData theme) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          _complaintModel = await context.read<ProjectsServices?>()!.fetchComplaintsHasUserFromCache(true, true, 5);
          setState(() {});
        },
        child: _complaintModel == null
            ? _buildErrorMsg()
            : _complaintModel!.isEmpty
                ? _buildEmptyMsg()
                : _buildListView(theme),
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
          child: _buildComplaints(theme),
        ),
      ],
    );
  }
}
