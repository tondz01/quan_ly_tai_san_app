import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
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

  Future<Map<String, dynamic>> getInventoryMinutes(String idDonVi, String ngayBanGiao) async {
    List<InventoryMinutes> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/baocaokiemketaisan',
        queryParameters: {'iddonvi': idDonVi, 'ngayBanGiao': ngayBanGiao},
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

  Future<Map<String, dynamic>> getInventoryReportToolsSupplies(String idDonVi, String ngayBanGiao) async {
    List<DieuDongTaiSanDto> list = [];
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
}