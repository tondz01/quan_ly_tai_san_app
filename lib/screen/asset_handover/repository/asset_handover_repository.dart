import 'dart:async';
import 'dart:convert';

import 'package:quan_ly_tai_san_app/common/reponsitory/update_ownership_unit.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetHandoverRepository extends ApiBase {
  late final SignatoryRepository _signatoryRepository;
  final jsonMsg = MessageServiceRealtime().listenLatestJson();

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
        "${EndPointAPI.ASSET_HANDOVER}/getbyuserid/${userInfo.tenDangNhap}",
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
      AccountHelper.instance.clearAssetHandover();
      AccountHelper.instance.setAssetHandover(assetHandover);
      AccountHelper.refreshAllCounts();
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

  Future<Map<String, dynamic>> getAllAssetHandover() async {
    List<AssetHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        "${EndPointAPI.ASSET_HANDOVER}/getbystatus?trangthai=3",
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

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = assetHandover;
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getAllAssetHandover - AssetHandoverRepository: $e",
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
    List<DetailAssetHandoverDto> listDetailAssetHandover,
  ) async {
    Map<String, dynamic> result = {
      'data': "",
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(EndPointAPI.ASSET_HANDOVER, data: request);

      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }
      String newSignatory = listSignatory.map((e) => e.idNguoiKy).join(',');
      //Gửi message đến server để cập nhật trạng thái phiếu ký nội sinh
      String idNeedToDo =
          "${request['idDaiDiendonviBanHanhQD']},${request['idDaiDienBenGiao']},${request['idDaiDienBenNhan']},${request['idGiamDoc']},$newSignatory, admin,${request['nguoiTao']}";

      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        MessageServiceRealtime().pushJsonMessage(
          typeFunc: FunctionType.ASSET_HANDOVER,
          typeAction: ActionType.CREATE,
          idNeedToDo: idNeedToDo,
        );
      });
      final responseDetail = await post(
        '${EndPointAPI.DETAIL_ASSET_HANDOVER}/batch',
        data: listDetailAssetHandover.map((e) => e.toJson()).toList(),
      );
      final int? statusDetail = responseDetail.statusCode;
      final bool isOkDetail =
          statusDetail == Numeral.STATUS_CODE_SUCCESS ||
          statusDetail == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          statusDetail == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOkDetail) {
        result['status_code'] = statusDetail ?? Numeral.STATUS_CODE_DEFAULT;
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
              statusSignatory ?? Numeral.STATUS_CODE_SUCCESS;
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
        "${EndPointAPI.ASSET_HANDOVER}/$id",
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
      final response = await delete("${EndPointAPI.ASSET_HANDOVER}/$id");
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
  Future<Map<String, dynamic>> updateState(
    String id,
    String idNhanVien,
    List<Map<String, dynamic>> request,
    String idDieuChuyen,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.ASSET_HANDOVER}/capnhattrangthai?id=$id&userId=$idNhanVien',
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
      if (dataCode == 3) {
        await UpdateOwnershipUnit().updateAssetOwnership(request);
        await updateStateAssetTransfer(idDieuChuyen, true);
      }
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at updateState - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateStateAssetTransfer(
    String id,
    bool trangThaiBanGiao,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.DIEU_DONG_TAI_SAN}/update-trang-thai-ban-giao?id=$id&trangThaiBanGiao=$trangThaiBanGiao',
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
      SGLog.error(
        "AssetHandoverRepository",
        "Error at updateStateAssetTransfer - AssetHandoverRepository: $e",
      );
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
        '${EndPointAPI.ASSET_HANDOVER}/huytrangthai?id=$id',
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
      result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
        response.data,
        AssetHandoverDto.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at cancelAssetHandover - AssetHandoverRepository: $e",
      );
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
        item.copyWith(share: true);
        final response = await put(
          '${EndPointAPI.ASSET_HANDOVER}/${item.id}',
          data: jsonEncode(item.toJson()),
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
            typeFunc: FunctionType.ASSET_HANDOVER,
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
        "AssetHandoverRepository",
        "Error at updateOwnershipUnit - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createDetailHandoverAsset(
    List<DetailAssetHandoverDto> request,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.DETAIL_ASSET_HANDOVER}/batch',
        data: request.map((e) => e.toJson()).toList(),
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
      SGLog.error(
        "AssetHandoverRepository",
        "Error at createDetailHandoverAsset - AssetHandoverRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateDetailHandoverAsset(
    Map<String, dynamic> request,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        EndPointAPI.DETAIL_ASSET_HANDOVER,
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
      SGLog.error(
        "AssetHandoverRepository",
        "Error at updateDetailHandoverAsset - AssetHandoverRepository: $e",
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
      final response = await delete("${EndPointAPI.DETAIL_ASSET_HANDOVER}/$id");
      final int? status = response.statusCode;
      if (checkStatusCodeFailed(status ?? 0)) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data.toString();
    } catch (e) {
      SGLog.error(
        "AssetHandoverRepository",
        "Error at deleteDetailHandoverCCDC - AssetHandoverRepository: $e",
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
      'data': <AssetHandoverDto>[],
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
      String userid = userInfo?.tenDangNhap ?? 'admin';
      final response = await get(
        // Đổi từ post thành get
        '${EndPointAPI.ASSET_HANDOVER}/paged?idcongty=ct001&page=$page&size=$size&sortBy=ngayTao&sortDir=esc&search=$search&userid=$userid&trangThai=${trangThai == -1 ? '' : trangThai}',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
          itemsData,
          AssetHandoverDto.fromJson,
        );
      } else {
        result['data'] = <AssetHandoverDto>[];
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
      SGLog.error(
        "AssetHandoverRepository",
        "Error at getDataWithPagination - AssetHandoverRepository: $e",
      );
    }

    return result;
  }
}
