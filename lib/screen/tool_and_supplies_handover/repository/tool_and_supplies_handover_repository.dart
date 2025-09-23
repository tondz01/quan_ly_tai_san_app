import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/reponsitory/update_ownership_unit.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolAndSuppliesHandoverRepository extends ApiBase {
  late final SignatoryRepository _signatoryRepository;

  ToolAndSuppliesHandoverRepository() {
    _signatoryRepository = SignatoryRepository();
  }

  Future<Map<String, dynamic>> getListToolAndSuppliesHandover() async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    List<ToolAndSuppliesHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/getbyuserid/${userInfo.tenDangNhap}",
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      List<ToolAndSuppliesHandoverDto> toolAndSuppliesHandover =
          ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
            response.data,
            ToolAndSuppliesHandoverDto.fromJson,
          );

      await Future.wait(
        toolAndSuppliesHandover.map((toolAndSuppliesHandover) async {
          try {
            final signatories = await _signatoryRepository.getAll(
              toolAndSuppliesHandover.id.toString(),
            );
            toolAndSuppliesHandover.listSignatory = signatories;
            log('signatories: ${jsonEncode(signatories)}');
          } catch (e) {
            toolAndSuppliesHandover.listSignatory = [];
          }
        }),
      );

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = toolAndSuppliesHandover;
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at getListToolAndSuppliesHandover - ToolAndSuppliesHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getListSuppliesHandoverByTransfer(
    String idTransfer,
  ) async {
    List<ToolAndSuppliesHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}?idcongty=$idTransfer",
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      List<ToolAndSuppliesHandoverDto> toolAndSuppliesHandover =
          ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
            response.data,
            ToolAndSuppliesHandoverDto.fromJson,
          );
      // await Future.wait(
      //   toolAndSuppliesHandover.map((toolAndSuppliesHandover) async {
      //     try {
      //       final detailSuppliesHandover = await getDetailSuppliesHandover(
      //         toolAndSuppliesHandover.id.toString(),
      //       );
      //       toolAndSuppliesHandover.detailSuppliesHandover =
      //           detailSuppliesHandover;
      //       log(
      //         'detailSuppliesHandover: ${jsonEncode(detailSuppliesHandover)}',
      //       );
      //     } catch (e) {
      //       toolAndSuppliesHandover.detailSuppliesHandover = [];
      //     }
      //   }),
      // );

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = toolAndSuppliesHandover;
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at getListToolAndSuppliesHandover - ToolAndSuppliesHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getDetailSuppliesHandover(
    String idbangiaoccdcvattu,
  ) async {
    List<ToolAndSuppliesHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.DETAIL_SUPPLIES_HANDOVER}?idbangiaoccdcvattu=$idbangiaoccdcvattu",
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      List<ToolAndSuppliesHandoverDto> toolAndSuppliesHandover =
          ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
            response.data,
            ToolAndSuppliesHandoverDto.fromJson,
          );

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = toolAndSuppliesHandover;
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at getListToolAndSuppliesHandover - ToolAndSuppliesHandoverRepository: $e",
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
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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
        "ToolAndSuppliesHandoverRepository",
        "Error at getListToolAndSuppliesHandover - ToolAndSuppliesHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createToolAndSuppliesHandover(
    Map<String, dynamic> request,
    List<SignatoryDto> listSignatory,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER,
        data: request,
      );

      final int? status = response.statusCode;
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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

        if (checkStatusCodeFailed(statusSignatory ?? 0)) {
          result['status_code'] =
              statusSignatory ?? Numeral.STATUS_CODE_DEFAULT;
          return result;
        }
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at createAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateToolAndSuppliesHandover(
    Map<String, dynamic> request,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER,
        data: request,
      );

      final int? status = response.statusCode;
      if (checkStatusCodeFailed(status ?? 0)) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteToolAndSuppliesHandover(String id) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        "${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/$id",
      );
      final int? status = response.statusCode;
      if (checkStatusCodeFailed(status ?? 0)) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at updateAsset - AssetManagementRepository: $e",
      );
    }

    return result;
  }

  //Cập nhập trạng thái phiếu ký nội sinh
  Future<Map<String, dynamic>> updateState(
    String id,
    String idDieuChuyen,
    String idNhanVien,
    List<Map<String, dynamic>> request,
    List<Map<String, dynamic>> requestQuantity,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/capnhattrangthai?id=$id&userId=$idNhanVien',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      final dynamic payload = response.data;

      // Lấy ra mã data (int) dù server trả Map hay int thô
      final int? dataCode =
          (payload is Map)
              ? int.tryParse(payload['data']?.toString() ?? '')
              : int.tryParse(payload.toString());

      // Lưu lại nếu cần
      result['data'] = payload;
      log('dataCode: $dataCode');
      if (dataCode == 3) {
        await UpdateOwnershipUnit().updateCCDTOwnershipQuantity(
          requestQuantity,
        );
        await updateStateBanGiao(idDieuChuyen, true);
      }
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  //Hủy phiếu ký nội sinh
  Future<Map<String, dynamic>> cancelToolAndSuppliesHandover(String id) async {
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
      result['data'] = ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
        response.data,
        ToolAndSuppliesHandoverDto.fromJson,
      );
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateStateBanGiao(
    String id,
    bool trangThaiBanGiao,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/update-trang-thai-ban-giao?id=$id&trangThaiBanGiao=$trangThaiBanGiao',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS ||
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT ||
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = response.data;
    } catch (e) {
      log(
        "Error at updateStateBanGiao - ToolAndMaterialTransferRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> sendToSigner(
    List<ToolAndSuppliesHandoverDto> items,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    UserInfoDTO currentUser = AccountHelper.instance.getUserInfo()!;
    final request =
        items
            .map(
              (item) => {
                "id": item.id,
                "idCongTy": currentUser.idCongTy,
                "banGiaoCCDCVatTu": item.banGiaoCCDCVatTu ?? '',
                "quyetDinhDieuDongSo": item.quyetDinhDieuDongSo ?? '',
                "lenhDieuDong": item.lenhDieuDong ?? '',
                "idDonViGiao": item.idDonViGiao ?? '',
                "idDonViNhan": item.idDonViNhan ?? '',
                "idLanhDao": item.idLanhDao ?? '',
                "idDaiDiendonviBanHanhQD": item.idDaiDiendonviBanHanhQD ?? '',
                "daXacNhan": item.daXacNhan,
                "idDaiDienBenGiao": item.idDaiDienBenGiao ?? '',
                "daiDienBenGiaoXacNhan": item.daiDienBenGiaoXacNhan,
                "idDaiDienBenNhan": item.idDaiDienBenNhan ?? '',
                "daiDienBenNhanXacNhan": item.daiDienBenNhanXacNhan,
                "trangThai": item.trangThai,
                "note": item.note ?? '',
                "nguoiTao": item.nguoiTao ?? '',
                "nguoiCapNhat": currentUser.tenDangNhap,
                "isActive": true,
                "ngayBanGiao": item.ngayBanGiao,
                "ngayTao": item.ngayTao,
                "ngayCapNhat": item.ngayCapNhat,
                "share": true,
                "tenFile": item.tenFile ?? '',
                "duongDanFile": item.duongDanFile ?? '',
              },
            )
            .toList();

    try {
      final response = await put(
        '${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/batch',
        data: jsonEncode(request),
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['data'] = response.data;
      } else {
        result['status_code'] = response.statusCode;
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
        "ToolAndSuppliesHandoverRepository",
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