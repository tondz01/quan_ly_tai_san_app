import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveExportFile(Uint8List bytes, String fileName) async {
  final dir = await getDownloadsDirectory();
  final path = "${dir!.path}/$fileName";
  final file = File(path);
  await file.writeAsBytes(bytes);

  return path;
}
