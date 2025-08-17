import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetHandoverRepository extends ApiBase {
  Future<Map<String, dynamic>> getListAssetHandover() async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    List<AssetHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.ASSET_TRANSFER}/getbyuserid/${userInfo.id}",
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
        response.data,
        AssetHandoverDto.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getListDetailAssetMobilization(String id) async {
    List<ChiTietDieuDongTaiSan> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CHI_TIET_DIEU_DONG_TAI_SAN,
        queryParameters: {'iddieudongtaisan': id},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<ChiTietDieuDongTaiSan>(
        response.data,
        ChiTietDieuDongTaiSan.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createAssetHandover(
    Map<String, dynamic> request,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(EndPointAPI.ASSET_TRANSFER, data: request);

      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at createAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetHandover(
    Map<String, dynamic> request,
    String id,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        "${EndPointAPI.ASSET_TRANSFER}/$id",
        data: request,
      );
      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetHandover(String id) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete("${EndPointAPI.ASSET_TRANSFER}/$id");
      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }
}
