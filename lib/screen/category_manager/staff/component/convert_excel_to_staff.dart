import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

Map<String, dynamic> _validateRow(
  Map<String, dynamic> json,
  int rowIndex,
  List<ChucVu>? chucVus,
  List<PhongBan>? phongBans,
) {
  List<String> rowErrors = [];

  log('[_validateRow] json: ${jsonEncode(json)}');
  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã nhân viên không được để trống');
  }

  if (json['hoTen'] == null || json['hoTen'].toString().trim().isEmpty) {
    rowErrors.add('Tên nhân viên không được để trống');
  }

  if (json['diDong'] == null || json['diDong'].toString().trim().isEmpty) {
    rowErrors.add('Số điện thoại không được để trống');
  } else {
    final rawPhone = json['diDong'].toString().replaceAll(' ', '');
    String candidate;
    if (rawPhone.startsWith('+')) {
      if (!rawPhone.startsWith('+84')) {
        rowErrors.add('Số điện thoại không hợp lệ');
      }
      candidate = '0${rawPhone.substring(3)}';
    } else {
      candidate = rawPhone;
    }
    final phonePattern = RegExp(r'^0\d{9,10}$');
    if (!phonePattern.hasMatch(candidate)) {
      rowErrors.add('Số điện thoại không hợp lệ');
    }
  }

  if (json['emailCongViec'] == null ||
      json['emailCongViec'].toString().trim().isEmpty) {
    rowErrors.add('Email không được để trống');
  } else {
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(json['emailCongViec'].toString())) {
      rowErrors.add('Email không hợp lệ');
    }
  }

  if (json['phongBanId'] == null ||
      json['phongBanId'].toString().trim().isEmpty) {
    rowErrors.add('Phòng ban không được để trống');
  } else {
    try {
      phongBans?.firstWhere((phongBan) => phongBan.id == json['phongBanId']);
    } catch (e) {
      rowErrors.add('Phòng ban không tồn tại ${json['phongBanId']}');
    }
  }

  if (json['chucVuId'] == null || json['chucVuId'].toString().trim().isEmpty) {
    rowErrors.add('Chức vụ không được để trống');
  } else {
    try {
      chucVus?.firstWhere((chucVu) => chucVu.id == json['chucVuId']);
    } catch (e) {
      rowErrors.add('Chức vụ không tồn tại ${json['chucVuId']}');
    }
  }
  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToNhanVien(
  String filePath, {
  Uint8List? fileBytes,
  List<ChucVu>? chucVus,
  List<PhongBan>? phongBans,
}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();
  Map<String, dynamic> result = {
    "success": true,
    "message": "",
    "data": [],
    "errors": [],
  };

  List<NhanVien> nhanVienList = [];
  List<Map<String, dynamic>> errors = [];

  try {
    final excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet == null) continue;

      // Bỏ dòng header => bắt đầu từ rowIndex = 1
      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        var row = sheet.rows[rowIndex];
        // Map từng cột vào json
        Map<String, dynamic> json = {
          "id": row[0]?.value,
          "hoTen": row[1]?.value,
          "diDong": row[2]?.value?.toString(),
          "emailCongViec": row[3]?.value,
          "agreementUUId": row[4]?.value ?? '',
          "pin": row[5]?.value ?? '',
          "boPhan": row[6]?.value,
          "phongBanId": row[6]?.value,
          "chucVu": row[7]?.value,
          "chucVuId": row[7]?.value,
          "idCongTy": "ct001",
          "nguoiTao": AccountHelper.instance.getUserInfo()!.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()!.tenDangNhap,
          "ngayTao": AppUtility.formatFromISOString(
            row[8]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          "ngayCapNhat": AppUtility.formatFromISOString(
            row[9]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          'active': true,
          'kySo':
              (row[4]!.value.toString().isNotEmpty &&
                      row[5]!.value.toString().isNotEmpty)
                  ? true
                  : false,
          "savePin":
              (row[4]!.value.toString().isNotEmpty &&
                      row[5]!.value.toString().isNotEmpty)
                  ? true
                  : false,
        };
        // Validate row data
        final validation = _validateRow(json, rowIndex, chucVus, phongBans);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          nhanVienList.add(NhanVien.fromJson(json));
        }
      }
    }
  } catch (e) {
    // Fallback: dùng spreadsheet_decoder cho file có style/numFmt đặc biệt
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    for (final table in decoder.tables.keys) {
      final sheet = decoder.tables[table];
      if (sheet == null) continue;
      // Bỏ header
      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        dynamic cell(List row, int idx) => idx < row.length ? row[idx] : null;

        Map<String, dynamic> json = {
          "id": cell(row, 0),
          "hoTen": cell(row, 1),
          "diDong": cell(row, 2)?.toString(),
          "emailCongViec": cell(row, 3),
          "agreementUUId": cell(row, 4) ?? '',
          "pin": cell(row, 5) ?? '',
          "phongBanId": cell(row, 6),
          "chucVuId": cell(row, 7),
          "idCongTy": "ct001",
          "nguoiTao": AccountHelper.instance.getUserInfo()!.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()!.tenDangNhap,
          "ngayTao": AppUtility.formatFromISOString(
            cell(row, 8) ?? DateTime.now().toIso8601String(),
          ),
          "ngayCapNhat": AppUtility.formatFromISOString(
            cell(row, 9) ?? DateTime.now().toIso8601String(),
          ),
          "boPhan": cell(row, 6),
          "chucVu": cell(row, 7),
          'active': true,
          'kySo':
              ((cell(row, 4)?.toString().isNotEmpty ?? false) &&
                      (cell(row, 5)?.toString().isNotEmpty ?? false))
                  ? true
                  : false,
          "savePin":
              ((cell(row, 4)?.toString().isNotEmpty ?? false) &&
                      (cell(row, 5)?.toString().isNotEmpty ?? false))
                  ? true
                  : false,
        };

        // Validate row data
        final validation = _validateRow(json, rowIndex, chucVus, phongBans);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex + 1, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          nhanVienList.add(NhanVien.fromJson(json));
        }
      }
    }
  }

  // Update result
  result['data'] = nhanVienList;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${nhanVienList.length} nhân viên.';
  }

  return result;
}
