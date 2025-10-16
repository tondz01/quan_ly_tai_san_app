import 'dart:typed_data';

import 'package:quan_ly_tai_san_app/common/reponsitory/convert_pdf_repository.dart';

Future<Uint8List> convertDocxBytesToPdf({
  required String fileName, // 'Mau danh sach.docx'
  required Uint8List fileBytes, // bytes đọc từ FilePicker
  required String jsessionId, // 'F81793FE9E...'
}) async {
  final repo = ConvertPdfRepository();
  final res = await repo.convertDocxToPdfBytes(
    fileName: fileName,
    fileBytes: fileBytes,
    jsessionId: jsessionId,
  );
  if (res['status_code'] == 200 && res['data'] is Uint8List) {
    return res['data'] as Uint8List; // PDF bytes trả về từ server
  }
  throw Exception('Convert failed: ${res['status_code']}');
}
