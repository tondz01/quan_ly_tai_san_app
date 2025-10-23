import 'dart:developer';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class TaiSanCoDinhRepository extends ApiBase {
  // Get list tài sản cố định
  Future<Map<String, dynamic>> getListTaiSanCoDinh(String idDonVi) async {
    List<TaiSanCoDinhDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.BAO_CAO}/taisancodinh',
        queryParameters: {'iddonvi': idDonVi},
      );
      log('response: ${response.data}');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<TaiSanCoDinhDto>(
        response.data,
        TaiSanCoDinhDto.fromJson,
      );
    } catch (e) {
      log("Error at getListTaiSanCoDinh - TaiSanCoDinhRepository: $e");
    }

    return result;
  }
}
