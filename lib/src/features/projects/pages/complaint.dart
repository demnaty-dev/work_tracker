import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/common_widgets/old_text_field.dart';
import 'package:work_tracker/src/features/projects/models/project_model.dart';
import 'package:work_tracker/src/features/projects/services/projects_services.dart';

class Complaint extends StatefulWidget {
  static const routeName = "/complaint";

  const Complaint({Key? key}) : super(key: key);

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late ProjectModel _projectModel;

  String? _title;
  String? _complaint;

  @override
  void didChangeDependencies() {
    _projectModel = ModalRoute.of(context)!.settings.arguments as ProjectModel;

    super.didChangeDependencies();
  }

  Future<void> _tryCreateComplaint() async {
    if (_formKey.currentState == null) return;

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);
      await context
          .read<ProjectsServices?>()!
          .createComplaint(
            _projectModel.id,
            _title!,
            _complaint!,
            _projectModel.crew,
          )
          .then((value) => setState(() => _isLoading = false))
          .then((value) => Navigator.pop(context));
    }
  }

  Widget _buildHeader(ThemeData theme) {
    return SizedBox(
      height: 63,
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  'cancel',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: _isLoading ? Colors.grey.shade300 : Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              child: Text(
                'Create Complaint',
                textAlign: TextAlign.center,
                style: theme.textTheme.headline6,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Container(
                    alignment: Alignment.centerRight,
                    child: const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  )
                : InkWell(
                    onTap: _tryCreateComplaint,
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'create',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    OldTextField(
                      placeholder: 'Title',
                      onSaved: (value) {
                        _title = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    OldTextField(
                      placeholder: 'Complaint',
                      onSaved: (value) {
                        _complaint = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please entre your complaint';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
