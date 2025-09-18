import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

Future<List<DuAn>> convertExcelToProject(String filePath) async {
  final bytes = File(filePath).readAsBytesSync();
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  List<DuAn> duAnList = [];

  try {
    final excel = Excel.decodeBytes(bytes);

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      // Skip header (row 0)
      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(row[0]?.value),
          'tenDuAn': AppUtility.s(row[1]?.value),
          'ghiChu': AppUtility.s(row[2]?.value),
          'hieuLuc': AppUtility.b(row[3]?.value),
          'idCongTy': AppUtility.s(row[4]?.value),
          'nguoiTao': AppUtility.s(row[5]?.value, fallback: fallbackUser),
          'isActive': AppUtility.b(row[6]?.value),
        };
        log('du_an json: ${jsonEncode(json)}');
        duAnList.add(DuAn.fromJson(json));
      }
    }
  } catch (e) {
    // Fallback for tricky files
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    for (final t in decoder.tables.keys) {
      final sheet = decoder.tables[t];
      if (sheet == null) continue;

      dynamic cell(List row, int idx) => idx < row.length ? row[idx] : null;

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(cell(row, 0)),
          'tenDuAn': AppUtility.s(cell(row, 1)),
          'ghiChu': AppUtility.s(cell(row, 2)),
          'hieuLuc': AppUtility.b(cell(row, 3)),
          'idCongTy': AppUtility.s(cell(row, 4)),
          'nguoiTao': AppUtility.s(cell(row, 5), fallback: fallbackUser),
          'isActive': AppUtility.b(cell(row, 6)),
        };
        log('du_an json2: ${jsonEncode(json)}');
        duAnList.add(DuAn.fromJson(json));
      }
    }
  }

  return duAnList;
}
