import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class UpdateOwnershipUnit extends ApiBase {
  Future<Map<String, dynamic>> updateAssetOwnership(
    List<Map<String, dynamic>> request,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.ASSET_MANAGEMENT}/updatedonvi',
        data: request,
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = response.data;
    } catch (e) {
      log("Error at update ownership unit: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateCCDTOwnership(
    List<Map<String, dynamic>> request,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.OWNERSHIP_UNIT_DETAIL}/batch',
        data: request,
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = response.data;
    } catch (e) {
      log("Error at update ownership unit: $e");
    }

    return result;
  }
}
