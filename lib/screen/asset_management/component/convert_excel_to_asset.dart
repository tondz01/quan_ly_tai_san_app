import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

Future<List<AssetManagementDto>> convertExcelToAsset(String filePath) async {
  final bytes = File(filePath).readAsBytesSync();
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  List<AssetManagementDto> assetList = [];

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
          'tenTaiSan': AppUtility.s(row[1]?.value),
          'nguyenGia': AppUtility.parseCurrency(AppUtility.s(row[2]?.value)),
          'giaTriKhauHaoBanDau': AppUtility.parseCurrency(AppUtility.s(row[3]?.value)),
          'kyKhauHaoBanDau': int.tryParse(AppUtility.s(row[4]?.value)),
          'giaTriThanhLy': AppUtility.parseCurrency(AppUtility.s(row[5]?.value)),
          'idMoHinhTaiSan': AppUtility.s(row[6]?.value),
          'tenMoHinh': AppUtility.s(row[7]?.value),
          'idNhomTaiSan': AppUtility.s(row[8]?.value),
          'tenNhom': AppUtility.s(row[9]?.value),
          'idDuAn': AppUtility.s(row[10]?.value),
          'tenDuAn': AppUtility.s(row[11]?.value),
          'idNguonVon': AppUtility.s(row[12]?.value),
          'tenNguonKinhPhi': AppUtility.s(row[13]?.value),
          'phuongPhapKhauHao': int.tryParse(AppUtility.s(row[14]?.value)),
          'soKyKhauHao': int.tryParse(AppUtility.s(row[15]?.value)),
          'taiKhoanTaiSan': int.tryParse(AppUtility.s(row[16]?.value)),
          'taiKhoanKhauHao': int.tryParse(AppUtility.s(row[17]?.value)),
          'taiKhoanChiPhi': int.tryParse(AppUtility.s(row[18]?.value)),
          'ngayVaoSo': AppUtility.normalizeDateIsoString(row[19]?.value),
          'ngaySuDung': AppUtility.normalizeDateIsoString(row[20]?.value),
          'kyHieu': AppUtility.s(row[21]?.value),
          'soKyHieu': AppUtility.s(row[22]?.value),
          'congSuat': AppUtility.s(row[23]?.value),
          'nuocSanXuat': AppUtility.s(row[24]?.value),
          'namSanXuat': int.tryParse(AppUtility.s(row[25]?.value)),
          'lyDoTang': int.tryParse(AppUtility.s(row[26]?.value)),
          'hienTrang': int.tryParse(AppUtility.s(row[27]?.value)),
          'soLuong': int.tryParse(AppUtility.s(row[28]?.value)),
          'donViTinh': AppUtility.s(row[29]?.value),
          'ghiChu': AppUtility.s(row[30]?.value),
          'idDonViBanDau': AppUtility.s(row[31]?.value),
          'idDonViHienThoi': AppUtility.s(row[32]?.value),
          'moTa': AppUtility.s(row[33]?.value),
          'idCongTy': AppUtility.s(row[34]?.value),
          'ngayTao': AppUtility.normalizeDateIsoString(row[35]?.value),
          'ngayCapNhat': AppUtility.normalizeDateIsoString(row[36]?.value),
          'nguoiTao': AppUtility.s(row[37]?.value, fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(row[38]?.value, fallback: fallbackUser),
          'isActive': AppUtility.b(row[39]?.value),
        };
        log('asset json: ${jsonEncode(json)}');
        assetList.add(AssetManagementDto.fromJson(json));
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
          'tenTaiSan': AppUtility.s(cell(row, 1)),
          'nguyenGia': AppUtility.parseCurrency(AppUtility.s(cell(row, 2))),
          'giaTriKhauHaoBanDau': AppUtility.parseCurrency(AppUtility.s(cell(row, 3))),
          'kyKhauHaoBanDau': int.tryParse(AppUtility.s(cell(row, 4))),
          'giaTriThanhLy': AppUtility.parseCurrency(AppUtility.s(cell(row, 5))),
          'idMoHinhTaiSan': AppUtility.s(cell(row, 6)),
          'tenMoHinh': AppUtility.s(cell(row, 7)),
          'idNhomTaiSan': AppUtility.s(cell(row, 8)),
          'tenNhom': AppUtility.s(cell(row, 9)),
          'idDuAn': AppUtility.s(cell(row, 10)),
          'tenDuAn': AppUtility.s(cell(row, 11)),
          'idNguonVon': AppUtility.s(cell(row, 12)),
          'tenNguonKinhPhi': AppUtility.s(cell(row, 13)),
          'phuongPhapKhauHao': int.tryParse(AppUtility.s(cell(row, 14))),
          'soKyKhauHao': int.tryParse(AppUtility.s(cell(row, 15))),
          'taiKhoanTaiSan': int.tryParse(AppUtility.s(cell(row, 16))),
          'taiKhoanKhauHao': int.tryParse(AppUtility.s(cell(row, 17))),
          'taiKhoanChiPhi': int.tryParse(AppUtility.s(cell(row, 18))),
          'ngayVaoSo': AppUtility.normalizeDateIsoString(cell(row, 19)),
          'ngaySuDung': AppUtility.normalizeDateIsoString(cell(row, 20)),
          'kyHieu': AppUtility.s(cell(row, 21)),
          'soKyHieu': AppUtility.s(cell(row, 22)),
          'congSuat': AppUtility.s(cell(row, 23)),
          'nuocSanXuat': AppUtility.s(cell(row, 24)),
          'namSanXuat': int.tryParse(AppUtility.s(cell(row, 25))),
          'lyDoTang': int.tryParse(AppUtility.s(cell(row, 26))),
          'hienTrang': int.tryParse(AppUtility.s(cell(row, 27))),
          'soLuong': int.tryParse(AppUtility.s(cell(row, 28))),
          'donViTinh': AppUtility.s(cell(row, 29)),
          'ghiChu': AppUtility.s(cell(row, 30)),
          'idDonViBanDau': AppUtility.s(cell(row, 31)),
          'idDonViHienThoi': AppUtility.s(cell(row, 32)),
          'moTa': AppUtility.s(cell(row, 33)),
          'idCongTy': AppUtility.s(cell(row, 34)),
          'ngayTao': AppUtility.normalizeDateIsoString(cell(row, 35)),
          'ngayCapNhat': AppUtility.normalizeDateIsoString(cell(row, 36)),
          'nguoiTao': AppUtility.s(cell(row, 37), fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(cell(row, 38), fallback: fallbackUser),
          'isActive': AppUtility.b(cell(row, 39)),
        };
        log('asset json2: ${jsonEncode(json)}');
        assetList.add(AssetManagementDto.fromJson(json));
      }
    }
  }

  return assetList;
}
