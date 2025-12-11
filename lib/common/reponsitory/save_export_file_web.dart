// ignore_for_file: unused_local_variable, deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:typed_data';
import 'dart:html' as html;

Future<String> saveExportFile(Uint8List bytes, String fileName, {bool print = false}) async {
  // Xác định MIME type dựa trên extension
  String mimeType = 'application/octet-stream';
  if (fileName.endsWith('.xlsx')) {
    mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  } else if (fileName.endsWith('.xls')) {
    mimeType = 'application/vnd.ms-excel';
  } else if (fileName.endsWith('.pdf')) {
    mimeType = 'application/pdf';
  }

  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Luôn download file (browser không thể hiển thị Excel trực tiếp)
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();

  // Revoke URL sau khi click (delay để đảm bảo download hoàn tất)
  Future.delayed(const Duration(seconds: 1), () {
    html.Url.revokeObjectUrl(url);
  });

  return "download_triggered";
}
