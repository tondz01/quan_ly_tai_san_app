import 'dart:developer';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/report/widget/SeGayComponent/lib/core/utils/sg_log.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class AssetManagementRepository extends ApiBase {
  Future<Map<String, dynamic>> createAssetDetail(String params) async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    SGLog.debug("_saveItem 2", params);
    try {
      final response = await post(EndPointAPI.CHI_TIET_TAI_SAN, data: params);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data?['message'] ?? 'Unknown error';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      result['status_code'] = 500;
      result['message'] = e.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetDetail(String params) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(EndPointAPI.CHI_TIET_TAI_SAN, data: params);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data?['message'] ?? 'Unknown error';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateToolsAndSupplies - ToolsAndSuppliesRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetDetail(String params) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(EndPointAPI.CHI_TIET_TAI_SAN, data: params);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data?['message'] ?? 'Unknown error';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      result['status_code'] = 500;
      result['message'] = e.toString();
    }

    return result;
  }
}
