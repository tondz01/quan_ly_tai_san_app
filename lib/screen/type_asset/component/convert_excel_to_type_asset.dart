import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Map<String, dynamic> _validateRow(Map<String, dynamic> json, int rowIndex) {
  List<String> rowErrors = [];
  List<AssetGroupDto>? assetGroups =
      AccountHelper.instance.getAssetGroup() ?? [];
  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã loại tài sản không được để trống');
  }

  if (json['idLoaiTs'] == null || json['idLoaiTs'].toString().trim().isEmpty) {
    rowErrors.add('Mã loại tài sản cha không được để trống');
  } else {
    try {
      assetGroups.firstWhere((e) => e.id == json['idLoaiTs']);
    } catch (e) {
      rowErrors.add('Mã loại tài sản cha không tồn tại ${json['idLoaiTs']}');
    }
  }

  if (json['tenLoai'] == null || json['tenLoai'].toString().trim().isEmpty) {
    rowErrors.add('Tên loại tài sản không được để trống');
  }

  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToTypeAsset(
  String filePath, {
  Uint8List? fileBytes,
}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();
  Map<String, dynamic> result = {
    "success": true,
    "message": "",
    "data": [],
    "errors": [],
  };
  final List<TypeAsset> typeAssets = [];
  List<Map<String, dynamic>> errors = [];

  try {
    final excel = Excel.decodeBytes(bytes);

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final json = <String, dynamic>{
          'id': AppUtility.s(row[0]?.value),
          'idLoaiTs': AppUtility.s(row[1]?.value),
          'tenLoai': AppUtility.s(row[2]?.value),
        };
        // Validate row data
        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          typeAssets.add(TypeAsset.fromJson(json));
        }
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
          'idLoaiTs': AppUtility.s(cell(row, 1)),
          'tenLoai': AppUtility.s(cell(row, 2)),
        };
        // Validate row data
        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          typeAssets.add(TypeAsset.fromJson(json));
        }
      }
    }
  }
  result['data'] = typeAssets;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${typeAssets.length} loại tài sản.';
  }

  return result;
}
