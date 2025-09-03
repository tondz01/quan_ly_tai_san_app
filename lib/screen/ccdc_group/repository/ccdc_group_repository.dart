import 'dart:async';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CcdcGroupRepository extends ApiBase {
  Future<Map<String, dynamic>> getListCcdcGroupRepository(
    String idCongTy,
  ) async {
    List<CcdcGroup> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CCDC_GROUP,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<CcdcGroup>(
        response.data,
        CcdcGroup.fromJson,
      );
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at getCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createCcdcGroupRepository(
    CcdcGroup params,
  ) async {
    CcdcGroup? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.CCDC_GROUP,
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = CcdcGroup.fromJson(response.data);
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at createCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateCcdcGroupRepository(
    CcdcGroup params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.CCDC_GROUP}/$id',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at updateCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCcdcGroupRepository(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.CCDC_GROUP}/$id');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at deleteCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }
}
