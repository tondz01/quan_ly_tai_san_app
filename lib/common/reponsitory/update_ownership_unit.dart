import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class UpdateOwnershipUnit extends ApiBase {

  Future<Map<String, dynamic>> updateOwnershipUnit(
    List<OwnershipUnitDetailDto> request,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        "chitietdonvisohuu/batch",
        data: jsonEncode(request),
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
        "UpdateOwnershipUnitRepository",
        "Error at updateOwnershipUnit - UpdateOwnershipUnitRepository: $e",
      );
    }

    return result;
  }
}
