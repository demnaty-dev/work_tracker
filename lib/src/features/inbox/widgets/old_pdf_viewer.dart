import 'package:flutter/material.dart';

class OldPdfViewer extends StatefulWidget {
  final String urlOffline;
  final String urlOnline;
  final Map<String, dynamic> metadata;

  const OldPdfViewer({
    Key? key,
    required this.urlOffline,
    required this.urlOnline,
    required this.metadata,
  }) : super(key: key);

  @override
  State<OldPdfViewer> createState() => _OldPdfViewerState();
}

class _OldPdfViewerState extends State<OldPdfViewer> {
  late final bool _isAvailable;

  @override
  void initState() {
    if (widget.urlOffline.compareTo('none') == 0) {
      _isAvailable = false;
    }
    super.initState();
  }

  void _openPDF() {}

  void _downloadPDF() {}

  @override
  Widget build(BuildContext context) {
    const round = 2.0;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(round),
      ),
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(round)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(round),
                  bottomRight: Radius.circular(round),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(53, 0, 0, 0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Text',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Icon(Icons.download),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isAvailable ? _openPDF : _downloadPDF,
                borderRadius: BorderRadius.circular(round),
              ),
            )
          ],
        ),
      ),
    );
  }
}
