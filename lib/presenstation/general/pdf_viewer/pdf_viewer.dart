import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  PDFViewerPage({
    Key? key,
    required this.pdfUrl,
  }) : super(key: key);

  // Ubah menjadi static dan public
  static String extractFileName(String url) {
    try {
      String decodedUrl = Uri.decodeFull(url);
      String fileName = decodedUrl.split('/').last;
      if (fileName.contains('?')) {
        fileName = fileName.split('?').first;
      }
      if (fileName.contains('%') || fileName.length > 50) {
        return "File Bimbingan";
      }
      return fileName;
    } catch (e) {
      return "File Bimbingan";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(extractFileName(pdfUrl)),
        backgroundColor: AppColors.lightBackground,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.zoom_in,
              color: Colors.black,
            ),
            onPressed: () {
              _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel + 1.0);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.zoom_out,
              color: Colors.black,
            ),
            onPressed: () {
              _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel - 1.0);
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        controller: _pdfViewerController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal memuat PDF. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        },
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF berhasil dimuat'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}