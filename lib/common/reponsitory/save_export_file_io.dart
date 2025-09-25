import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveExportFile(Uint8List bytes, String fileName) async {
  final dir = await getDownloadsDirectory();
  if (dir == null) {
    // Fallback: nếu không lấy được thư mục Downloads
    final tempDir = await getTemporaryDirectory();
    final fallbackPath = _buildUniqueFilePath(tempDir.path, fileName);
    final fallbackFile = File(fallbackPath);
    await fallbackFile.writeAsBytes(bytes);
    return fallbackPath;
  }

  final uniquePath = _buildUniqueFilePath(dir.path, fileName);
  final file = File(uniquePath);
  await file.writeAsBytes(bytes);

  return uniquePath;
}

String _buildUniqueFilePath(String directoryPath, String fileName) {
  // Tách tên và phần mở rộng
  final dotIndex = fileName.lastIndexOf('.');
  String name;
  String extension;
  if (dotIndex != -1 && dotIndex != 0 && dotIndex != fileName.length - 1) {
    name = fileName.substring(0, dotIndex);
    extension = fileName.substring(dotIndex); // bao gồm dấu chấm
  } else {
    name = fileName;
    extension = '';
  }

  String candidatePath = _joinPath(directoryPath, '$name$extension');
  int counter = 1;

  // Nếu đã tồn tại, thêm (n) cho đến khi duy nhất
  while (File(candidatePath).existsSync()) {
    candidatePath = _joinPath(directoryPath, '$name ($counter)$extension');
    counter++;
  }

  return candidatePath;
}

String _joinPath(String directoryPath, String fileName) {
  if (directoryPath.endsWith(Platform.pathSeparator)) {
    return '$directoryPath$fileName';
  }
  return '$directoryPath${Platform.pathSeparator}$fileName';
}
