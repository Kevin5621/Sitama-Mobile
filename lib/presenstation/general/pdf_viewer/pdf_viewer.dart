import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sitama/common/widgets/custom_snackbar.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  PDFViewerPage({
    super.key,
    required this.pdfUrl,
  });

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

  static Future<void> downloadPDF(BuildContext context, String pdfUrl) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }

      final dir = await getExternalStorageDirectory();
      if (dir == null) throw Exception('Could not access storage directory');

      String fileName = extractFileName(pdfUrl);
      String filePath = '${dir.path}/$fileName';

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Mulai mengunduh file...',
          duration: const Duration(seconds: 1),
          icon: Icons.download_rounded,
        ),
      );

      await Dio().download(
        pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total * 100;
            if (progress % 20 == 0) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: 'Mengunduh: ${progress.toStringAsFixed(0)}%',
                  duration: const Duration(milliseconds: 500),
                  icon: Icons.downloading_rounded,
                  backgroundColor: AppColors.lightPrimary.withAlpha((0.9*255).round()),
                ),
              );
            }
          }
        }
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'File berhasil diunduh',
          icon: Icons.check_circle_outline_rounded,
          backgroundColor: Colors.green.shade800,
          action: SnackBarAction(
            label: 'Buka',
            textColor: Colors.white,
            onPressed: () => OpenFile.open(filePath),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Gagal mengunduh file: ${e.toString()}',
          icon: Icons.error_outline_rounded,
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(extractFileName(pdfUrl)),
        backgroundColor: AppColors.lightBackground,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.black,
            ),
            onPressed: () => PDFViewerPage.downloadPDF(context, pdfUrl),
          ),
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
            CustomSnackBar(
              message: 'Gagal memuat PDF. Silakan coba lagi 😵‍💫',
              icon: Icons.error_outline_rounded,
              backgroundColor: Colors.red.shade800,
            ),
          );
          Navigator.pop(context);
        },
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: 'PDF berhasil dimuat 🥸',
              duration: const Duration(seconds: 1),
              icon: Icons.check_circle_outline_rounded,
              backgroundColor: Colors.green.shade800,
            ),
          );
        },
      ),
    );
  }
}
