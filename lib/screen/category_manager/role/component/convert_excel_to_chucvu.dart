import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

Future<List<ChucVu>> convertExcelToChucVu(String filePath) async {
  final bytes = File(filePath).readAsBytesSync();
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  List<ChucVu> chucVuList = [];

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
          'quanLyNhanVien': AppUtility.b(row[2]?.value),
          'quanLyPhongBan': AppUtility.b(row[3]?.value),
          'quanLyDuAn': AppUtility.b(row[4]?.value),
          'quanLyNguonVon': AppUtility.b(row[5]?.value),
          'quanLyMoHinhTaiSan': AppUtility.b(row[6]?.value),
          'quanLyNhomTaiSan': AppUtility.b(row[7]?.value),
          'quanLyTaiSan': AppUtility.b(row[8]?.value),
          'quanLyCCDCVatTu': AppUtility.b(row[9]?.value),
          'dieuDongTaiSan': AppUtility.b(row[10]?.value),
          'dieuDongCCDCVatTu': AppUtility.b(row[11]?.value),
          'banGiaoTaiSan': AppUtility.b(row[12]?.value),
          'banGiaoCCDCVatTu': AppUtility.b(row[13]?.value),
          'baoCao': AppUtility.b(row[14]?.value),
          'idCongTy': AppUtility.s(row[15]?.value),
          'ngayTao': AppUtility.normalizeDateIsoString(row[16]?.value),
          'ngayCapNhat': AppUtility.normalizeDateIsoString(row[17]?.value),
          'nguoiTao': AppUtility.s(row[18]?.value, fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(row[19]?.value, fallback: fallbackUser),
        };
        log('chuc_vu json: ${jsonEncode(json)}');
        chucVuList.add(ChucVu.fromJson(json));
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
          'quanLyNhanVien': AppUtility.b(cell(row, 2)),
          'quanLyPhongBan': AppUtility.b(cell(row, 3)),
          'quanLyDuAn': AppUtility.b(cell(row, 4)),
          'quanLyNguonVon': AppUtility.b(cell(row, 5)),
          'quanLyMoHinhTaiSan': AppUtility.b(cell(row, 6)),
          'quanLyNhomTaiSan': AppUtility.b(cell(row, 7)),
          'quanLyTaiSan': AppUtility.b(cell(row, 8)),
          'quanLyCCDCVatTu': AppUtility.b(cell(row, 9)),
          'dieuDongTaiSan': AppUtility.b(cell(row, 10)),
          'dieuDongCCDCVatTu': AppUtility.b(cell(row, 11)),
          'banGiaoTaiSan': AppUtility.b(cell(row, 12)),
          'banGiaoCCDCVatTu': AppUtility.b(cell(row, 13)),
          'baoCao': AppUtility.b(cell(row, 14)),
          'idCongTy': AppUtility.s(cell(row, 15)),
          'ngayTao': AppUtility.normalizeDateIsoString(cell(row, 16)),
          'ngayCapNhat': AppUtility.normalizeDateIsoString(cell(row, 17)),
          'nguoiTao': AppUtility.s(cell(row, 18), fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(cell(row, 19), fallback: fallbackUser),
        };
        log('chuc_vu json2: ${jsonEncode(json)}');
        chucVuList.add(ChucVu.fromJson(json));
      }
    }
  }

  return chucVuList;
}
