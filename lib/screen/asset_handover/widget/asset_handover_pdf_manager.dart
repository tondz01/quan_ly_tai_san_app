import 'package:flutter/foundation.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetHandoverPdfManager {
  final void Function(PdfDocument?) onDocumentChanged;
  PdfDocument? _document;

  PdfDocument? get document => _document;

  AssetHandoverPdfManager({required this.onDocumentChanged});

  Future<void> loadPdf(String path) async {
    try {
      final document = await PdfDocument.openFile(path);
      _document = document;
      onDocumentChanged(_document);
    } catch (e) {
      SGLog.error("Error loading PDF from file", e.toString());
      _document = null;
      onDocumentChanged(_document);
    }
  }

  Future<void> loadPdfFromBytes(Uint8List bytes) async {
    try {
      final document = await PdfDocument.openData(bytes);
      _document = document;
      onDocumentChanged(_document);
    } catch (e) {
      SGLog.error("Error loading PDF from bytes", e.toString());
      _document = null;
      onDocumentChanged(_document);
    }
  }

  Future<void> loadPdfNetwork(String nameFile) async {
    SGLog.info("LoadPdfNetwork", "Loading PDF from network: $nameFile");
    try {
      final document = await PdfDocument.openUri(
        Uri.parse("${Config.baseUrl}/api/upload/preview/$nameFile"),
      );
      _document = document;
      onDocumentChanged(_document);
    } catch (e) {
      SGLog.error("Error loading PDF from network", e.toString());
      _document = null;
      onDocumentChanged(_document);
    }
  }
}

