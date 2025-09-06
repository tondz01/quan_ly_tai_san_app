import 'dart:async';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetHandoverRepository extends ApiBase {
  late final SignatoryRepository _signatoryRepository;

  AssetHandoverRepository() {
    _signatoryRepository = SignatoryRepository();
  }

  Future<Map<String, dynamic>> getListAssetHandover() async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    List<AssetHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.ASSET_TRANSFER}/getbyuserid/${userInfo.tenDangNhap}",
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      List<AssetHandoverDto> assetHandover =
          ResponseParser.parseToList<AssetHandoverDto>(
            response.data,
            AssetHandoverDto.fromJson,
          );
      await Future.wait(
        assetHandover.map((assetHandover) async {
          try {
            final signatories = await _signatoryRepository.getAll(
              assetHandover.id.toString(),
            );
            assetHandover.listSignatory = signatories;
          } catch (e) {
            assetHandover.listSignatory = [];
          }
        }),
      );
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = assetHandover;
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getListDetailAssetMobilization(String id) async {
    List<ChiTietDieuDongTaiSan> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CHI_TIET_DIEU_DONG_TAI_SAN,
        queryParameters: {'iddieudongtaisan': id},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<ChiTietDieuDongTaiSan>(
        response.data,
        ChiTietDieuDongTaiSan.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getListAssetHandover - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createAssetHandover(
    Map<String, dynamic> request,
    List<SignatoryDto> listSignatory,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(EndPointAPI.ASSET_TRANSFER, data: request);

      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }
      for (var signatory in listSignatory) {
        final signatoryCopy = signatory.copyWith(
          idTaiLieu: request['id'].toString(),
        );
        final responseSignatory = await post(
          EndPointAPI.SIGNATORY,
          data: signatoryCopy.toJson(),
        );
        final int? statusSignatory = responseSignatory.statusCode;
        final bool isOkSignatory =
            statusSignatory == Numeral.STATUS_CODE_SUCCESS ||
            statusSignatory == Numeral.STATUS_CODE_SUCCESS_CREATE ||
            statusSignatory == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
        if (!isOkSignatory) {
          result['status_code'] =
              statusSignatory ?? Numeral.STATUS_CODE_DEFAULT;
          return result;
        }
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at createAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetHandover(
    Map<String, dynamic> request,
    String id,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        "${EndPointAPI.ASSET_TRANSFER}/$id",
        data: request,
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
        "AssetHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetHandover(String id) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete("${EndPointAPI.ASSET_TRANSFER}/$id");
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
        "AssetHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  //Cập nhập trạng thái phiếu ký nội sinh
  Future<Map<String, dynamic>> updateState(String id, String idNhanVien) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.ASSET_TRANSFER}/capnhattrangthai?id=$id&userId=$idNhanVien',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
        response.data,
        AssetHandoverDto.fromJson,
      );
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  //Hủy phiếu ký nội sinh
  Future<Map<String, dynamic>> cancelAssetHandover(String id) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.ASSET_TRANSFER}/huytrangthai?id=$id',
      );
      unawaited(delete('/api/chuky/$id'));

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
        response.data,
        AssetHandoverDto.fromJson,
      );
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> sendToSigner(
    List<AssetHandoverDto> items,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    UserInfoDTO currentUser = AccountHelper.instance.getUserInfo()!;
    try {
      for (var item in items) {
        final Map<String, dynamic> request = {
          "id": item.id,
          "idCongTy": item.idCongTy ?? '',
          "banGiaoTaiSan": item.banGiaoTaiSan ?? '',
          "quyetDinhDieuDongSo": item.quyetDinhDieuDongSo ?? '',
          "lenhDieuDong": item.lenhDieuDong ?? '',
          "idDonViGiao": item.idDonViGiao ?? '',
          "idDonViNhan": item.idDonViNhan ?? '',
          "ngayBanGiao": item.ngayBanGiao ?? '',
          "idLanhDao": item.idLanhDao ?? '',
          "idDaiDiendonviBanHanhQD": item.idDaiDiendonviBanHanhQD ?? '',
          "daXacNhan": item.daXacNhan ?? '',
          "idDaiDienBenGiao": item.idDaiDienBenGiao ?? '',
          "daiDienBenGiaoXacNhan": item.daiDienBenGiaoXacNhan ?? '',
          "idDaiDienBenNhan": item.idDaiDienBenNhan ?? '',
          "daiDienBenNhanXacNhan": item.daiDienBenNhanXacNhan ?? '',
          "idDonViDaiDien": item.idDonViDaiDien ?? '',
          "donViDaiDienXacNhan": item.donViDaiDienXacNhan ?? '',
          "trangThai": item.trangThai ?? '',
          "note": item.note ?? '',
          "ngayTao": item.ngayTao ?? '',
          "ngayCapNhat": DateTime.now().toIso8601String(),
          "nguoiTao": item.nguoiTao ?? '',
          "nguoiCapNhat": currentUser.tenDangNhap,
          "isActive": item.isActive ?? '',
          "share": true,
          "tenFile": item.tenFile ?? '',
          "duongDanFile": item.duongDanFile ?? '',
        };
        final response = await put(
          '${EndPointAPI.ASSET_TRANSFER}/${item.id}',
          data: request,
        );
        if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
          result['data'] = response.data;
        } else {
          result['status_code'] = response.statusCode;
        }
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
    } catch (e) {
      log("Error at getDataDropdown - DropdownItemReponsitory: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateOwnershipUnit(
    Map<String, dynamic> request,
    String id,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        "${EndPointAPI.OWNERSHIP_UNIT_DETAIL}/update-so-luong",
        data: request,
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
        "AssetHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }
}
// curl bàn giao ccdc-vt
// curl -X POST "http://localhost:8080/api/bangiaoccdcvattu/capnhatky/" \
//      -H "Content-Type: application/x-www-form-urlencoded" \
//      -d "userId=12345" \
//      -d "docId=67890"