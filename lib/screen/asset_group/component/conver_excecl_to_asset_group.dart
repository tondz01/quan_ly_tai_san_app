import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';



Future<List<AssetGroupDto>> convertExcelToAssetGroup(String filePath) async {
  final bytes = File(filePath).readAsBytesSync();
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  final List<AssetGroupDto> groups = [];

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
          'tenNhom': AppUtility.s(row[1]?.value),
          'hieuLuc': AppUtility.b(row[2]?.value),
          'idCongTy': AppUtility.s(row[3]?.value),
          'ngayTao': AppUtility.normalizeDateIsoString(row[4]?.value),
          'ngayCapNhat': AppUtility.normalizeDateIsoString(row[5]?.value),
          'nguoiTao': AppUtility.s(row[6]?.value, fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(row[7]?.value, fallback: fallbackUser),
          'isActive': AppUtility.b(row[8]?.value),
        };
        log('asset_group json: ${jsonEncode(json)}');
        groups.add(AssetGroupDto.fromJson(json));
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
          'tenNhom': AppUtility.s(cell(row, 1)),
          'hieuLuc': AppUtility.b(cell(row, 2)),
          'idCongTy': AppUtility.s(cell(row, 3)),
          'ngayTao': AppUtility.normalizeDateIsoString(cell(row, 4)),
          'ngayCapNhat': AppUtility.normalizeDateIsoString(cell(row, 5)),
          'nguoiTao': AppUtility.s(cell(row, 6), fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(cell(row, 7), fallback: fallbackUser),
          'isActive': AppUtility.b(cell(row, 8)),
        };
        log('asset_group json2: ${jsonEncode(json)}');
        groups.add(AssetGroupDto.fromJson(json));
      }
    }
  }

  return groups;
}
