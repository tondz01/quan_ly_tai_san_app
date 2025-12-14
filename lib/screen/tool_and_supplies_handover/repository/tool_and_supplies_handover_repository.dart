import 'dart:async';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/reponsitory/update_ownership_unit.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
// import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolAndSuppliesHandoverRepository extends ApiBase {
  // late final SignatoryRepository _signatoryRepository;

  ToolAndSuppliesHandoverRepository() {
    // _signatoryRepository = SignatoryRepository();
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

      List<ToolAndSuppliesHandoverDto> handoverList =
          ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
            response.data,
            ToolAndSuppliesHandoverDto.fromJson,
          );
      AccountHelper.instance.clearToolAndSuppliesHandover();
      AccountHelper.instance.setToolAndMaterialHandover(handoverList);
      AccountHelper.refreshAllCounts();
      // Tối ưu: Gọi song song cả signatory và detail supplies trong cùng một Future.wait
      // await Future.wait(
      //   handoverList.map((item) async {
      //     await Future.wait([
      //       // Load signatories
      //       _loadSignatories(item),
      //       // Load detail supplies handover
      //       _loadDetailSupplies(item),
      //     ]);
      //   }),
      // );

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = handoverList;
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at getListToolAndSuppliesHandover - ToolAndSuppliesHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getAllToolSupHandoverStatus({
    int status = 3,
  }) async {
    List<ToolAndSuppliesHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/getbystatus?trangthai=$status",
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      List<ToolAndSuppliesHandoverDto> handoverList =
          ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
            response.data,
            ToolAndSuppliesHandoverDto.fromJson,
          );
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = handoverList;
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

  Future<Map<String, dynamic>> getChiTietBanGiaoCCDCVatTu({
    String? idbangiaoccdcvattu,
    String? iddieudongccdcvattu,
  }) async {
    List<DetailSubppliesHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      // Build query parameters
      Map<String, String> queryParams = {};
      if (idbangiaoccdcvattu != null && idbangiaoccdcvattu.isNotEmpty) {
        queryParams['idbangiaoccdcvattu'] = idbangiaoccdcvattu;
      }
      if (iddieudongccdcvattu != null && iddieudongccdcvattu.isNotEmpty) {
        queryParams['iddieudongccdcvattu'] = iddieudongccdcvattu;
      }

      final response = await get(
        EndPointAPI.DETAIL_SUPPLIES_HANDOVER,
        queryParameters: queryParams,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      List<DetailSubppliesHandoverDto> chiTietBanGiao =
          ResponseParser.parseToList<DetailSubppliesHandoverDto>(
            response.data,
            DetailSubppliesHandoverDto.fromJson,
          );

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = chiTietBanGiao;
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at getChiTietBanGiaoCCDCVatTu - ToolAndSuppliesHandoverRepository: $e",
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

  Future<Map<String, dynamic>> getListDetailAssetByTransfer(String id) async {
    List<DetailSubppliesHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.DETAIL_SUPPLIES_HANDOVER}/by-dieu-dong/$id',
      );
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<DetailSubppliesHandoverDto>(
        response.data,
        DetailSubppliesHandoverDto.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at getListDetailAssetByTransfer - ToolAndSuppliesHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createToolAndSuppliesHandover(
    Map<String, dynamic> request,
    List<SignatoryDto> listSignatory,
    List<Map<String, dynamic>> requestDetailSubppliesHandover,
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
      
      // Xử lý null safety cho idBGTS
      // Response có thể có cấu trúc: {data: {id: ...}} hoặc {id: ...}
      final dynamic respData = response.data;
      final String idBGTS = (respData is Map && respData.containsKey('data'))
          ? (respData['data']?['id']?.toString() ?? '')
          : (respData['id']?.toString() ?? '');
      if (idBGTS.isEmpty) {
        result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
        result['message'] = 'Không nhận được ID từ response';
        return result;
      }
      
      for (var signatory in listSignatory) {
        final signatoryCopy = signatory.copyWith(
          idTaiLieu: idBGTS,
          trangThai: 0,
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
    
      final responseDetail = await post(
        "${EndPointAPI.DETAIL_SUPPLIES_HANDOVER}/batch",
        data: requestDetailSubppliesHandover.map((e) => {
          ...e,
          'idBanGiaoCCDCVatTu': idBGTS,
        }).toList(),
      );
      final int? statusDetail = responseDetail.statusCode;
      if (checkStatusCodeFailed(statusDetail ?? 0)) {
        result['status_code'] = statusDetail ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      String newSignatory = listSignatory
          .map((e) => e.idNguoiKy ?? '')
          .where((id) => id.isNotEmpty)
          .join(',');
      String idNeedToDo =
          "${request['idDonViGiao'] ?? ''},${request['idDonViNhan'] ?? ''},${request['idGiamDoc'] ?? ''},$newSignatory, admin,${request['nguoiTao'] ?? ''}";
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        MessageServiceRealtime().pushJsonMessage(
          typeFunc: FunctionType.TOOL_AND_SUPPLIES_HANDOVER,
          typeAction: ActionType.CREATE,
          idNeedToDo: idNeedToDo,
        );
      });
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

  Future<Map<String, dynamic>> createDetailHandoverCCDC(
    List<Map<String, dynamic>> requestDetailSubppliesHandover,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        "${EndPointAPI.DETAIL_SUPPLIES_HANDOVER}/batch",
        data: requestDetailSubppliesHandover,
      );

      final int? status = response.statusCode;
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "ToolAndSuppliesHandoverRepository",
        "Error at createDetailHandoverCCDC - ToolAndSuppliesHandoverRepository: $e",
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
        '${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/huytrangthai?id=$id',
      );
      unawaited(delete('/api/chuky/$id'));

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        MessageServiceRealtime().pushJsonMessage(
          typeFunc: FunctionType.ALL_FUNCTION,
          typeAction: ActionType.DELETE,
          idNeedToDo: 'admin',
        );
      });
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
    try {
      // Tối ưu: sử dụng Set để tự động loại bỏ duplicate IDs
      final allIds = <String>{};

      for (var item in items) {
        final id1 = item.idDaiDiendonviBanHanhQD;
        final id2 = item.idDaiDienBenGiao;
        final id3 = item.idDaiDienBenNhan;
        final id4 = item.idGiamDoc;

        if (id1 != null && id1.isNotEmpty) allIds.add(id1);
        if (id2 != null && id2.isNotEmpty) allIds.add(id2);
        if (id3 != null && id3.isNotEmpty) allIds.add(id3);
        if (id4 != null && id4.isNotEmpty) allIds.add(id4);

        final signatories = item.listSignatory;
        if (signatories != null) {
          for (var s in signatories) {
            final sigId = s.idNguoiKy;
            if (sigId != null && sigId.isNotEmpty) allIds.add(sigId);
          }
        }
        final payload = item.copyWith(share: true);
        final response = await put(
          EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER,
          data: payload.toJson(),
        );
        if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
          result['data'] = response.data;
        } else {
          result['status_code'] = response.statusCode;
        }
      }
      // Gửi message realtime nếu có IDs
      if (allIds.isNotEmpty) {
        // Thêm admin mặc định vào danh sách nhận thông báo
        allIds.add('admin,${items.map((e) => e.nguoiTao).join(',')}');
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          MessageServiceRealtime().pushJsonMessage(
            typeFunc: FunctionType.TOOL_AND_SUPPLIES_HANDOVER,
            typeAction: ActionType.UPDATE,
            idNeedToDo: allIds.join(','),
          );
        });
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at sendToSigner - AssetHandoverRepository: $e",
      );
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

  // // Helper methods để tối ưu performance
  // Future<void> _loadSignatories(ToolAndSuppliesHandoverDto item) async {
  //   try {
  //     final signatories = await _signatoryRepository.getAll(item.id.toString());
  //     item.listSignatory = signatories;
  //   } catch (e) {
  //     item.listSignatory = [];
  //     SGLog.error(
  //       "ToolAndSuppliesHandoverRepository",
  //       "Error loading signatories for ID ${item.id}: $e",
  //     );
  //   }
  // }

  // Future<void> _loadDetailSupplies(ToolAndSuppliesHandoverDto item) async {
  //   try {
  //     final detailSuppliesHandover = await getChiTietBanGiaoCCDCVatTu(
  //       idbangiaoccdcvattu: item.id.toString(),
  //       iddieudongccdcvattu: item.lenhDieuDong.toString(),
  //     );

  //     final dynamic rawData = detailSuppliesHandover['data'];
  //     if (rawData is List) {
  //       if (rawData.isEmpty) {
  //         item.listDetailSubppliesHandover = [];
  //       } else if (rawData.first is DetailSubppliesHandoverDto) {
  //         item.listDetailSubppliesHandover =
  //             List<DetailSubppliesHandoverDto>.from(rawData);
  //       } else {
  //         item.listDetailSubppliesHandover =
  //             ResponseParser.parseToList<DetailSubppliesHandoverDto>(
  //               rawData,
  //               DetailSubppliesHandoverDto.fromJson,
  //             );
  //       }
  //     } else {
  //       item.listDetailSubppliesHandover = [];
  //     }
  //   } catch (e) {
  //     item.listDetailSubppliesHandover = [];
  //     SGLog.error(
  //       "ToolAndSuppliesHandoverRepository",
  //       "Error loading detail supplies handover for ID ${item.id}: $e",
  //     );
  //   }
  // }

  Future<Map<String, dynamic>> updateDetailHandoverCCDC(
    Map<String, dynamic> request,
  ) async {
    log('request: $request');
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        EndPointAPI.DETAIL_SUPPLIES_HANDOVER,
        data: request,
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

  Future<Map<String, dynamic>> deleteDetailHandoverCCDC(String id) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        "${EndPointAPI.DETAIL_SUPPLIES_HANDOVER}/$id",
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
        "Error at deleteDetailHandoverCCDC - ToolAndSuppliesHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getDataWithPagination(
    int page,
    int size,
    String search,
    int trangThai,
  ) async {
    Map<String, dynamic> result = {
      'data': <ToolAndSuppliesHandoverDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'totalPages': 0,
      'currentPage': 0,
      'totalItems': 0,
      'totalAll': 0,
      'totalDraft': 0,
      'totalApprove': 0,
      'totalCancel': 0,
      'totalComplete': 0,
    };
    final userInfo = AccountHelper.instance.getUserInfo();

    try {
      final userid = userInfo?.tenDangNhap ?? 'admin';
      final response = await get(
        // Đổi từ post thành get
        '${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/paged?idcongty=ct001&page=$page&size=$size&search=$search&userid=$userid&trangThai=${trangThai == -1 ? '' : trangThai}',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
          itemsData,
          ToolAndSuppliesHandoverDto.fromJson,
        );
      } else {
        result['data'] = <ToolAndSuppliesHandoverDto>[];
      }
      result['totalPages'] = response.data['totalPages'] ?? 0;
      result['currentPage'] = response.data['currentPage'] ?? 0;
      result['totalItems'] = response.data['totalItems'] ?? 0;

      // Xử lý groupCounts với null-safety
      final groupCounts = response.data['groupCounts'];
      if (groupCounts is Map<String, dynamic>) {
        // Helper function để parse giá trị từ groupCounts
        int parseGroupCount(String key, [String? altKey]) {
          final value = groupCounts[key] ?? groupCounts[altKey];
          if (value is int) return value;
          if (value is num) return value.toInt();
          if (value == null) return 0;
          return int.tryParse(value.toString()) ?? 0;
        }

        result['totalAll'] = parseGroupCount('-1', 'all');
        result['totalDraft'] = parseGroupCount('0', 'draft');
        result['totalApprove'] = parseGroupCount('1', 'approve');
        result['totalCancel'] = parseGroupCount('2', 'cancel');
        result['totalComplete'] = parseGroupCount('3', 'complete');
      } else {
        // Nếu groupCounts không tồn tại hoặc không phải Map, set về 0
        result['totalAll'] = 0;
        result['totalDraft'] = 0;
        result['totalApprove'] = 0;
        result['totalCancel'] = 0;
        result['totalComplete'] = 0;
      }
    } catch (e) {
      log("Error at getDataWithPagination - ToolAndMaterialTransferRepository: $e");
    }

    return result;
  }

    Future<Map<String, dynamic>> getCountUseSign() async {
    int count = 0;
    try {
      final userInfo = AccountHelper.instance.getUserInfo();
      String userid = userInfo?.tenDangNhap == 'admin' ? '' : userInfo?.tenDangNhap ?? '';
      final url =
          '${EndPointAPI.TOOL_AND_SUPPLIES_HANDOVER}/paged?idcongty=ct001&page=0&size=999999&userid=$userid';

      final response = await get(url);
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        count = response.data['totalItems'] ?? 0;
      }
      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      List<ToolAndSuppliesHandoverDto> toolAndMaterialHandover = [];
      if (itemsData is List) {
        toolAndMaterialHandover = ResponseParser.parseToList<ToolAndSuppliesHandoverDto>(
          itemsData,
          ToolAndSuppliesHandoverDto.fromJson,
        );
      } else {
        toolAndMaterialHandover = [];
      }
      AccountHelper.instance.clearToolAndSuppliesHandover();
      AccountHelper.instance.setToolAndMaterialHandover(toolAndMaterialHandover);
      AccountHelper.refreshAllCounts();
    } catch (e) {
      log("Error at getCountUseSign - ToolAndSuppliesHandoverRepository: $e");
    }
    return {'data': count, 'status_code': Numeral.STATUS_CODE_SUCCESS};
  }

}
