import 'package:quan_ly_tai_san_app/common/model/config_dto.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ConfigReponsitory extends ApiBase {
  Future<Map<String, dynamic>> getConfigTimeExpire() async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    Map<String, dynamic> result = {
      'data': 0,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };
    try {
      final response = await get('${EndPointAPI.CONFIG}/${userInfo.id}');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      AccountHelper.instance.setConfigTimeExpire(
        response.data['thoiHanTaiLieu'],
      );
      SGLog.info(
        "ConfigRepository",
        "Get config time expire success: ${response.data['thoiHanTaiLieu']}",
      );
      result['data'] = response.data['thoiHanTaiLieu'] ?? 0;
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
      result['message'] = e.toString();
    }
    return result;
  }

  Future<Map<String, dynamic>> setConfigTimeExpire(
    Map<String, dynamic> body,
  ) async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };
    body['idAccount'] = userInfo.id;

    try {
      final response = await post(EndPointAPI.CONFIG, data: body);
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      ConfigDto config = ConfigDto.fromJson(body);
      SGLog.info("ConfigRepository", "Set config time expire success: $config");
      AccountHelper.instance.setConfigTimeExpire(config);
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
      result['message'] = e.toString();
      result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
    }
    SGLog.debug("ConfigRepository", "result: $result");
    return result;
  }

  Future<Map<String, dynamic>> updateConfigTimeExpire(
    Map<String, dynamic> body,
  ) async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };
    body['idAccount'] = userInfo.id;
    try {
      final response = await put(
        '${EndPointAPI.CONFIG}/${userInfo.id}',
        data: body,
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      ConfigDto config = ConfigDto.fromJson(response.data);
      SGLog.info(
        "ConfigRepository",
        "Update config time expire success: $config",
      );
      AccountHelper.instance.setConfigTimeExpire(config);
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
      result['message'] = e.toString();
    }
    return result;
  }
}
