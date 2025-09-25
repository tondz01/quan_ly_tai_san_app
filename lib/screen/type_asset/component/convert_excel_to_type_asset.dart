import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Future<List<TypeAsset>> convertExcelToTypeAsset(String filePath) async {
  final bytes = File(filePath).readAsBytesSync();

  final List<TypeAsset> list = [];

  try {
    final excel = Excel.decodeBytes(bytes);

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(row[0]?.value),
          'idLoaiCCDC': AppUtility.s(row[1]?.value),
          'tenLoai': AppUtility.s(row[2]?.value),
        };
        list.add(TypeAsset.fromJson(json));
      }
    }
  } catch (e) {
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    for (final t in decoder.tables.keys) {
      final sheet = decoder.tables[t];
      if (sheet == null) continue;

      dynamic cell(List row, int idx) => idx < row.length ? row[idx] : null;

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(cell(row, 0)),
          'idLoaiCCDC': AppUtility.s(cell(row, 1)),
          'tenLoai': AppUtility.s(cell(row, 2)),
        };
        list.add(TypeAsset.fromJson(json));
      }
    }
  }

  return list;
}

// Web-safe: parse from provided bytes (no dart:io)
Future<List<TypeAsset>> convertExcelToTypeAssetBytes(Uint8List bytes) async {
  final List<TypeAsset> list = [];

  try {
    final excel = Excel.decodeBytes(bytes);

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(row[0]?.value),
          'idLoaiCCDC': AppUtility.s(row[1]?.value),
          'tenLoai': AppUtility.s(row[2]?.value),
        };
        list.add(TypeAsset.fromJson(json));
      }
    }
  } catch (e) {
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    for (final t in decoder.tables.keys) {
      final sheet = decoder.tables[t];
      if (sheet == null) continue;

      dynamic cell(List row, int idx) => idx < row.length ? row[idx] : null;

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(cell(row, 0)),
          'idLoaiCCDC': AppUtility.s(cell(row, 1)),
          'tenLoai': AppUtility.s(cell(row, 2)),
        };
        list.add(TypeAsset.fromJson(json));
      }
    }
  }

  return list;
}
