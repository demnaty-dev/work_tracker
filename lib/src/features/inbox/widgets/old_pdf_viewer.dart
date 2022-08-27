import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_tracker/src/features/inbox/services/inbox_services.dart';
import 'package:work_tracker/src/services/storage_services.dart';

class OldPdfViewer extends StatefulWidget {
  final String url;
  final String id;
  final String fileName;

  const OldPdfViewer({
    Key? key,
    required this.url,
    required this.id,
    required this.fileName,
  }) : super(key: key);

  @override
  State<OldPdfViewer> createState() => _OldPdfViewerState();
}

class _OldPdfViewerState extends State<OldPdfViewer> {
  late String _fileName;
  late String _customName;

  bool _checkingFileExists = true;
  bool _isAvailable = false;
  bool _isLoading = false;

  late DownloadTask _downloadTask;
  bool _isDownloading = false;
  double _progress = 0.0;

  @override
  void initState() {
    _fileName = widget.id + widget.fileName;

    _customName = widget.fileName;
    if (_customName.length > 20) {
      _customName = '${_customName.substring(0, 13)}...${_customName.substring(_customName.length - 7)}';
    }

    context.read<StorageServices?>()!.fileExists(StorageServices.documents, _fileName).then((value) {
      _isAvailable = value;
      setState(() => _checkingFileExists = false);
      return;
    });

    super.initState();
  }

  void _openPDF() {
    final path = context.read<StorageServices?>()!.getPathTo(StorageServices.documents, _fileName);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       final title = widget.fileName.substring(0, widget.fileName.lastIndexOf('.'));
    //       return PDFViewerPage(title: title, file: File(path));
    //     },
    //   ),
    // );
  }

  Future<void> _downloadPDF(Future<DownloadTask> Function() getDownloadTask) async {
    await context.read<StorageServices?>()!.initDirectories();
    setState(() => _isLoading = true);
    _downloadTask = await getDownloadTask();
    _isDownloading = true;
    _downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          if (taskSnapshot.totalBytes != -1) {
            if (_isLoading) {
              _isLoading = false;
            }
            setState(() => _progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          }

          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          _isLoading = false;
          _isDownloading = false;
          setState(() => _isAvailable = true);
          break;
        case TaskState.canceled:
          setState(() => _isDownloading = false);
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
  }

  Widget _buildIsNotAvailable() {
    if (!_isLoading && !_isDownloading) {
      return IconButton(
        onPressed: () {
          _downloadPDF(
            () {
              final path = context.read<StorageServices?>()!.getPathTo(
                    StorageServices.documents,
                    _fileName,
                  );

              return context.read<InboxServices?>()!.downloadFile(widget.url, path);
            },
          );
        },
        icon: const Icon(Icons.download),
      );
    }
    if (_isLoading) {
      return const SizedBox(
        height: 48,
        width: 48,
        child: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
            ),
          ),
        ),
      );
    }
    if (_isDownloading) {
      return SizedBox(
        height: 48,
        width: 48,
        child: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              value: _progress,
            ),
          ),
        ),
      );
    }
    return const Text('Unhandled');
  }

  Widget _buildIsAvailable() {
    return IconButton(
      onPressed: _openPDF,
      icon: const Icon(Icons.open_in_new),
    );
  }

  Widget _buildCheckingFileExists() {
    return const SizedBox(
      height: 48,
      width: 48,
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    const round = 16.0;
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(round)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 8),
                Text(_customName),
              ],
            ),
            _checkingFileExists
                ? _buildCheckingFileExists()
                : _isAvailable
                    ? _buildIsAvailable()
                    : _buildIsNotAvailable(),
          ],
        ),
      ),
    );
  }
}
