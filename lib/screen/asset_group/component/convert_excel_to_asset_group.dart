import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

extension DateTimeToISO on DateTime {
  String toISOFormat() {
    return toUtc().toIso8601String();
  }
}

/// Helper function to normalize date to ISO format with UTC timezone
String _normalizeDateToISO(dynamic value) {
  if (value == null) return DateTime.now().toISOFormat();
  if (value is DateTime) return value.toISOFormat();
  if (value is num) return AppUtility.excelSerialToDate(value).toISOFormat();
  
  final text = value.toString().trim();
  if (text.isEmpty) return DateTime.now().toISOFormat();
  
  // Try to parse the date
  final parsed = DateTime.tryParse(text);
  if (parsed != null) return parsed.toISOFormat();
  
  // If parsing fails, return current date
  return DateTime.now().toISOFormat();
}

Future<List<AssetGroupDto>> convertExcelToAssetGroup(
  String filePath, {
  Uint8List? fileBytes,
}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  final List<AssetGroupDto> groups = [];

  // Validate input
  if (bytes.isEmpty) {
    log('Error: File is empty');
    return groups;
  }

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
          'ngayTao': _normalizeDateToISO(row[4]?.value),
          'ngayCapNhat': _normalizeDateToISO(row[5]?.value),
          'nguoiTao': AppUtility.s(row[6]?.value, fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(row[7]?.value, fallback: fallbackUser),
          'isActive': AppUtility.b(row[8]?.value),
        };
        log('asset_group json: ${jsonEncode(json)}');
        log('Date format check - ngayTao: ${json['ngayTao']}, ngayCapNhat: ${json['ngayCapNhat']}');
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
          'ngayTao': _normalizeDateToISO(cell(row, 4)),
          'ngayCapNhat': _normalizeDateToISO(cell(row, 5)),
          'nguoiTao': AppUtility.s(cell(row, 6), fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(cell(row, 7), fallback: fallbackUser),
          'isActive': AppUtility.b(cell(row, 8)),
        };
        log('asset_group json2: ${jsonEncode(json)}');
        log('Date format check - ngayTao: ${json['ngayTao']}, ngayCapNhat: ${json['ngayCapNhat']}');
        groups.add(AssetGroupDto.fromJson(json));
      }
    }
  }

  return groups;
}
