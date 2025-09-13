import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/model/dashboard_report.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class DashboardRepository extends ApiBase {
  Future<Map<String, dynamic>> getDashboardData() async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(EndPointAPI.DASHBOARD);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      DashboardReport dashboardData = DashboardReport.fromJson(response.data);
      result['data'] = dashboardData;
      SGLog.debug("Dashboard", jsonEncode(dashboardData));
    } catch (e) {
      SGLog.error(
        "Dashboard",
        "Error at getDashboardData - DashboardRepository: $e",
      );
    }

    return result;
  }
}
