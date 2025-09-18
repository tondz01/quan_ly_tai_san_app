import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

String _sanitizeString(dynamic value, {String? fallback}) {
  final str = value?.toString().trim();
  if (str == null || str.isEmpty) {
    return (fallback ?? '').trim();
  }
  return str;
}

/// Convert excel serial date (days since 1899-12-30) to DateTime
DateTime _excelSerialToDate(num serial) {
  final base = DateTime(1899, 12, 30);
  return base.add(Duration(days: serial.floor(), milliseconds: (((serial % 1) * 24 * 60 * 60 * 1000)).round()));
}
extension DateTimeToMySQL on DateTime {
  String toMySQLFormat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this.toUtc());
  }
}


String _normalizeDateIso(dynamic value) {
  if (value == null) {
    return DateTime.now().toMySQLFormat();
  }
  if (value is DateTime) {
    return value.toMySQLFormat();
  }
  if (value is num) {
    return _excelSerialToDate(value).toMySQLFormat();
  }
  final text = value.toString().trim();
  if (text.isEmpty) {
    return DateTime.now().toMySQLFormat();
  }
  final parsed = DateTime.tryParse(text);
  if (parsed != null) {
    return parsed.toMySQLFormat();
  }
  return DateTime.now().toMySQLFormat();
}

Future<List<NhanVien>> convertExcelToNhanVien(String filePath) async {
  final bytes = File(filePath).readAsBytesSync();

  List<NhanVien> nhanVienList = [];

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
          "kyNhay": row[4]?.value ?? false,
          "kyThuong": row[5]?.value ?? false,
          "kySo": row[6]?.value ?? false,
          "chuKyNhay": row[7]?.value,
          "chuKyThuong": row[8]?.value,
          "agreementUUId": row[9]?.value,
          "pin": row[10]?.value,
          "phongBanId": row[11]?.value,
          "boPhan": row[12]?.value,
          "chucVu": row[13]?.value,
          "nguoiQuanLy": row[14]?.value,
          "laQuanLy": row[15]?.value ?? false,
          "avatar": row[16]?.value,
          "idCongTy": row[17]?.value,
          "diaChiLamViec": row[18]?.value,
          "hinhThucLamViec": row[19]?.value,
          "nguoiTao": _sanitizeString(
            row[20]?.value,
            fallback: AccountHelper.instance.getUserInfo()!.tenDangNhap,
          ),
          "nguoiCapNhat": _sanitizeString(
            row[21]?.value,
            fallback: AccountHelper.instance.getUserInfo()!.tenDangNhap,
          ),
          "ngayTao": _normalizeDateIso(row[22]?.value),
          "ngayCapNhat": _normalizeDateIso(row[23]?.value),
          "active": row[24]?.value ?? false,
        };
        log('json: ${jsonEncode(json)}');
        // Convert sang NhanVien
        nhanVienList.add(NhanVien.fromJson(json));
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
          "kyNhay": cell(row, 4) ?? false,
          "kyThuong": cell(row, 5) ?? false,
          "kySo": cell(row, 6) ?? false,
          "chuKyNhay": cell(row, 7),
          "chuKyThuong": cell(row, 8),
          "agreementUUId": cell(row, 9),
          "pin": cell(row, 10),
          "phongBanId": cell(row, 11),
          "boPhan": cell(row, 12),
          "chucVu": cell(row, 13),
          "nguoiQuanLy": cell(row, 14),
          "laQuanLy": cell(row, 15) ?? false,
          "avatar": cell(row, 16),
          "idCongTy": cell(row, 17),
          "diaChiLamViec": cell(row, 18),
          "hinhThucLamViec": cell(row, 19),
          "nguoiTao": _sanitizeString(
            cell(row, 20),
            fallback: AccountHelper.instance.getUserInfo()!.tenDangNhap,
          ),
          "nguoiCapNhat": _sanitizeString(
            cell(row, 21),
            fallback: AccountHelper.instance.getUserInfo()!.tenDangNhap,
          ),
          "ngayTao": _normalizeDateIso(cell(row, 22)),
          "ngayCapNhat": _normalizeDateIso(cell(row, 23)),
          "active": cell(row, 24) ?? false,
        };
        log('json2: ${jsonEncode(json)}');
        nhanVienList.add(NhanVien.fromJson(json));
      }
    }
  }

  return nhanVienList;
}
