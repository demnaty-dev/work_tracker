import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/palette.dart';
import '../../settings/services/theme_provider.dart';
import '../models/project_model.dart';
import '../services/projects_services.dart';
import '../widgets/old_card_widget.dart';

class ProjectsList extends StatefulWidget {
  static const routeName = '/projects-list';

  const ProjectsList({Key? key}) : super(key: key);

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  List<ProjectModel>? _projects;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<ProjectsServices?>()!.fetchProjectsFromCache(true, false, 0).then(
      (value) {
        _projects = value;
        setState(() => _isLoading = false);
      },
    );
  }

  void _onValue(Object? object) {
    context.read<ProjectsServices?>()!.fetchProjectsFromCache(true, false, 0).then((value) {
      _projects = value;
      setState(() => _isLoading = false);
      return;
    });
    setState(() => _isLoading = true);
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
    return ListView.separated(
      itemBuilder: (context, index) {
        return SizedBox(
          height: 160,
          child: OldCardWidget(
            project: _projects!.elementAt(index),
            onValue: _onValue,
            enableFavorite: false,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 4);
      },
      itemCount: _projects!.length,
      scrollDirection: Axis.vertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeProvider>().isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.chevron_left,
                          color: isDark ? textColorDarkTheme : textColorLightTheme,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Projects',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline6,
                    ),
                  ),
                  const Expanded(
                    child: Text(''),
                  ),
                ],
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _projects = await context.read<ProjectsServices?>()!.fetchProjectsFromCache(false, false, 0);
                        setState(() {});
                      },
                      child: _projects == null
                          ? _buildErrorMsg()
                          : _projects!.isEmpty
                              ? _buildEmptyMsg()
                              : _buildListView(theme),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
