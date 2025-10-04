import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

Future<List<AssetManagementDto>> convertExcelToAsset({
  Uint8List? bytes, 
  String? filePath,
  BuildContext? context,
}) async {
  final Uint8List fileBytes;
  if (bytes != null) {
    fileBytes = bytes;
  } else if (filePath != null && filePath.isNotEmpty) {
    // Only used on non-web platforms
    fileBytes = File(filePath).readAsBytesSync();
  } else {
    throw ArgumentError('Either bytes or filePath must be provided');
  }
  final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';

  List<AssetManagementDto> assetList = [];

  try {
    final excel = Excel.decodeBytes(fileBytes);

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      // Skip header (row 0)
      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final vonNS = AppUtility.parseCurrency(AppUtility.s(row[11]?.value));
        final vonVay = AppUtility.parseCurrency(AppUtility.s(row[12]?.value));
        final vonKhac = AppUtility.parseCurrency(AppUtility.s(row[13]?.value));
        final totalNguyenGia = vonNS + vonVay + vonKhac;
        final json = <String, dynamic>{
          'id': AppUtility.s(row[0]?.value),
          'soThe': AppUtility.s(row[1]?.value),
          'tenTaiSan': AppUtility.s(row[2]?.value),
          'nguyenGia': totalNguyenGia,
          'giaTriKhauHaoBanDau': AppUtility.parseCurrency(AppUtility.s(row[3]?.value)),
          'kyKhauHaoBanDau': int.tryParse(AppUtility.s(row[4]?.value)),
          'giaTriThanhLy': AppUtility.parseCurrency(AppUtility.s(row[5]?.value)),
          'idMoHinhTaiSan': AppUtility.s(row[6]?.value),
          'idNhomTaiSan': AppUtility.s(row[7]?.value),
          'idLoaiTaiSanCon': AppUtility.s(row[8]?.value),
          'idDuAn': AppUtility.s(row[9]?.value),
          // 'idNguonVon': '',`
          'vonNS': AppUtility.parseCurrency(AppUtility.s(row[10]?.value)),
          'vonVay': AppUtility.parseCurrency(AppUtility.s(row[11]?.value)),
          'vonKhac': AppUtility.parseCurrency(AppUtility.s(row[12]?.value)),
          'phuongPhapKhauHao': int.tryParse(AppUtility.s(row[13]?.value)),
          'soKyKhauHao': int.tryParse(AppUtility.s(row[14]?.value)),
          'taiKhoanTaiSan': int.tryParse(AppUtility.s(row[15]?.value)),
          'taiKhoanKhauHao': int.tryParse(AppUtility.s(row[16]?.value)),
          'taiKhoanChiPhi': int.tryParse(AppUtility.s(row[17]?.value)),
          'ngayVaoSo': AppUtility.normalizeDateIsoStringV2(row[18]?.value),
          'ngaySuDung': AppUtility.normalizeDateIsoStringV2(row[19]?.value),
          'kyHieu': AppUtility.s(row[20]?.value),
          'soKyHieu': AppUtility.s(row[21]?.value),
          'congSuat': AppUtility.s(row[22]?.value),
          'nuocSanXuat': AppUtility.s(row[23]?.value),
          'namSanXuat': int.tryParse(AppUtility.s(row[24]?.value)),
          'lyDoTang': AppUtility.s(row[25]?.value),
          'hienTrang': int.tryParse(AppUtility.s(row[26]?.value)),
          'soLuong': 1,
          'donViTinh': AppUtility.s(row[28]?.value),
          'ghiChu': AppUtility.s(row[29]?.value),
          'idDonViBanDau': AppUtility.s(row[30]?.value),
          'idDonViHienThoi': AppUtility.s(row[31]?.value),
          'moTa': AppUtility.s(row[32]?.value),
          'idCongTy': 'ct001',
          'ngayTao': AppUtility.normalizeDateIsoStringV2(row[33]?.value),
          'ngayCapNhat': AppUtility.normalizeDateIsoStringV2(row[34]?.value),
          'nguoiTao': AppUtility.s(row[35]?.value, fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(row[36]?.value, fallback: fallbackUser),
          'isActive': true,
          'isTaiSanCon': false,
        };
        log('asset json: ${jsonEncode(json)}');
        assetList.add(AssetManagementDto.fromJson(json));
      }
    }
  } catch (e) {
    // Fallback for tricky files
    final decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: false);
    for (final t in decoder.tables.keys) {
      final sheet = decoder.tables[t];
      if (sheet == null) continue;

      dynamic cell(List row, int idx) => idx < row.length ? row[idx] : null;

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final vonNS = AppUtility.parseCurrency(AppUtility.s(cell(row, 11)));
        final vonVay = AppUtility.parseCurrency(AppUtility.s(cell(row, 12)));
        final vonKhac = AppUtility.parseCurrency(AppUtility.s(cell(row, 13)));
        final totalNguyenGia = vonNS + vonVay + vonKhac;
        final json = <String, dynamic>{
          'id': AppUtility.s(cell(row, 1)),
          'soThe': AppUtility.s(cell(row, 0)),
          'tenTaiSan': AppUtility.s(cell(row, 2)),
          'nguyenGia': totalNguyenGia,
          'giaTriKhauHaoBanDau': AppUtility.parseCurrency(AppUtility.s(cell(row, 3))),
          'kyKhauHaoBanDau': int.tryParse(AppUtility.s(cell(row, 4))),
          'giaTriThanhLy': AppUtility.parseCurrency(AppUtility.s(cell(row, 5))),
          'idMoHinhTaiSan': AppUtility.s(cell(row, 6)),
          'idNhomTaiSan': AppUtility.s(cell(row, 7)),
          'idLoaiTaiSanCon': AppUtility.s(cell(row, 8)),
          'idDuAn': AppUtility.s(cell(row, 9)),
          // 'idNguonVon': AppUtility.s(cell(row, 11)),
          'nvNS': AppUtility.parseCurrency(AppUtility.s(cell(row, 10))),
          'vonVay': AppUtility.parseCurrency(AppUtility.s(cell(row, 11))),
          'vonKhac': AppUtility.parseCurrency(AppUtility.s(cell(row, 12))),
          'phuongPhapKhauHao': int.tryParse(AppUtility.s(cell(row, 13))),
          'soKyKhauHao': int.tryParse(AppUtility.s(cell(row, 14))),
          'taiKhoanTaiSan': int.tryParse(AppUtility.s(cell(row, 15))),
          'taiKhoanKhauHao': int.tryParse(AppUtility.s(cell(row, 16))),
          'taiKhoanChiPhi': int.tryParse(AppUtility.s(cell(row, 17))),
          'ngayVaoSo': AppUtility.normalizeDateIsoStringV2(cell(row, 18)),
          'ngaySuDung': AppUtility.normalizeDateIsoStringV2(cell(row, 19)),
          'kyHieu': AppUtility.s(cell(row, 20)),
          'soKyHieu': AppUtility.s(cell(row, 21)),
          'congSuat': AppUtility.s(cell(row, 22)),
          'nuocSanXuat': AppUtility.s(cell(row, 23)),
          'namSanXuat': int.tryParse(AppUtility.s(cell(row, 24))),
          'lyDoTang': AppUtility.s(cell(row, 25)),
          'hienTrang': int.tryParse(AppUtility.s(cell(row, 26))),
          'soLuong': 1,
          'donViTinh': AppUtility.s(cell(row, 28)),
          'ghiChu': AppUtility.s(cell(row, 29)),
          'idDonViBanDau': AppUtility.s(cell(row, 30)),
          'idDonViHienThoi': AppUtility.s(cell(row, 31)),
          'moTa': AppUtility.s(cell(row, 32)),
          'idCongTy': 'ct001',
          'ngayTao': AppUtility.normalizeDateIsoStringV2(cell(row, 33)),
          'ngayCapNhat': AppUtility.normalizeDateIsoStringV2(cell(row, 34)),
          'nguoiTao': AppUtility.s(cell(row, 35), fallback: fallbackUser),
          'nguoiCapNhat': AppUtility.s(cell(row, 34), fallback: fallbackUser),
          'isActive': true,
          'isTaiSanCon': false,
        };
        log('asset json2: ${jsonEncode(json)}');
        assetList.add(AssetManagementDto.fromJson(json));
      }
    }
  }

  return assetList;
}