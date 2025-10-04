import 'dart:developer';
import 'dart:typed_data';
import 'dart:io' show File; // Only used when filePath is provided (non-web)

import 'package:excel/excel.dart' as excel;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

/// Kiểm tra validate file import tài sản theo các cột bắt buộc
/// Bắt buộc: id(0), soThe(1), tenTaiSan(2), nguyenGia(3), idNhomTaiSan(8), donViTinh(27)
/// Nếu có lỗi: hiện AppUtility.showSnackBar với danh sách lỗi, trả về false
/// Ngược lại: trả về true
Future<bool> checkValidateImportAsset(
  BuildContext context, {
  Uint8List? bytes,
  String? filePath,
}) async {
  try {
    final Uint8List fileBytes;
    if (bytes != null) {
      fileBytes = bytes;
    } else if (filePath != null && filePath.isNotEmpty) {
      fileBytes = File(filePath).readAsBytesSync();
    } else {
      AppUtility.showSnackBar(
        context,
        'Không tìm thấy dữ liệu file import',
        isError: true,
      );
      return false;
    }

    final List<_RequiredField> required = <_RequiredField>[
      _RequiredField(index: 0, displayName: 'Số thẻ tài sản'), // id
      _RequiredField(index: 1, displayName: 'Mã tài sản'), // soThe
      _RequiredField(index: 2, displayName: 'Tên tài sản'), // tenTaiSan
      _RequiredField(index: 7, displayName: 'Mã nhóm tài sản'), // idNhomTaiSan
      _RequiredField(
        index: 31,
        displayName: 'Mã đơn vị hiện thời',
      ), // idDonViHienThoi
    ];

    // Capital fields that must be numeric
    final List<_CapitalField> capitalFields = <_CapitalField>[
      _CapitalField(index: 10, displayName: 'Vốn NS'),
      _CapitalField(index: 11, displayName: 'Vốn vay'),
      _CapitalField(index: 12, displayName: 'Vốn khác'),
      _CapitalField(index: 24, displayName: 'Năm sản xuất'),
    ];

    final List<String> errors = <String>[];

    try {
      final excelFile = excel.Excel.decodeBytes(fileBytes);
      for (final table in excelFile.tables.keys) {
        final sheet = excelFile.tables[table];
        if (sheet == null) continue;
        for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
          final row = sheet.rows[rowIndex];

          // Validate required fields
          for (final rf in required) {
            final cell = rf.index < row.length ? row[rf.index] : null;
            final raw = cell?.value;
            final valueStr = AppUtility.s(raw);
            final int displayRow = rowIndex;
            final String columnLetter = _getColumnLetter(rf.index);
            if (valueStr.trim().isEmpty) {
              errors.add(
                'Cột: $columnLetter - Hàng: $displayRow -- Lỗi: ${rf.displayName} đang bỏ trống',
              );
            }
          }

          // Validate capital fields (must be numeric)
          for (final cf in capitalFields) {
            final cell = cf.index < row.length ? row[cf.index] : null;
            final raw = cell?.value;
            final valueStr = AppUtility.s(raw);
            final int displayRow = rowIndex;
            final String columnLetter = _getColumnLetter(cf.index);

            if (valueStr.trim().isNotEmpty) {
              // Check if the value can be parsed as a number
              final cleanedValue = valueStr.replaceAll(RegExp(r'[^\d.]'), '');
              if (double.tryParse(cleanedValue) == null) {
                errors.add(
                  'Cột: $columnLetter - Hàng: $displayRow -- Lỗi: ${cf.displayName} phải là số, không được là text: "$valueStr"',
                );
              }
            }
          }
        }
      }
    } catch (_) {
      // Fallback: spreadsheet_decoder for problematic numFmtId
      final decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: false);
      for (final table in decoder.tables.keys) {
        final sheet = decoder.tables[table];
        if (sheet == null) continue;
        for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
          final row = sheet.rows[rowIndex];
          dynamic cellAt(int idx) => (idx < row.length) ? row[idx] : null;

          // Validate required fields
          for (final rf in required) {
            final raw = cellAt(rf.index);
            final valueStr = AppUtility.s(raw);
            final int displayRow = rowIndex;
            final String columnLetter = _getColumnLetter(rf.index);
            if (valueStr.trim().isEmpty) {
              errors.add(
                'Cột: $columnLetter - Hàng: $displayRow -- Lỗi: ${rf.displayName} đang bỏ trống',
              );
            }
          }

          // Validate capital fields (must be numeric)
          for (final cf in capitalFields) {
            final raw = cellAt(cf.index);
            final valueStr = AppUtility.s(raw);
            final int displayRow = rowIndex;
            final String columnLetter = _getColumnLetter(cf.index);

            if (valueStr.trim().isNotEmpty) {
              // Check if the value can be parsed as a number
              final cleanedValue = valueStr.replaceAll(RegExp(r'[^\d.]'), '');
              if (double.tryParse(cleanedValue) == null) {
                errors.add(
                  'Cột: $columnLetter - Hàng: $displayRow -- Lỗi: ${cf.displayName} phải là số, không được là text: "$valueStr"',
                );
              }
            }
          }
        }
      }
    }

    if (errors.isNotEmpty) {
      _showErrorDialog(context, errors);
      return false;
    }

    return true;
  } catch (e) {
    log('message test: error $e');
    AppUtility.showSnackBar(
      context,
      'Không đọc được file import: $e',
      isError: true,
    );
    return false;
  }
}

class _RequiredField {
  final int index;
  final String displayName;
  const _RequiredField({required this.index, required this.displayName});
}

class _CapitalField {
  final int index;
  final String displayName;
  const _CapitalField({required this.index, required this.displayName});
}

/// Convert column index to Excel column letter (0=A, 1=B, 25=Z, 26=AA, etc.)
String _getColumnLetter(int columnIndex) {
  String result = '';
  while (columnIndex >= 0) {
    result = String.fromCharCode(65 + (columnIndex % 26)) + result;
    columnIndex = (columnIndex ~/ 26) - 1;
  }
  return result;
}

/// Show error dialog with scrollable list of errors
void _showErrorDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Lỗi Import Dữ Liệu'),
          ],
        ),
        content: Container(
          width: double.minPositive,
          height: 400, // Fixed height for scrollable content
          constraints: BoxConstraints(minWidth: 450),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Có ${errors.length} lỗi cần sửa trước khi import:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: errors.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errors[index],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      );
    },
  );
}
