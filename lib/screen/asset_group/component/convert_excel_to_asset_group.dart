import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Map<String, dynamic> _validateRow(Map<String, dynamic> json, int rowIndex) {
  List<String> rowErrors = [];

  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã nhóm không được để trống');
  }

  if (json['tenNhom'] == null || json['tenNhom'].toString().trim().isEmpty) {
    rowErrors.add('Tên nhóm không được để trống');
  }

  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToAssetGroup(
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

  final List<AssetGroupDto> groups = [];
  List<Map<String, dynamic>> errors = [];

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
          'hieuLuc': AppUtility.b(row[2]?.value ?? true),
          'idCongTy': 'ct001',
          'ngayTao': AppUtility.formatFromISOString(
            row[3]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          'ngayCapNhat': AppUtility.formatFromISOString(
            row[4]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          'nguoiTao': fallbackUser,
          'nguoiCapNhat': fallbackUser,
          'isActive': true,
        };

        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          groups.add(AssetGroupDto.fromJson(json));
        }
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
          'hieuLuc': AppUtility.b(cell(row, 2) ?? true),
          'idCongTy': 'ct001',
          'ngayTao': AppUtility.formatFromISOString(
            cell(row, 3) ?? DateTime.now().toIso8601String(),
          ),
          'ngayCapNhat': AppUtility.formatFromISOString(
            cell(row, 4) ?? DateTime.now().toIso8601String(),
          ),
          'nguoiTao': fallbackUser,
          'nguoiCapNhat': fallbackUser,
          'isActive': true,
        };

        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          groups.add(AssetGroupDto.fromJson(json));
        }
      }
    }
  }

  result['data'] = groups;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${groups.length} nhóm tài sản.';
  }

  return result;
}
