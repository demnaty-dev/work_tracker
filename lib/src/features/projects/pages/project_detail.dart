import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/projects/models/complaint_model.dart';
import 'package:work_tracker/src/features/projects/pages/complaint.dart';
import 'package:work_tracker/src/features/projects/services/projects_services.dart';
import 'package:work_tracker/src/features/projects/widgets/old_list_item.dart';

import '../../../constants/palette.dart';
import '../../settings/services/theme_provider.dart';
import '../models/project_model.dart';

class ProjectDetail extends StatefulWidget {
  static const routeName = "/project-detail";

  const ProjectDetail({Key? key}) : super(key: key);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  bool _isLoading = false;
  bool _isLoadingComplaints = true;
  late bool _isFavorite;
  late final ProjectModel project;
  late List<ComplaintModel>? _complaintModel;

  @override
  void didChangeDependencies() {
    project = ModalRoute.of(context)!.settings.arguments as ProjectModel;
    _isFavorite = project.isFavorite;
    context.read<ProjectsServices?>()!.fetchComplaintsByProjectFromCache(true, false, 0, project.id).then(
      (value) {
        _complaintModel = value;
        setState(() => _isLoadingComplaints = false);
      },
    );
    super.didChangeDependencies();
  }

  Widget _buildTitle(TextTheme textTheme, String id, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.headline6,
        ),
        _isLoading
            ? const SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
              )
            : IconButton(
                onPressed: () {
                  _isFavorite = !_isFavorite;
                  context.read<ProjectsServices?>()!.isFavorite(id, _isFavorite).then((value) {
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
      ],
    );
  }

  Widget _buildContent(TextTheme textTheme, String content) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(content),
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
              Text("Complaints is empty"),
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
          _complaintModel = await context.read<ProjectsServices?>()!.fetchComplaintsByProjectFromCache(false, false, 0, project.id);

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
    final isDark = context.read<ThemeProvider>().isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
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
                      'Project',
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
            const SizedBox(height: 24),
            _buildTitle(theme.textTheme, project.id, project.title),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat.yMMMMEEEEd().format(project.date)),
            ),
            const SizedBox(height: 24),
            _buildContent(theme.textTheme, project.description),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Complaint.routeName, arguments: project).then(
                  (value) async {
                    _complaintModel = await context.read<ProjectsServices?>()!.fetchComplaintsByProjectFromCache(true, false, 0, project.id);

                    setState(() {});
                  },
                );
              },
              child: const Text('Create a new complaint'),
            ),
            const SizedBox(height: 30),
            _isLoadingComplaints ? const CircularProgressIndicator() : _buildList(theme),
          ],
        ),
      ),
    );
  }
}
