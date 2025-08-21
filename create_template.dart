import 'dart:io';
import 'package:excel/excel.dart';

void main() async {
  // Tạo file Excel template
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];
  
  // Thêm header
  sheet.updateCell(CellIndex.indexByString("A1"), TextCellValue("ID"));
  sheet.updateCell(CellIndex.indexByString("B1"), TextCellValue("Tên"));
  sheet.updateCell(CellIndex.indexByString("C1"), TextCellValue("Tuổi"));
  
  // Thêm một số dữ liệu mẫu
  sheet.updateCell(CellIndex.indexByString("A2"), TextCellValue("001"));
  sheet.updateCell(CellIndex.indexByString("B2"), TextCellValue("Nguyễn Văn A"));
  sheet.updateCell(CellIndex.indexByString("C2"), TextCellValue("25"));
  
  sheet.updateCell(CellIndex.indexByString("A3"), TextCellValue("002"));
  sheet.updateCell(CellIndex.indexByString("B3"), TextCellValue("Trần Thị B"));
  sheet.updateCell(CellIndex.indexByString("C3"), TextCellValue("30"));
  
  // Lưu file
  final bytes = excel.encode()!;
  final file = File('assets/template.xlsx');
  await file.writeAsBytes(bytes);
  
  print('Đã tạo file template.xlsx trong thư mục assets');
}
