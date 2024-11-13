import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl; // For URL-based PDF

  const PDFViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Bimbingan'),
        backgroundColor: AppColors.lightBackground,
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}