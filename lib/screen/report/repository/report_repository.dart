import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/ccdc_inventory_report.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tang_giam_trong_ky_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import '../../../core/constants/numeral.dart';
import '../../../core/network/Services/end_point_api.dart';
import '../../../core/utils/response_parser.dart';

class ReportRepository extends ApiBase {
  Future<Map<String, dynamic>> getReportAsset(String idCongTy, int loai) async {
    List<DieuDongTaiSanDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/dieudongtaisan',
        queryParameters: {'idcongty': idCongTy, 'loai': loai},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<DieuDongTaiSanDto>(
        response.data,
        DieuDongTaiSanDto.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  /// Lấy danh sách biên bản kiểm kê (gộp cả TaiSan và CCDCVatTu)
  /// API: GET /api/baocao/bienban-kiemke?idPhongBan={idPhongBan}
  Future<Map<String, dynamic>> getInventoryMinutes(
    String idPhongBan,
    String ngayBanGiao,
  ) async {
    List<InventoryMinutes> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/bienban-kiemke',
        queryParameters: {'idPhongBan': idPhongBan},
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<InventoryMinutes>(
        response.data,
        InventoryMinutes.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "ReportRepository",
        "Error at getInventoryMinutes: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getInventoryReportToolsSupplies(
    String idDonVi,
    String ngayBanGiao,
  ) async {
    List<CCDCInventoryReport> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/baocaokiemkeccdc',
        queryParameters: {'iddonvi': idDonVi, 'ngayBanGiao': ngayBanGiao},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<CCDCInventoryReport>(
        response.data,
        CCDCInventoryReport.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getS22DnReport(
    String idDonVi,
    String nam,
  ) async {
    Map<String, dynamic> result = {
      'data': {},
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/s22dn',
        queryParameters: {'iddonvi': idDonVi, 'nam': nam},
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("ReportRepository", "Error at getS22DnReport: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getS22DnReportCCDC(
    String idDonVi,
    String nam,
  ) async {
    Map<String, dynamic> result = {
      'data': {},
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/s22dn-ccdc',
        queryParameters: {'iddonvi': idDonVi, 'nam': nam},
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("ReportRepository", "Error at getS22DnReportCCDC: $e");
    }

    return result;
  }

  /// Lấy báo cáo tăng giảm trong kỳ (Mẫu số 01)
  /// API: GET /api/baocao/tang-giam-trong-ky?idPhongBan={idPhongBan}&denNgay={denNgay}
  /// Trả về danh sách gộp cả TaiSan và CCDCVatTu
  Future<Map<String, dynamic>> getTangGiamTrongKy(
    String idPhongBan,
    String denNgay,
  ) async {
    List<TangGiamTrongKyDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final Map<String, dynamic> queryParams = {
        'denNgay': denNgay,
      };
      if (idPhongBan.isNotEmpty) {
        queryParams['idPhongBan'] = idPhongBan;
      }

      final response = await get(
        '${EndPointAPI.BAO_CAO}/tang-giam-trong-ky',
        queryParameters: queryParams,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<TangGiamTrongKyDto>(
        response.data,
        TangGiamTrongKyDto.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "ReportRepository",
        "Error at getTangGiamTrongKy: $e",
      );
    }

    return result;
  }
}
