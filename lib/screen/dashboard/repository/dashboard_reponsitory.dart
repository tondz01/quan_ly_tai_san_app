import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class DashboardRepository extends ApiBase {
  Future<Map<String, dynamic>> getDashboardData() async {
    Map<String, dynamic> result = {
      'data': {},
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD);
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final jsonRes = response.data;
        result['data'] = jsonRes['data'] ?? {};
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      } else {
        result['status_code'] = response.statusCode;
        result['data'] = {};
      }
    } catch (e) {
      SGLog.error(
        "Dashboard",
        "Error at getDashboardData - DashboardRepository: $e",
      );
      result['status_code'] = 400;
      result['data'] = {};
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetStatusData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD_ASSET_STATUS);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? [];
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "AssetStatus",
        "Asset status data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "AssetStatus",
        "Error at getAssetStatusData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> getCcdcStatusData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD_CCDC_STATUS);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? [];
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "CcdcStatus",
        "CCDC status data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "CcdcStatus",
        "Error at getCcdcStatusData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetGroupDistributionData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.DASHBOARD_ASSET_GROUP_DISTRIBUTION,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? {};
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "AssetGroupDistribution",
        "Asset group distribution data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "AssetGroupDistribution",
        "Error at getAssetGroupDistributionData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> getCcdcGroupDistributionData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD_CCDC_GROUP_DISTRIBUTION);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? {};
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "CcdcGroupDistribution",
        "CCDC group distribution data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "CcdcGroupDistribution",
        "Error at getCcdcGroupDistributionData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetDepreciationData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD_ASSET_DEPRECIATION);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? [];
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "AssetDepreciation",
        "Asset depreciation data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "AssetDepreciation",
        "Error at getAssetDepreciationData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetGroupPercentageData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD_ASSET_GROUP_PERCENTAGE);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? [];
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "AssetGroupPercentage",
        "Asset group percentage data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "AssetGroupPercentage",
        "Error at getAssetGroupPercentageData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> getCcdcGroupPercentageData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.DASHBOARD_CCDC_GROUP_PERCENTAGE);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? 'API trả về lỗi';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data['data'] ?? [];
      result['message'] = response.data['message'] ?? 'Thành công';

      SGLog.debug(
        "CcdcGroupPercentage",
        "CCDC group percentage data: ${jsonEncode(result['data'])}",
      );
    } catch (e) {
      SGLog.error(
        "CcdcGroupPercentage",
        "Error at getCcdcGroupPercentageData - DashboardRepository: $e",
      );
      result['status_code'] = 0;
      result['message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }
}
