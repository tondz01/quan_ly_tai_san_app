import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(String url, String fileName) async {
  try {
    // Khởi tạo Dio
    Dio dio = Dio();

    // Lấy thư mục lưu file
    Directory directory;
    if (Platform.isAndroid) {
      directory =
          await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw Exception('Unsupported platform');
    }

    // Đường dẫn lưu file
    String savePath = '${directory.path}/$fileName';

    // Thực hiện download
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );

    print('✅ File downloaded successfully to: $savePath');
  } catch (e) {
    print('❌ Download failed: $e');
  }
}
