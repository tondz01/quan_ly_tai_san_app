import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
// ignore: avoid_web_libraries_in_flutter
// import 'package:intl/intl.dart';

/// Service để export báo cáo sang Excel bằng cách chụp screenshot UI
///
/// Ưu điểm:
/// - Không cần viết code riêng cho từng báo cáo
/// - Excel output giống 100% với UI
/// - Dễ implement và maintain
///
/// Nhược điểm:
/// - Excel output là hình ảnh, không edit được
/// - File size lớn hơn (~2-5MB)
///
/// Sử dụng:
/// ```dart
/// await ScreenshotToExcelService.exportReportToExcel(
///   repaintKey: _repaintKey,
///   reportTitle: 'Bien_Ban_Kiem_Ke',
/// );
/// ```
class ScreenshotToExcelService {
  /// Export report screenshot to Excel
  ///
  /// [repaintKey] - GlobalKey của RepaintBoundary wrapping report content
  /// [reportTitle] - Tên báo cáo (dùng làm tên file)
  /// [pixelRatio] - Độ phân giải screenshot (default: 2.0 = retina)
  static Future<void> exportReportToExcel({
    required GlobalKey repaintKey,
    required String reportTitle,
    double pixelRatio = 2.0,
  }) async {
    try {
      // 1. Capture screenshot from RepaintBoundary
      final RenderRepaintBoundary? boundary =
          repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Không tìm thấy RepaintBoundary. Vui lòng đảm bảo content được wrap trong RepaintBoundary với key.');
      }

      // Capture image với pixel ratio cao để chữ rõ nét
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Không thể capture screenshot từ UI.');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 2. Create Excel workbook
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // Set sheet name
      sheet.name = reportTitle.replaceAll('_', ' ');

      // 3. Add image to Excel
      final Picture picture = sheet.pictures.addStream(1, 1, pngBytes);

      // Calculate dimensions to fit A4 paper (approximate)
      // A4 in Excel: ~210mm width x 297mm height
      // Excel column width unit is approximately 7 pixels per unit
      // Excel row height unit is approximately 0.75 pixels per unit

      // Get image dimensions
      final imageWidth = image.width;
      final imageHeight = image.height;

      // Target dimensions (fit to Excel page width ~800 pixels)
      const targetWidth = 800;
      final scale = targetWidth / imageWidth;
      final targetHeight = (imageHeight * scale).toInt();

      picture.width = targetWidth;
      picture.height = targetHeight;

      // Auto-fit columns and rows to accommodate image
      sheet.getRangeByIndex(1, 1, (targetHeight / 15).ceil(), 12).cellStyle.wrapText = true;

      // Set page orientation to Portrait for better viewing
      sheet.pageSetup.orientation = ExcelPageOrientation.portrait;

      // 4. Save and download
      // final List<int> bytes = workbook.saveAsStream();
      // workbook.dispose();

      // // Generate filename with timestamp
      // final now = DateTime.now();
      // final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
      // final filename = '${reportTitle}_${formatter.format(now)}.xlsx';

      // Download file (web only)
      // final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.AnchorElement(href: url)
      //   ..setAttribute('download', filename)
      //   ..click();
      // html.Url.revokeObjectUrl(url);
    } catch (e) {
      rethrow;
    }
  }

  /// Export multiple pages to single Excel file
  ///
  /// Useful for reports with multiple pages
  static Future<void> exportMultiPageReportToExcel({
    required List<GlobalKey> repaintKeys,
    required String reportTitle,
    double pixelRatio = 2.0,
  }) async {
    try {
      final Workbook workbook = Workbook();

      for (int i = 0; i < repaintKeys.length; i++) {
        final key = repaintKeys[i];
        final RenderRepaintBoundary? boundary =
            key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

        if (boundary == null) continue;

        final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) continue;

        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Create new sheet for each page
        final Worksheet sheet;
        if (i == 0) {
          sheet = workbook.worksheets[0];
        } else {
          sheet = workbook.worksheets.add();
        }

        sheet.name = 'Page ${i + 1}';

        // Add image
        final Picture picture = sheet.pictures.addStream(1, 1, pngBytes);

        const targetWidth = 800;
        final scale = targetWidth / image.width;
        final targetHeight = (image.height * scale).toInt();

        picture.width = targetWidth;
        picture.height = targetHeight;

        sheet.pageSetup.orientation = ExcelPageOrientation.portrait;
      }

      // // Save and download
      // final List<int> bytes = workbook.saveAsStream();
      // workbook.dispose();

      // final now = DateTime.now();
      // final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
      // final filename = '${reportTitle}_${formatter.format(now)}.xlsx';

      // final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.AnchorElement(href: url)
      //   ..setAttribute('download', filename)
      //   ..click();
      // html.Url.revokeObjectUrl(url);
    } catch (e) {
      rethrow;
    }
  }
}
