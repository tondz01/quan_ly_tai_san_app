import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class DashboardRepository extends ApiBase {
  Future<Map<String, dynamic>> getListDieuDongTaiSan({int? type = -1}) async {
    Map<String, dynamic> data = {};
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(EndPointAPI.DASHBOARD);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = result['data'];
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }
}
