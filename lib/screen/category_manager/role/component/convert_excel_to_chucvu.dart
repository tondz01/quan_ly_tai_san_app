import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

Map<String, dynamic> _validateRow(Map<String, dynamic> json, int rowIndex) {
  List<String> rowErrors = [];

  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã chức vụ không được để trống');
  }

  if (json['tenChucVu'] == null ||
      json['tenChucVu'].toString().trim().isEmpty) {
    rowErrors.add('Tên chức vụ không được để trống');
  }
  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToChucVu(
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
  List<ChucVu> chucVuList = [];
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
          'tenChucVu': AppUtility.s(row[1]?.value),
          'quanLyNhanVien': AppUtility.b(row[2]?.value ?? false),
          'quanLyPhongBan': AppUtility.b(row[3]?.value ?? false),
          'quanLyDuAn': AppUtility.b(row[4]?.value ?? false),
          'quanLyNguonVon': AppUtility.b(row[5]?.value ?? false),
          'quanLyMoHinhTaiSan': AppUtility.b(row[6]?.value ?? false),
          'quanLyNhomTaiSan': AppUtility.b(row[7]?.value ?? false),
          'quanLyTaiSan': AppUtility.b(row[8]?.value ?? false),
          'quanLyCCDCVatTu': AppUtility.b(row[9]?.value ?? false),
          'dieuDongTaiSan': AppUtility.b(row[10]?.value ?? false),
          'dieuDongCCDCVatTu': AppUtility.b(row[11]?.value ?? false),
          'banGiaoTaiSan': AppUtility.b(row[12]?.value ?? false),
          'banGiaoCCDCVatTu': AppUtility.b(row[13]?.value ?? false),
          'baoCao': AppUtility.b(row[14]?.value ?? false),
          'idCongTy': 'ct001',
          'ngayTao': AppUtility.formatFromISOString(
            row[15]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          'ngayCapNhat': AppUtility.formatFromISOString(
            row[16]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          'nguoiTao': fallbackUser,
          'nguoiCapNhat': fallbackUser,
        };
        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          chucVuList.add(ChucVu.fromJson(json));
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
          'tenChucVu': AppUtility.s(cell(row, 1)),
          'quanLyNhanVien': AppUtility.b(cell(row, 2) ?? false),
          'quanLyPhongBan': AppUtility.b(cell(row, 3) ?? false),
          'quanLyDuAn': AppUtility.b(cell(row, 4) ?? false),
          'quanLyNguonVon': AppUtility.b(cell(row, 5) ?? false),
          'quanLyMoHinhTaiSan': AppUtility.b(cell(row, 6) ?? false),
          'quanLyNhomTaiSan': AppUtility.b(cell(row, 7) ?? false),
          'quanLyTaiSan': AppUtility.b(cell(row, 8) ?? false),
          'quanLyCCDCVatTu': AppUtility.b(cell(row, 9) ?? false),
          'dieuDongTaiSan': AppUtility.b(cell(row, 10) ?? false),
          'dieuDongCCDCVatTu': AppUtility.b(cell(row, 11) ?? false),
          'banGiaoTaiSan': AppUtility.b(cell(row, 12) ?? false),
          'banGiaoCCDCVatTu': AppUtility.b(cell(row, 13) ?? false),
          'baoCao': AppUtility.b(cell(row, 14) ?? false),
          'idCongTy': 'ct001',
          'ngayTao': AppUtility.formatFromISOString(
            cell(row, 15) ?? DateTime.now().toIso8601String(),
          ),
          'ngayCapNhat': AppUtility.formatFromISOString(
            cell(row, 16) ?? DateTime.now().toIso8601String(),
          ),
          'nguoiTao': fallbackUser,
          'nguoiCapNhat': fallbackUser,
        };
        final validation = _validateRow(json, rowIndex);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          chucVuList.add(ChucVu.fromJson(json));
        }
      }
    }
  }

  // Update result
  result['data'] = chucVuList;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${chucVuList.length} chức vụ.';
  }

  return result;
}
