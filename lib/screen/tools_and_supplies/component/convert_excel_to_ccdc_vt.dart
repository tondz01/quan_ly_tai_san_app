import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Map<String, dynamic> _validateRow(
  Map<String, dynamic> json,
  int rowIndex,
  ToolsAndSuppliesProvider? provider, {
  String soKyHieu = '',
  String congSuat = '',
  String nuocSanXuat = '',
  String soLuong = '',
  String namSanXuat = '',
  bool isDetail = false,
}) {
  List<String> rowErrors = [];

  List<PhongBan> phongBans = provider?.dataPhongBan ?? [];
  List<CcdcGroup> ccdcGroups = provider?.dataGroupCCDC ?? [];
  List<TypeCcdc> typeCcdcs = provider?.dataTypeCCDC ?? [];
  List<UnitDto> units = provider?.dataUnit ?? [];

  // Validate required fields
  if (json['id'] == null || json['id'].toString().trim().isEmpty) {
    rowErrors.add('Mã CCDC - Vật tư không được để trống');
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
    rowErrors.add('Tên CCDC - Vật tư không được để trống');
  }

  if (json['donViTinh'] == null ||
      json['donViTinh'].toString().trim().isEmpty) {
    rowErrors.add('Mã đơn vị tính không được để trống');
  } else {
    try {
      units.firstWhere((unit) => unit.id == json['donViTinh']);
    } catch (e) {
      rowErrors.add('Đơn vị tính không tồn tại ${json['donViTinh']}');
    }
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

  if (isDetail) {
    if (soKyHieu.isEmpty) {
      rowErrors.add('Số ký hiệu không được để trống');
    }
    if (congSuat.isEmpty) {
      rowErrors.add('Công suất không được để trống');
    }
    if (nuocSanXuat.isEmpty) {
      rowErrors.add('Nước sản xuất không được để trống');
    }
    if (soLuong.isEmpty) {
      rowErrors.add('Số lượng không được để trống');
    } else {
      try {
        int.tryParse(soLuong);
        if ((int.tryParse(soLuong) ?? 0) <= 0) {
          rowErrors.add('Số lượng phải lớn hơn 0');
        }
      } catch (e) {
        rowErrors.add('Số lượng không hợp lệ');
      }
    }

    if (namSanXuat.isEmpty) {
      rowErrors.add('Năm sản xuất không được để trống');
    } else {
      try {
        int.tryParse(namSanXuat);

        final currentYear = DateTime.now().year;

        if ((int.tryParse(namSanXuat) ?? 0) > currentYear) {
          rowErrors.add(
            'Năm sản xuất không được lớn hơn năm hiện tại ($currentYear)',
          );
        }
        if ((int.tryParse(namSanXuat) ?? 0) > 0 &&
            (int.tryParse(namSanXuat) ?? 0) < 1900) {
          rowErrors.add('Năm sản xuất không hợp lệ (phải >= 1900)');
        }
      } catch (e) {
        rowErrors.add('Năm sản xuất không hợp lệ');
      }
    }
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

  List<Map<String, dynamic>> errors = [];
  final Map<String, ToolsAndSuppliesDto> idToHeader = {};
  final Map<String, List<DetailAssetDto>> idToDetails = {};

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
          "ngayNhap": AppUtility.normalizeDateIsoString(
            row[3]?.value?.toString() ?? DateTime.now().toIso8601String(),
          ),
          "donViTinh": AppUtility.s(row[4]?.value),
          "soLuong": 0,
          "idNhomCCDC": AppUtility.s(row[5]?.value),
          "idLoaiCCDCCon": AppUtility.s(row[6]?.value),
          "giaTri": AppUtility.parseCurrency(
            AppUtility.s(row[7]?.value.toString() ?? '0'),
          ),
          "soKyHieu": "",
          "kyHieu": AppUtility.s(row[8]?.value),
          "congSuat": "",
          "nuocSanXuat": "",
          "namSanXuat": 0,
          "ghiChu": AppUtility.s(row[9]?.value),
          "idCongTy": "ct001",
          "ngayTao": AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
          "ngayCapNhat": AppUtility.formatFromISOString(
            DateTime.now().toIso8601String(),
          ),
          "nguoiTao": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "isActive": true,
        };

        final String id = AppUtility.s(json['id']);

        // Đọc cột chi tiết nếu file có (theo template export):
        final String soKyHieu = row[10]?.value?.toString() ?? '';
        final String soLuongStr = row[11]?.value?.toString() ?? '';
        final String congSuat = row[12]?.value?.toString() ?? '';
        final String nuocSanXuat = row[13]?.value?.toString() ?? '';
        final String namSanXuatStr = row[14]?.value?.toString() ?? '';

        final bool hasDetail =
            soKyHieu.isNotEmpty ||
            congSuat.isNotEmpty ||
            nuocSanXuat.isNotEmpty ||
            soLuongStr.isNotEmpty ||
            namSanXuatStr.isNotEmpty;

        // Validate row data
        final validation = _validateRow(
          json,
          rowIndex,
          provider,
          soKyHieu: soKyHieu,
          congSuat: congSuat,
          nuocSanXuat: nuocSanXuat,
          soLuong: soLuongStr,
          namSanXuat: namSanXuatStr,
          isDetail: hasDetail,
        );

        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          idToHeader.putIfAbsent(id, () => ToolsAndSuppliesDto.fromJson(json));
          if (hasDetail) {
            final detail = DetailAssetDto(
              id: "",
              idTaiSan: id,
              ngayVaoSo: AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
              ngaySuDung: AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
              soKyHieu: soKyHieu.isEmpty ? null : soKyHieu,
              congSuat: congSuat.isEmpty ? null : congSuat,
              nuocSanXuat: nuocSanXuat.isEmpty ? null : nuocSanXuat,
              soLuong: int.tryParse(soLuongStr) ?? 0,
              namSanXuat: int.tryParse(namSanXuatStr) ?? 0,
              idDonVi: json['idDonVi'],
            );
            idToDetails.putIfAbsent(id, () => []).add(detail);
          }
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
          "ngayNhap": AppUtility.formatFromISOString(
            cell(row, 3)?.toString() ?? DateTime.now().toString(),
          ),
          "donViTinh": cell(row, 4),
          "soLuong": 0,
          "idNhomCCDC": cell(row, 5),
          "idLoaiCCDCCon": cell(row, 6),
          "giaTri": AppUtility.parseCurrency(cell(row, 7)?.toString() ?? '0'),
          "soKyHieu": "",
          "kyHieu": cell(row, 8),
          "congSuat": "",
          "nuocSanXuat": "",
          "namSanXuat": 0,
          "ghiChu": cell(row, 9),
          "idCongTy": "ct001",
          "ngayTao": AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
          "ngayCapNhat": AppUtility.formatFromISOString(
            DateTime.now().toIso8601String(),
          ),
          "nguoiTao": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "nguoiCapNhat": AccountHelper.instance.getUserInfo()?.tenDangNhap,
          "isActive": true,
        };

        final String id = AppUtility.s(json['id']);

        // Đọc cột chi tiết nếu file có (theo template export):
        final String soKyHieu = cell(row, 10)?.toString() ?? '';
        final String soLuongStr = cell(row, 11)?.toString() ?? '';
        final String congSuat = cell(row, 12)?.toString() ?? '';
        final String nuocSanXuat = cell(row, 13)?.toString() ?? '';
        final String namSanXuatStr = cell(row, 14)?.toString() ?? '';

        final bool hasDetail =
            soKyHieu.isNotEmpty ||
            congSuat.isNotEmpty ||
            nuocSanXuat.isNotEmpty ||
            soLuongStr.isNotEmpty ||
            namSanXuatStr.isNotEmpty;

        // Validate row data
        final validation = _validateRow(
          json,
          rowIndex,
          provider,
          soKyHieu: soKyHieu,
          congSuat: congSuat,
          nuocSanXuat: nuocSanXuat,
          soLuong: soLuongStr,
          namSanXuat: namSanXuatStr,
          isDetail: hasDetail,
        );

        if (validation['hasError']) {
          errors.add({
            'row': rowIndex, // +1 because Excel rows start from 1
            'errors': validation['errors'],
            'data': json,
          });
        } else {
          idToHeader.putIfAbsent(id, () => ToolsAndSuppliesDto.fromJson(json));
          if (hasDetail) {
            final detail = DetailAssetDto(
              id: "",
              idTaiSan: id,
              ngayVaoSo: AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
              ngaySuDung: AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
              soKyHieu: soKyHieu.isEmpty ? null : soKyHieu,
              congSuat: congSuat.isEmpty ? null : congSuat,
              nuocSanXuat: nuocSanXuat.isEmpty ? null : nuocSanXuat,
              soLuong: int.tryParse(soLuongStr) ?? 0,
              namSanXuat: int.tryParse(namSanXuatStr) ?? 0,
              idDonVi: json['idDonVi'],
            );
            idToDetails.putIfAbsent(id, () => []).add(detail);
          }
        }
      }
    }
  }

  // Kết thúc: gắn chi tiết vào header và cập nhật result
  final List<ToolsAndSuppliesDto> headers = idToHeader.values.toList();
  for (final header in headers) {
    final id = header.id;
    header.chiTietTaiSanList = idToDetails[id] ?? [];
  }

  result['data'] = headers;
  result['errors'] = errors;

  if (errors.isNotEmpty) {
    result['success'] = false;
    result['message'] =
        'Có ${errors.length} dòng có lỗi. Vui lòng kiểm tra và sửa lại.';
  } else {
    result['success'] = true;
    result['message'] = 'Import thành công ${headers.length} CCDC-VT';
  }

  return result;
}
