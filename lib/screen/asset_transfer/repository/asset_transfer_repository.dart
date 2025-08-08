import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferRepository extends ApiBase {
  Future<Map<String, dynamic>> getListAssetTransfer(int typeAssetTransfer) async {
    List<AssetTransferDto> list = [];
    Map<String, dynamic> result = {'data': list, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await get(EndPointAPI.ASSET_TRANSFER, queryParameters: {'idcongty': 'ct001'});
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetTransferDto>(response.data, AssetTransferDto.fromJson);
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at getListAssetTransfer - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> postFromAssetTransfer(AssetTransferDto item) async {
    Map<String, dynamic> result = {'data': int, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);

      final response = await post(EndPointAPI.ASSET_TRANSFER, data: item.toJson());
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at getListAssetTransfer - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getListMovementDetail(String iddieudongtaisan) async {
    List<MovementDetailDto> list = [];
    Map<String, dynamic> result = {'data': list, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      final response = await get(
        EndPointAPI.CHI_TIET_DIEU_DONG_TAI_SAN,
        queryParameters: {'iddieudongtaisan': iddieudongtaisan},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<MovementDetailDto>(response.data, MovementDetailDto.fromJson);
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at getListMovementDetail - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> uploadFile(String filePath) async {
    Map<String, dynamic> result = {'data': '', 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      final fileName = filePath.split(RegExp(r'[\\/]+')).last;
      final formData = FormData.fromMap({'file': await MultipartFile.fromFile(filePath, filename: fileName)});

      final response = await post(
        EndPointAPI.UPLOAD_FILE,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at uploadFile - AssetTransferRepository: $e");
    }

    return result;
  }
}
