import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
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

Map<String, dynamic> _validateRow(
  Map<String, dynamic> json,
  int rowIndex,
  ToolsAndSuppliesProvider? provider,
) {
  List<String> rowErrors = [];

  List<PhongBan> phongBans = provider?.dataPhongBan ?? [];
  List<CcdcGroup> ccdcGroups = provider?.dataGroupCCDC ?? [];
  List<TypeCcdc> typeCcdcs = provider?.dataTypeCCDC ?? [];

  log('[_validateRow] json: ${jsonEncode(json)}');
  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã CCDC không được để trống');
  }

  if (json['idDonVi'] == null || json['idDonVi'].toString().trim().isEmpty) {
    rowErrors.add('Đơn vị không được để trống');
  } else {
    try {
      phongBans.firstWhere((phongBan) => phongBan.id == json['idDonVi']);
    } catch (e) {
      rowErrors.add('Đơn vị không tồn tại ${json['idDonVi']}');
    }
  }

  if (json['ten'] == null || json['ten'].toString().trim().isEmpty) {
    rowErrors.add('Tên CCDC không được để trống');
  }

  if (json['ngayNhap'] == null || json['ngayNhap'].toString().trim().isEmpty) {
    rowErrors.add('Ngày nhập không được để trống');
  } else {
    try {
      DateTime.parse(json['ngayNhap'].toString());
    } catch (e) {
      rowErrors.add('Ngày nhập không hợp lệ ${json['ngayNhap']}');
    }
  }

  if (json['donViTinh'] == null ||
      json['donViTinh'].toString().trim().isEmpty) {
    rowErrors.add('Đơn vị tính không được để trống');
  }

  if (json['idNhomCCDC'] == null ||
      json['idNhomCCDC'].toString().trim().isEmpty) {
    rowErrors.add('Nhóm CCDC không được để trống');
  } else {
    try {
      ccdcGroups.firstWhere((ccdcGroup) => ccdcGroup.id == json['idNhomCCDC']);
    } catch (e) {
      rowErrors.add('Nhóm CCDC không tồn tại ${json['idNhomCCDC']}');
    }
  }
  if (json['idLoaiCCDCCon'] == null ||
      json['idLoaiCCDCCon'].toString().trim().isEmpty) {
    rowErrors.add('Loại CCDC không được để trống');
  } else {
    try {
      typeCcdcs.firstWhere((typeCcdc) => typeCcdc.id == json['idLoaiCCDCCon']);
    } catch (e) {
      rowErrors.add('Loại CCDC không tồn tại ${json['idLoaiCCDCCon']}');
    }
  }

  if (json['giaTri'] == null || json['giaTri'].toString().trim().isEmpty) {
    rowErrors.add('Giá trị không được để trống');
  } else {
    try {
      double.parse(json['giaTri'].toString());
    } catch (e) {
      rowErrors.add('Giá trị không hợp lệ');
    }
    if (json['giaTri'] <= 0) {
      rowErrors.add('Giá trị phải lớn hơn 0');
    }
  }

  if (json['idCongTy'] == null || json['idCongTy'].toString().trim().isEmpty) {
    rowErrors.add('Công ty không được để trống');
  }

  return {'hasError': rowErrors.isNotEmpty, 'errors': rowErrors};
}

Future<Map<String, dynamic>> convertExcelToCcdcVt(
  String filePath, {
  Uint8List? fileBytes,
  ToolsAndSuppliesProvider? provider,
}) async {
  final bytes = fileBytes ?? File(filePath).readAsBytesSync();

  Map<String, dynamic> result = {
    "success": true,
    "message": "",
    "data": [],
    "errors": [],
  };

  List<ToolsAndSuppliesDto> ccdcVts = [];
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
          "idDonVi": AppUtility.s(row[1]?.value),
          "ten": AppUtility.s(row[2]?.value),
          "ngayNhap": AppUtility.normalizeDateIsoString(row[3]?.value),
          "donViTinh": AppUtility.s(row[4]?.value),
          "soLuong": 0,
          "idNhomCCDC": AppUtility.s(row[5]?.value),
          "idLoaiCCDCCon": AppUtility.s(row[6]?.value),
          "giaTri": AppUtility.parseCurrency(
            AppUtility.s(row[7]?.value.toString()),
          ),
          "soKyHieu": "",
          "kyHieu": AppUtility.s(row[8]?.value),
          "congSuat": "",
          "nuocSanXuat": "",
          "namSanXuat": 0,
          "ghiChu": AppUtility.s(row[9]?.value),
          "idCongTy": AppUtility.s(row[10]?.value ?? "ct001"),
          "ngayTao": AppUtility.normalizeDateIsoString(row[11]?.value),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(row[12]?.value),
          "nguoiTao": AppUtility.s(
            row[13]?.value,
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "nguoiCapNhat": AppUtility.s(
            row[14]?.value,
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "isActive": row[15]?.value ?? true,
        };

        // Validate row data
        final validation = _validateRow(json, rowIndex, provider);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          ccdcVts.add(ToolsAndSuppliesDto.fromJson(json));
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
          "idDonVi": cell(row, 1),
          "ten": cell(row, 2),
          "ngayNhap": AppUtility.normalizeDateIsoString(cell(row, 3)),
          "donViTinh": cell(row, 4),
          "soLuong": 0,
          "idNhomCCDC": cell(row, 5),
          "idLoaiCCDCCon": cell(row, 6),
          "giaTri": AppUtility.parseCurrency(cell(row, 7).toString()),
          "soKyHieu": "",
          "kyHieu": cell(row, 8),
          "congSuat": "",
          "nuocSanXuat": "",
          "namSanXuat": 0,
          "ghiChu": cell(row, 9),
          "idCongTy": cell(row, 10) ?? "ct001",
          "ngayTao": AppUtility.normalizeDateIsoString(cell(row, 11)),
          "ngayCapNhat": AppUtility.normalizeDateIsoString(cell(row, 12)),
          "nguoiTao": AppUtility.s(
            cell(row, 13),
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "nguoiCapNhat": AppUtility.s(
            cell(row, 14),
            fallback: AccountHelper.instance.getUserInfo()?.tenDangNhap,
          ),
          "isActive": cell(row, 15) ?? true,
        };

        // Validate row data
        final validation = _validateRow(json, rowIndex, provider);
        if (validation['hasError']) {
          errors.add({
            'row': rowIndex + 1, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          ccdcVts.add(ToolsAndSuppliesDto.fromJson(json));
        }
      }
    }
  }

  // Update result
  result['data'] = ccdcVts;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${ccdcVts.length} mô hình tài sản.';
  }

  return result;
}
