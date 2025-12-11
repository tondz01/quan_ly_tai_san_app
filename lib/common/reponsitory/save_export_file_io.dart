import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveExportFile(Uint8List bytes, String fileName, {bool print = false}) async {
  final dir = await getDownloadsDirectory();
  String filePath;

  if (dir == null) {
    // Fallback: nếu không lấy được thư mục Downloads
    final tempDir = await getTemporaryDirectory();
    filePath = _buildUniqueFilePath(tempDir.path, fileName);
  } else {
    filePath = _buildUniqueFilePath(dir.path, fileName);
  }

  final file = File(filePath);
  await file.writeAsBytes(bytes);

  // Nếu print = true, mở file với ứng dụng mặc định
  if (print) {
    await _openFile(filePath);
  }

  return filePath;
}

Future<void> _openFile(String filePath) async {
  if (Platform.isMacOS) {
    await Process.run('open', [filePath]);
  } else if (Platform.isWindows) {
    await Process.run('start', ['', filePath], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [filePath]);
  }
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
