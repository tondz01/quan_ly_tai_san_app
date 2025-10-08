// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Conditional import cho web
import 'download_file_web.dart' if (dart.library.io) 'download_file_stub.dart';

Future<void> downloadFile(String url, String fileName, BuildContext context) async {
  try {
    if (kIsWeb) {
      // Web platform - sử dụng html.AnchorElement để download
      await downloadForWeb(url, fileName, context);
    } else if (Platform.isWindows) {
      // Windows platform
      await _downloadForWindows(url, fileName, context);
    } else if (Platform.isAndroid) {
      // Android platform
      await _downloadForAndroid(url, fileName, context);
    } else if (Platform.isIOS) {
      // iOS platform
      await _downloadForIOS(url, fileName, context);
    } else {
      _showNotification(context, '❌ Platform không được hỗ trợ', false);
    }
  } catch (e) {
    _showNotification(context, '❌ Download thất bại: $e', false);
  }
}

Future<void> _downloadForWindows(String url, String fileName, BuildContext context) async {
  try {
    Dio dio = Dio();
    
    // Thử lấy thư mục Downloads trước, nếu không có thì dùng Documents
    String savePath;
    try {
      // Lấy thư mục Downloads từ environment variable
      String? downloadsPath = Platform.environment['USERPROFILE'];
      if (downloadsPath != null) {
        savePath = '$downloadsPath\\Downloads\\$fileName';
      } else {
        Directory directory = await getApplicationDocumentsDirectory();
        savePath = '${directory.path}\\$fileName';
      }
    } catch (e) {
      // Fallback về Documents nếu không lấy được Downloads
      Directory directory = await getApplicationDocumentsDirectory();
      savePath = '${directory.path}\\$fileName';
    }
    
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );
    
    _showNotification(context, '✅ File đã được tải xuống thành công!\nTên file: $fileName\nĐường dẫn: $savePath', true);
  } catch (e) {
    _showNotification(context, '❌ Download thất bại: $e', false);
  }
}

Future<void> _downloadForAndroid(String url, String fileName, BuildContext context) async {
  try {
    Dio dio = Dio();
    
    Directory directory = await getExternalStorageDirectory() ?? 
                         await getApplicationDocumentsDirectory();
    String savePath = '${directory.path}/$fileName';
    
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );
    
    _showNotification(context, '✅ File đã được tải xuống thành công!\nTên file: $fileName\nĐường dẫn: $savePath', true);
  } catch (e) {
    _showNotification(context, '❌ Download thất bại: $e', false);
  }
}

Future<void> _downloadForIOS(String url, String fileName, BuildContext context) async {
  try {
    Dio dio = Dio();
    
    Directory directory = await getApplicationDocumentsDirectory();
    String savePath = '${directory.path}/$fileName';
    
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );
    
    _showNotification(context, '✅ File đã được tải xuống thành công!\nTên file: $fileName\nĐường dẫn: $savePath', true);
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
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
