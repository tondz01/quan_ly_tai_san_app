import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

String _sanitizeString(dynamic value, {String? fallback}) {
  final str = value?.toString().trim();
  if (str == null || str.isEmpty) {
    return (fallback ?? '').trim();
  }
  return str;
}

extension DateTimeToMySQL on DateTime {
  String toMySQLFormat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(toUtc());
  }
}

Map<String, dynamic> _validateRow(Map<String, dynamic> json, int rowIndex) {
  List<String> rowErrors = [];

  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã nguồn kinh phí không được để trống');
  }

  if (json['tenNguonKinhPhi'] == null ||
      json['tenNguonKinhPhi'].toString().trim().isEmpty) {
    rowErrors.add('Tên nguồn kinh phí không được để trống');
  }

  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToCapitalSource(
  String filePath, {
  Uint8List? fileBytes,
}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  Map<String, dynamic> result = {
    "success": true,
    "message": "",
    "data": [],
    "errors": [],
  };

  List<NguonKinhPhi> nguonKinhPhiList = [];
  List<Map<String, dynamic>> errors = [];

  try {
    final excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet == null) continue;
      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        var row = sheet.rows[rowIndex];
        Map<String, dynamic> json = {
          "id": AppUtility.s(row[0]?.value),
          "tenNguonKinhPhi": AppUtility.s(row[1]?.value),
          "ghiChu": AppUtility.s(row[2]?.value),
          "hieuLuc": AppUtility.s(row[3]?.value ?? true),
          "idCongTy": "ct001",
          "ngayTao": AppUtility.normalizeDateIsoString(
            row[5]?.value ?? DateTime.now(),
          ),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(
            row[6]?.value ?? DateTime.now(),
          ),
          "nguoiTao": fallbackUser,
          "nguoiCapNhat": fallbackUser,
          "isActive": true,
        };
        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          nguonKinhPhiList.add(NguonKinhPhi.fromJson(json));
        }
      }
    }
  } catch (e) {
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    for (final table in decoder.tables.keys) {
      final sheet = decoder.tables[table];
      if (sheet == null) continue;
      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        dynamic cell(List row, int idx) => idx < row.length ? row[idx] : null;
        Map<String, dynamic> json = {
          "id": cell(row, 0),
          "tenNguonKinhPhi": cell(row, 1),
          "ghiChu": cell(row, 2),
          "hieuLuc": cell(row, 3) ?? true,
          "idCongTy": "ct001",
          "ngayTao": AppUtility.normalizeDateIsoString(
            cell(row, 5) ?? DateTime.now(),
          ),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(
            cell(row, 6) ?? DateTime.now(),
          ),
          "nguoiTao": fallbackUser,
          "nguoiCapNhat": fallbackUser,
          "isActive": true,
        };

        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          nguonKinhPhiList.add(NguonKinhPhi.fromJson(json));
        }
      }
    }
  }
  result['data'] = nguonKinhPhiList;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] =
        'Import thành công ${nguonKinhPhiList.length} nguồn kinh phí.';
  }

  return result;
}
