import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/constants/palette.dart';
import 'package:work_tracker/src/features/inbox/models/inbox_model.dart';
import 'package:work_tracker/src/features/inbox/services/inbox_services.dart';
import 'package:work_tracker/src/features/inbox/widgets/old_pdf_viewer.dart';
import 'package:work_tracker/src/features/settings/services/dark_theme_provider.dart';

class InboxDetail extends StatefulWidget {
  static const routeName = '/inbox_detail';

  const InboxDetail({Key? key}) : super(key: key);

  @override
  State<InboxDetail> createState() => _InboxDetailState();
}

class _InboxDetailState extends State<InboxDetail> {
  bool _isLoading = false;
  late bool _isFavorite;
  late final InboxModel im;

  @override
  void didChangeDependencies() {
    im = ModalRoute.of(context)!.settings.arguments as InboxModel;
    _isFavorite = im.isFavorite;
    if (!im.isSeen) {
      context.read<InboxServices?>()!.isSeen(im.id);
    }
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
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              )
            : IconButton(
                onPressed: () {
                  _isFavorite = !_isFavorite;
                  context.read<InboxServices?>()!.isFavorite(id, _isFavorite).then((value) {
                    if (!value) {
                      _isFavorite = !_isFavorite;
                    }
                    setState(() => _isLoading = false);
                    return;
                  });
                  setState(() => _isLoading = true);
                },
                icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
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

  Widget _buildFileViewer(List<String> urlsOffline, List<String> urlsOnline) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return OldPdfViewer(
            urlOffline: urlsOffline.elementAt(index),
            urlOnline: urlsOnline.elementAt(index),
            metadata: {
              'id': im.id,
              'index': index,
            },
          );
        },
        itemCount: urlsOffline.length,
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
                          color: context.read<DarkThemeProvider>().darkTheme ? textColorDarkTheme : textColorLightTheme,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Inbox',
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
            _buildTitle(theme.textTheme, im.id, im.subject),
            const SizedBox(height: 16),
            _buildContent(theme.textTheme, im.content),
            const SizedBox(height: 24),
            if (im.urlsOnline != null) _buildFileViewer(im.urlsOffline!, im.urlsOnline!),
          ],
        ),
      ),
    );
  }
}
