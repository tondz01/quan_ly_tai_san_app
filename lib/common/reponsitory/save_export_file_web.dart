// ignore_for_file: unused_local_variable, deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:typed_data';
import 'dart:html' as html;

Future<String> saveExportFile(Uint8List bytes, String fileName) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  
  // Tạo anchor element và click để download
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  
  // Revoke URL sau khi click
  html.Url.revokeObjectUrl(url);

  return "download_triggered";
}
