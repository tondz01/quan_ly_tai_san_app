import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
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



Future<List<PhongBan>> convertExcelToPhongBan(String filePath, {Uint8List? fileBytes}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();
  List<PhongBan> phongBanList = [];

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
          "idNhomDonVi": AppUtility.s(row[2]?.value),
          "idQuanLy": AppUtility.s(row[3]?.value),
          "idCongTy":
              AppUtility.s(row[4]?.value) == ''
                  ? AccountHelper.instance.getUserInfo()?.idCongTy
                  : AppUtility.s(row[4]?.value),
          "phongCapTren": AppUtility.s(row[5]?.value),
          "ngayTao": AppUtility.normalizeDateIsoString(row[6]?.value),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(row[7]?.value),
          "nguoiTao": _sanitizeString(
            row[8]?.value,
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "nguoiCapNhat": _sanitizeString(
            row[9]?.value,
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "isActive": row[11]?.value ?? true,
        };
        log('json: ${jsonEncode(json)}');
        phongBanList.add(PhongBan.fromJson(json));
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
          "idNhomDonVi": cell(row, 2),
          "idQuanLy": cell(row, 3),
          "idCongTy": cell(row, 4) ?? "ct001",
          "phongCapTren": cell(row, 5),
          "ngayTao": AppUtility.normalizeDateIsoString(cell(row, 6)),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(cell(row, 7)),
          "nguoiTao": _sanitizeString(
            cell(row, 8),
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "nguoiCapNhat": _sanitizeString(
            cell(row, 9),
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "isActive": cell(row, 10) ?? true,
        };
        log('json2: ${jsonEncode(json)}');
        phongBanList.add(PhongBan.fromJson(json));
      }
    }
  }
  return phongBanList;
}
