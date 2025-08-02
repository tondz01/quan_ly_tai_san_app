// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

Future<void> downloadForWeb(
  String url,
  String fileName,
  BuildContext context,
) async {
  try {
    // final response = await http.get(Uri.parse(url));
    // if (response.statusCode == 200) {
    //   final bytes = response.bodyBytes;

    //   // Tạo blob từ dữ liệu
    //   final blob = html.Blob([bytes]);

    //   // Tạo URL tạm thời
    //   final blobUrl = html.Url.createObjectUrlFromBlob(blob);

    //   // Tạo anchor và tải file
    //   final anchor =
    //       html.AnchorElement(href: blobUrl)
    //         ..setAttribute("download", fileName)
    //         ..click();

    //   // Giải phóng blob URL
    //   html.Url.revokeObjectUrl(blobUrl);

    //   String downloadPath = _getDownloadPath(fileName);

    //   _showNotification(
    //     context,
    //     '✅ File đã được tải xuống thành công!\nTên file: $fileName\nĐường dẫn: $downloadPath',
    //     true,
    //   );
    // } else {
    final anchor =
        html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = fileName;

    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();

    _showNotification(
      context,
      '✅ Đang tải file:  $fileName',
      true,
    );
    // }
    // Tạo anchor element để download file trực tiếp
  } catch (e) {
    _showNotification(context, '❌ Download thất bại: $e', false);
  }
}

void _showNotification(BuildContext context, String message, bool isSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
