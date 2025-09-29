import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

extension DateTimeToMySQL on DateTime {
  String toMySQLFormat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(toUtc());
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }
  return null;
}

Map<String, dynamic> _validateRow(Map<String, dynamic> json, int rowIndex) {
  List<String> rowErrors = [];
  log('[_validateRow] json: ${jsonEncode(json)}');
  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã mô hình không được để trống');
  }

  if (json['tenMoHinh'] == null ||
      json['tenMoHinh'].toString().trim().isEmpty) {
    rowErrors.add('Tên mô hình tài sản không được để trống');
  }

  // Validate phuongPhapKhauHao
  if (json['phuongPhapKhauHao'] == null) {
    rowErrors.add('Phương pháp khấu hao không được để trống');
  } else if (json['phuongPhapKhauHao'] != 1) {
    rowErrors.add('Phương pháp khấu hao chỉ được nhập 1 (Đường thẳng)');
  }

  // Validate kyKhauHao
  if (json['kyKhauHao'] == null) {
    rowErrors.add('Kỳ khấu hao không được để trống');
  } else if (json['kyKhauHao'] <= 0) {
    rowErrors.add('Kỳ khấu hao phải lớn hơn 0');
  }

  // Validate loaiKyKhauHao
  if (json['loaiKyKhauHao'] == null ||
      json['loaiKyKhauHao'].toString().trim().isEmpty) {
    rowErrors.add('Loại kỳ khấu hao không được để trống');
  } else {
    final loaiKyKhauHaoStr = json['loaiKyKhauHao'].toString().trim();
    final loaiKyKhauHaoValue = int.tryParse(loaiKyKhauHaoStr);
    if (loaiKyKhauHaoValue == null) {
      rowErrors.add('Loại kỳ khấu hao phải là số');
    } else if (loaiKyKhauHaoValue != 1 && loaiKyKhauHaoValue != 2) {
      rowErrors.add('Loại kỳ khấu hao chỉ được nhập 1 (Tháng) hoặc 2 (Năm)');
    }
  }

  // Validate taiKhoanTaiSan
  if (json['taiKhoanTaiSan'] == null ||
      json['taiKhoanTaiSan'].toString().trim().isEmpty) {
    rowErrors.add('Tài khoản tài sản không được để trống');
  } else {
    final taiKhoanTaiSanStr = json['taiKhoanTaiSan'].toString().trim();
    final taiKhoanTaiSanValue = int.tryParse(taiKhoanTaiSanStr);
    if (taiKhoanTaiSanValue == null) {
      rowErrors.add('Tài khoản tài sản phải là số');
    } else if (taiKhoanTaiSanValue <= 0) {
      rowErrors.add('Tài khoản tài sản phải lớn hơn 0');
    }
  }

  // Validate taiKhoanKhauHao
  if (json['taiKhoanKhauHao'] == null ||
      json['taiKhoanKhauHao'].toString().trim().isEmpty) {
    rowErrors.add('Tài khoản khấu hao không được để trống');
  } else {
    final taiKhoanKhauHaoStr = json['taiKhoanKhauHao'].toString().trim();
    final taiKhoanKhauHaoValue = int.tryParse(taiKhoanKhauHaoStr);
    if (taiKhoanKhauHaoValue == null) {
      rowErrors.add('Tài khoản khấu hao phải là số');
    } else if (taiKhoanKhauHaoValue <= 0) {
      rowErrors.add('Tài khoản khấu hao phải lớn hơn 0');
    }
  }

  // Validate taiKhoanChiPhi
  if (json['taiKhoanChiPhi'] == null ||
      json['taiKhoanChiPhi'].toString().trim().isEmpty) {
    rowErrors.add('Tài khoản chi phí không được để trống');
  } else {
    final taiKhoanChiPhiStr = json['taiKhoanChiPhi'].toString().trim();
    final taiKhoanChiPhiValue = int.tryParse(taiKhoanChiPhiStr);
    if (taiKhoanChiPhiValue == null) {
      rowErrors.add('Tài khoản chi phí phải là số');
    } else if (taiKhoanChiPhiValue <= 0) {
      rowErrors.add('Tài khoản chi phí phải lớn hơn 0');
    }
  }

  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToAssetCategory(
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

  List<AssetCategoryDto> assetCategories = [];
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
          "tenMoHinh": AppUtility.s(row[1]?.value),
          "phuongPhapKhauHao": _parseInt(row[2]?.value.toString()),
          "kyKhauHao": _parseInt(row[3]?.value.toString()),
          "loaiKyKhauHao": AppUtility.s(row[4]?.value),
          "taiKhoanTaiSan": AppUtility.s(row[5]?.value),
          "taiKhoanKhauHao": AppUtility.s(row[6]?.value),
          "taiKhoanChiPhi": AppUtility.s(row[7]?.value),
          "idCongTy": "ct001",
          "ngayTao": AppUtility.normalizeDateIsoString(
            row[8]?.value ?? DateTime.now(),
          ),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(
            row[9]?.value ?? DateTime.now(),
          ),
          "nguoiTao": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "isActive": true,
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
          assetCategories.add(AssetCategoryDto.fromJson(json));
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
          "tenMoHinh": cell(row, 1),
          "phuongPhapKhauHao": _parseInt(cell(row, 2).toString()),
          "kyKhauHao": _parseInt(cell(row, 3).toString()),
          "loaiKyKhauHao": AppUtility.s(cell(row, 4)),
          "taiKhoanTaiSan": AppUtility.s(cell(row, 5)),
          "taiKhoanKhauHao": AppUtility.s(cell(row, 6)),
          "taiKhoanChiPhi": AppUtility.s(cell(row, 7)),
          "idCongTy": "ct001",
          "ngayTao": AppUtility.normalizeDateIsoString(
            cell(row, 9) ?? DateTime.now(),
          ),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(
            cell(row, 10) ?? DateTime.now(),
          ),
          "nguoiTao": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "isActive": true,
        };

        // Validate row data
        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex + 1, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          assetCategories.add(AssetCategoryDto.fromJson(json));
        }
      }
    }
  }

  // Update result
  result['data'] = assetCategories;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] =
        'Import thành công ${assetCategories.length} mô hình tài sản.';
  }

  return result;
}
