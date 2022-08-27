import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../constants/palette.dart';
import '../../settings/services/dark_theme_provider.dart';
import '../models/document_model.dart';

class PDFViewer extends StatefulWidget {
  static const routeName = '/pdf_viewer';

  const PDFViewer({Key? key}) : super(key: key);

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late final DocumentModel _document;

  @override
  void didChangeDependencies() {
    _document = ModalRoute.of(context)!.settings.arguments as DocumentModel;
    super.didChangeDependencies();
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
                      'PDF Viewer',
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
            Expanded(
              child: SfPdfViewer.file(File(_document.path)),
            ),
          ],
        ),
      ),
    );
  }
}
