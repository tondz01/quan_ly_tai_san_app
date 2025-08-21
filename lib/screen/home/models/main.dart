import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
// Import cho web download
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExcelPage(),
    );
  }
}

class ExcelPage extends StatefulWidget {
  const ExcelPage({super.key});

  @override
  State<ExcelPage> createState() => _ExcelPageState();
}

class _ExcelPageState extends State<ExcelPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController rowController = TextEditingController(); // Thêm controller cho row
  final TextEditingController colController = TextEditingController(); // Thêm controller cho column
  
  // Thêm controller cho nhiều cột (A đến H)
  final List<TextEditingController> columnControllers = List.generate(8, (index) => TextEditingController());
  final List<String> columnLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  
  Excel? currentExcel; // Cache Excel hiện tại
  String excelInfo = "Chưa tải Excel"; // Thông tin về file Excel
  bool useMultiColumn = false; // Toggle giữa chế độ 3 cột và nhiều cột
  String? savedExcelPath; // Đường dẫn file Excel đã lưu

  @override
  void initState() {
    super.initState();
    // Log thông tin platform
    print("[EXCEL LOG] =================================");
    print("[EXCEL LOG] App khởi tạo - Platform: ${kIsWeb ? 'Web' : 'Mobile/Desktop'}");
    print("[EXCEL LOG] =================================");
    
    // Tự động load Excel khi khởi tạo
    _loadExcelFromAssets();
  }

  // Tải file Excel từ assets hoặc file đã lưu trước đó
  Future<Excel> _loadExcelFromAssets() async {
    print("[EXCEL LOG] Bắt đầu tải Excel...");
    try {
      if (kIsWeb) {
        // Trên web, chỉ load từ assets
        print("[EXCEL LOG] Platform: Web - Load từ assets");
        final ByteData data = await rootBundle.load('assets/template.xlsx');
        final Uint8List bytes = data.buffer.asUint8List();
        final excel = Excel.decodeBytes(bytes);
        
        print("[EXCEL LOG] ✅ Đã load Excel từ assets thành công");
        currentExcel = excel;
        _updateExcelInfo(excel);
        
        return excel;
      } else {
        // Trên mobile/desktop, kiểm tra file đã lưu trước
        print("[EXCEL LOG] Platform: Mobile/Desktop - Kiểm tra file đã lưu...");
        final savedPath = await _getSavedExcelPath();
        final savedFile = File(savedPath);
        
        print("[EXCEL LOG] Đường dẫn kiểm tra: $savedPath");
        
        if (await savedFile.exists()) {
          // Nếu có file đã lưu, load file đó
          print("[EXCEL LOG] ✅ Tìm thấy file đã lưu - Load từ file đã lưu");
          final bytes = await savedFile.readAsBytes();
          final excel = Excel.decodeBytes(bytes);
          
          print("[EXCEL LOG] Kích thước file đã load: ${bytes.length} bytes");
          currentExcel = excel;
          savedExcelPath = savedPath;
          _updateExcelInfo(excel);
          
          return excel;
        } else {
          // Nếu chưa có file đã lưu, load từ assets
          print("[EXCEL LOG] ❌ Không tìm thấy file đã lưu - Load từ assets");
          final ByteData data = await rootBundle.load('assets/template.xlsx');
          final Uint8List bytes = data.buffer.asUint8List();
          final excel = Excel.decodeBytes(bytes);
          
          print("[EXCEL LOG] ✅ Đã load Excel từ assets thành công");
          currentExcel = excel;
          _updateExcelInfo(excel);
          
          return excel;
        }
      }
    } catch (e) {
      // Nếu không có file template hoặc lỗi, tạo file mới
      print("[EXCEL LOG] ⚠️ Lỗi load Excel: $e - Tạo file mới");
      final excel = Excel.createExcel();
      final sheet = excel[excel.tables.keys.first];
      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Tên'),
        TextCellValue('Tuổi'),
      ]);
      
      print("[EXCEL LOG] ✅ Đã tạo Excel mới thành công");
      currentExcel = excel;
      _updateExcelInfo(excel);
      
      return excel;
    }
  }

  // Cập nhật thông tin về file Excel
  void _updateExcelInfo(Excel excel) {
    final sheetName = excel.tables.keys.first;
    final sheet = excel[sheetName];
    final lastRow = _findLastRowWithData(sheet);
    final totalRows = sheet.rows.length;
    
    String fileSource;
    if (kIsWeb) {
      fileSource = "Web - Assets";
    } else {
      fileSource = savedExcelPath != null ? "File đã lưu" : "Assets";
    }
    
    setState(() {
      excelInfo = "$fileSource | Sheet: $sheetName | Dòng cuối: $lastRow | Tổng dòng: $totalRows";
    });
  }

  // Download file Excel trên web
  void _downloadExcelOnWeb(Excel excel, String fileName) {
    if (kIsWeb) {
      try {
        // Encode Excel thành bytes
        final bytes = excel.encode();
        if (bytes != null) {
          // Tạo Blob và download
          final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.document.createElement('a') as html.AnchorElement
            ..href = url
            ..style.display = 'none'
            ..download = fileName;
          html.document.body?.children.add(anchor);
          anchor.click();
          html.document.body?.children.remove(anchor);
          html.Url.revokeObjectUrl(url);
          
          print("[EXCEL LOG] ✅ Đã tải xuống file Excel: $fileName");
        }
      } catch (e) {
        print("[EXCEL LOG] ❌ Lỗi download file: $e");
      }
    }
  }

  // Tải xuống file Excel hiện tại (không thêm dữ liệu mới)
  void _downloadCurrentExcel() {
    if (kIsWeb && currentExcel != null) {
      final now = DateTime.now();
      final fileName = "current_excel_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.xlsx";
      
      print("[EXCEL LOG] Tải xuống file Excel hiện tại...");
      _downloadExcelOnWeb(currentExcel!, fileName);
      
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã tải xuống file Excel hiện tại: $fileName")),
        );
      }
    }
  }

  // Không cần method _getFilePath nữa vì chỉ làm việc với assets

  // Lấy đường dẫn file Excel để lưu
  Future<String> _getSavedExcelPath() async {
    if (kIsWeb) {
      // Trên web không thể lưu file, chỉ trả về tên file
      print("[EXCEL LOG] Web platform - Không thể tạo đường dẫn file thực");
      return "modified_excel.xlsx";
    } else {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final path = "${dir.path}/modified_excel.xlsx";
        print("[EXCEL LOG] Đường dẫn file Excel: $path");
        print("[EXCEL LOG] Thư mục Documents: ${dir.path}");
        return path;
      } catch (e) {
        print("[EXCEL LOG] Lỗi lấy đường dẫn file: $e");
        return "modified_excel.xlsx";
      }
    }
  }

  Future<void> _insertToExcel() async {
    // Tải Excel từ assets nếu chưa có
    Excel excel = currentExcel ?? await _loadExcelFromAssets();

    final String sheetName = excel.tables.keys.first;
    final Sheet sheet = excel[sheetName];

    // Kiểm tra input từ người dùng
    final rowInput = rowController.text.trim();
    final colInput = colController.text.trim();
    
    // Xác định vị trí chèn
    int targetRow;
    int targetCol;
    
    if (rowInput.isNotEmpty) {
      // Nếu có nhập row, sử dụng row đó
      targetRow = (int.tryParse(rowInput) ?? 1) - 1; // -1 vì index bắt đầu từ 0
      print("[EXCEL LOG] Sử dụng row được chỉ định: ${targetRow + 1}");
    } else {
      // Nếu không nhập row, tự động tìm dòng cuối
      targetRow = _findLastRowWithData(sheet);
      print("[EXCEL LOG] Tự động tìm dòng cuối: ${targetRow + 1}");
    }
    
    if (colInput.isNotEmpty) {
      // Nếu có nhập column, sử dụng column đó
      targetCol = (int.tryParse(colInput) ?? 1) - 1; // -1 vì index bắt đầu từ 0
      print("[EXCEL LOG] Sử dụng cột được chỉ định: ${targetCol + 1}");
    } else {
      // Nếu không nhập column, mặc định là cột A (index 0)
      targetCol = 0;
      print("[EXCEL LOG] Sử dụng cột mặc định: A");
    }
    
    print("[EXCEL LOG] Chèn dữ liệu tại vị trí: Row ${targetRow + 1}, Col ${targetCol + 1}");
    
    if (useMultiColumn) {
      // Chèn nhiều cột (A-H)
      _insertMultiColumnData(sheet, targetRow, targetCol);
    } else {
      // Chèn 3 cột cơ bản
      _insertBasicData(sheet, targetRow, targetCol);
    }

    // Cập nhật cache và thông tin
    currentExcel = excel;
    _updateExcelInfo(excel);

    // Lưu file Excel đã chỉnh sửa
    await _saveExcel(excel);
  }

  // Chèn dữ liệu 3 cột cơ bản (ID, Tên, Tuổi)
  void _insertBasicData(Sheet sheet, int rowIndex, int colIndex) {
    sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex), 
        TextCellValue(idController.text));
    sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: colIndex + 1, rowIndex: rowIndex), 
        TextCellValue(nameController.text));
    sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: colIndex + 2, rowIndex: rowIndex), 
        TextCellValue(ageController.text));
  }

  // Chèn dữ liệu nhiều cột (A-H)
  void _insertMultiColumnData(Sheet sheet, int rowIndex, int colIndex) {
    for (int i = 0; i < columnControllers.length; i++) {
      final cellValue = columnControllers[i].text.trim();
      if (cellValue.isNotEmpty) {
        sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: colIndex + i, rowIndex: rowIndex), 
            TextCellValue(cellValue));
      }
    }
  }

  // Tìm dòng cuối cùng có dữ liệu
  int _findLastRowWithData(Sheet sheet) {
    int maxRow = 0;
    for (var row in sheet.rows) {
      // Kiểm tra xem dòng có dữ liệu không
      bool hasData = false;
      for (var cell in row) {
        if (cell?.value != null && cell!.value.toString().trim().isNotEmpty) {
          hasData = true;
          break;
        }
      }
      if (hasData) {
        maxRow = sheet.rows.indexOf(row) + 1; // +1 vì index bắt đầu từ 0
      }
    }
    return maxRow; // Trả về dòng tiếp theo để thêm dữ liệu
  }

  Future<void> _saveExcel(Excel excel) async {
    if (kIsWeb) {
      // Trên web, tải file xuống
      print("[EXCEL LOG] Platform: Web - Tải file xuống...");
      
      // Tạo tên file với timestamp
      final now = DateTime.now();
      final fileName = "modified_excel_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.xlsx";
      
      _downloadExcelOnWeb(excel, fileName);
      
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã tải xuống file Excel: $fileName")),
        );
      }
    } else {
      // Trên mobile/desktop, lưu vào file
      try {
        final path = await _getSavedExcelPath();
        print("[EXCEL LOG] Đường dẫn file sẽ lưu: $path");
        
        final file = File(path);
        print("[EXCEL LOG] Bắt đầu ghi file Excel...");
        
        await file.writeAsBytes(excel.encode()!);
        
        savedExcelPath = path;
        print("[EXCEL LOG] ✅ Đã lưu thành công file Excel tại: $path");
        print("[EXCEL LOG] Kích thước file: ${await file.length()} bytes");
        
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đã lưu dữ liệu vào Excel: $path")),
          );
        }
      } catch (e) {
        print("[EXCEL LOG] ❌ Lỗi lưu file: $e");
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi lưu file: $e")),
          );
        }
      }
    }
    
    // Clear controllers
    if (useMultiColumn) {
      for (var controller in columnControllers) {
        controller.clear();
      }
    } else {
      idController.clear();
      nameController.clear();
      ageController.clear();
    }
    rowController.clear();
    colController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhập dữ liệu Excel")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hiển thị thông tin Excel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  excelInfo,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              
              // Toggle chế độ nhập
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Text("Chế độ nhập:", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      Switch(
                        value: useMultiColumn,
                        onChanged: (value) {
                          setState(() {
                            useMultiColumn = value;
                          });
                        },
                      ),
                      Text(useMultiColumn ? "Nhiều cột (A-H)" : "3 cột cơ bản"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Form nhập dữ liệu
              if (!useMultiColumn) ..._buildBasicForm() else ..._buildMultiColumnForm(),
              
              const SizedBox(height: 16),
              
              // Vị trí chèn
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: rowController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Dòng (Row)",
                        border: OutlineInputBorder(),
                        hintText: "VD: 7 (để trống = tự động tìm dòng cuối)",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: colController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Cột bắt đầu",
                        border: OutlineInputBorder(),
                        hintText: "VD: 1=A (để trống = mặc định A)",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _insertToExcel,
                  icon: Icon(kIsWeb ? Icons.download : Icons.save),
                  label: Text(
                    kIsWeb 
                      ? (useMultiColumn ? "Tải xuống Excel (nhiều cột)" : "Tải xuống Excel (3 cột)")
                      : (useMultiColumn ? "Lưu nhiều cột vào Excel" : "Lưu 3 cột vào Excel")
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              
              // Button tải xuống file Excel hiện tại (chỉ hiển thị trên web)
              if (kIsWeb && currentExcel != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadCurrentExcel(),
                    icon: const Icon(Icons.file_download),
                    label: const Text("Tải xuống file Excel hiện tại"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Form cơ bản (3 cột)
  List<Widget> _buildBasicForm() {
    return [
      TextField(
        controller: idController,
        decoration: const InputDecoration(
          labelText: "ID (Cột A)",
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: "Tên (Cột B)",
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: ageController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Tuổi (Cột C)",
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }

  // Form nhiều cột (A-H)
  List<Widget> _buildMultiColumnForm() {
    return List.generate(columnControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: columnControllers[index],
          decoration: InputDecoration(
            labelText: "Cột ${columnLabels[index]}",
            border: const OutlineInputBorder(),
            hintText: "Nhập dữ liệu cho cột ${columnLabels[index]}",
          ),
        ),
      );
    });
  }
}