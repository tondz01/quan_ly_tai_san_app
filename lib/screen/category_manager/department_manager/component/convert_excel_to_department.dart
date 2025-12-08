import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

extension DateTimeToMySQL on DateTime {
  String toMySQLFormat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(toUtc());
  }
}

Map<String, dynamic> _validateRow(
  Map<String, dynamic> json,
  int rowIndex,
  List<PhongBan>? phongBans,
) {
  List<String> rowErrors = [];

  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã phòng ban không được để trống');
  }

  if (json['tenPhongBan'] == null ||
      json['tenPhongBan'].toString().trim().isEmpty) {
    rowErrors.add('Tên phòng ban không được để trống');
  }

  if (json['phongCapTren'] == null ||
      json['phongCapTren'].toString().trim().isEmpty) {
  } else {
    try {
      phongBans?.firstWhere((phongBan) => phongBan.id == json['phongCapTren']);
    } catch (e) {
      rowErrors.add('Phòng cấp trên không tồn tại ${json['phongCapTren']}');
    }
  }

  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToPhongBan(
  String filePath, {
  Uint8List? fileBytes,
  List<PhongBan>? phongBans,
}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();

  Map<String, dynamic> result = {
    "success": true,
    "message": "",
    "data": [],
    "errors": [],
  };

  List<PhongBan> phongBanList = [];
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
          "tenPhongBan": AppUtility.s(row[1]?.value),
          "idNhomDonVi": "",
          "idQuanLy": "",
          "idCongTy": "ct001",
          "phongCapTren": AppUtility.s(row[2]?.value),
          // ignore: unrelated_type_equality_checks
          "isKho": row[3]?.value == true || row[3]?.value == 'TRUE',
          // ignore: unrelated_type_equality_checks
          "isLanhDao": row[4]?.value == true || row[4]?.value == 'TRUE',
          "ngayTao": AppUtility.formatFromISOString(
            row[5]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          "ngayCapNhat": AppUtility.formatFromISOString(
            row[6]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          "nguoiTao": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "isActive": true,
        };

        final validation = _validateRow(json, rowIndex, phongBans);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          phongBanList.add(PhongBan.fromJson(json));
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
          "tenPhongBan": cell(row, 1),
          "idNhomDonVi": '',
          "idQuanLy": '',
          "idCongTy": "ct001",
          "phongCapTren": cell(row, 2),
          "isKho": cell(row, 3) == true || cell(row, 3) == 'TRUE',
          "isLanhDao": cell(row, 4) == true || cell(row, 4) == 'TRUE',
          "ngayTao": AppUtility.formatFromISOString(
            cell(row, 5) ?? DateTime.now().toIso8601String(),
          ),
          "ngayCapNhat": AppUtility.formatFromISOString(
            cell(row, 6) ?? DateTime.now().toIso8601String(),
          ),
          "nguoiTao": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "isActive": true,
        };
        // Validate row data
        final validation = _validateRow(json, rowIndex, phongBans);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex + 1, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          phongBanList.add(PhongBan.fromJson(json));
        }
      }
    }
  }
  // Update result
  result['data'] = phongBanList;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${phongBanList.length} phòng ban.';
  }

  return result;
}
