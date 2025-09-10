import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_detail_repository.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/repository/ccdc_group_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';

import 'tools_and_supplies_event.dart';
import 'tools_and_supplies_state.dart';

class ToolsAndSuppliesBloc
    extends Bloc<ToolsAndSuppliesEvent, ToolsAndSuppliesState> {
  ToolsAndSuppliesBloc() : super(ToolsAndSuppliesInitialState()) {
    on<GetListToolsAndSuppliesEvent>(_getListToolsAndSupplies);
    on<GetListPhongBanEvent>(_getListPhongBan);
    on<CreateToolsAndSuppliesEvent>(_createToolsAndSupplies);
    on<UpdateToolsAndSuppliesEvent>(_updateToolsAndSupplies);
    on<DeleteToolsAndSuppliesEvent>(_deleteToolsAndSupplies);
  }

  Future<void> _getListToolsAndSupplies(
    GetListToolsAndSuppliesEvent event,
    Emitter emit,
  ) async {
    emit(ToolsAndSuppliesInitialState());
    emit(ToolsAndSuppliesLoadingState());

    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .getListToolsAndSupplies(event.idCongTy);

    Map<String, dynamic> resultGroupCCDC = await CcdcGroupRepository()
        .getListCcdcGroupRepository(event.idCongTy);

    emit(ToolsAndSuppliesLoadingDismissState());

    if (checkStatusCodeDone(result) && checkStatusCodeDone(resultGroupCCDC)) {
      emit(
        GetListToolsAndSuppliesSuccessState(
          data: result['data'],
          dataGroupCCDC: resultGroupCCDC['data'],
        ),
      );
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListToolsAndSuppliesFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  //GET LIST PHONG BAN
  Future<void> _getListPhongBan(
    GetListPhongBanEvent event,
    Emitter emit,
  ) async {
    emit(ToolsAndSuppliesInitialState());
    emit(ToolsAndSuppliesLoadingState());
    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .getListPhongBan(event.idCongTy);
    emit(ToolsAndSuppliesLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListPhongBanSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListPhongBanFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  //CALL API CREATE
  Future<void> _createToolsAndSupplies(
    CreateToolsAndSuppliesEvent event,
    Emitter emit,
  ) async {
    emit(ToolsAndSuppliesInitialState());
    emit(ToolsAndSuppliesLoadingState());
    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .createToolsAndSupplies(event.params);

    Map<String, dynamic> resultAssetDetail = await AssetManagementDetailRepository()
        .createAssetDetail(event.listAssetDetail);

    emit(ToolsAndSuppliesLoadingDismissState());

    if (checkStatusCodeDone(result)) {
      emit(CreateToolsAndSuppliesSuccessState(data: result['data'].toString()));
    } else {
      String msg = "Lỗi khi tạo CCDC - Vật tư";
      emit(
        CreateToolsAndSuppliesFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }

    if (checkStatusCodeDone(resultAssetDetail)) {
    } else {
      String msg = "Lỗi khi tạo chi tiết ccdc - vật tư";
      emit(
        CreateToolsAndSuppliesFailedState(
          title: "notice",
          code: resultAssetDetail['status_code'],
          message: msg,
        ),
      );
    }
  }

  //CALL API UPDATE
  Future<void> _updateToolsAndSupplies(
    UpdateToolsAndSuppliesEvent event,
    Emitter emit,
  ) async {
    emit(ToolsAndSuppliesInitialState());
    emit(ToolsAndSuppliesLoadingState());
    final result = await ToolsAndSuppliesRepository().updateToolsAndSupplies(
      event.params,
    );

    Map<String, dynamic> resultAssetDetail = await AssetManagementDetailRepository()
        .createAssetDetail(event.listAssetDetail);

    Map<String, dynamic> resultDeleteAssetDetail =
        await AssetManagementDetailRepository().deleteAssetDetail(
          event.listIdAssetDetail,
        );

    emit(ToolsAndSuppliesLoadingDismissState());

    if (checkStatusCodeDone(result)) {
      emit(UpdateToolsAndSuppliesSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi cập nhật CCDC - Vật tư',
        ),
      );
    }

    if (checkStatusCodeDone(resultAssetDetail) ||
        checkStatusCodeDone(resultDeleteAssetDetail)) {
    } else {
      String msg = "Lỗi khi update chi tiết ccdc - vật tư";
      emit(
        CreateToolsAndSuppliesFailedState(
          title: "notice",
          code: resultAssetDetail['status_code'],
          message: msg,
        ),
      );
    }
  }

  //CALL API UPDATE
  Future<void> _deleteToolsAndSupplies(
    DeleteToolsAndSuppliesEvent event,
    Emitter emit,
  ) async {
    emit(ToolsAndSuppliesInitialState());
    emit(ToolsAndSuppliesLoadingState());
    final result = await ToolsAndSuppliesRepository().deleteToolsAndSupplies(
      event.id,
    );
    final resultAssetDetail = await AssetManagementDetailRepository()
        .deleteAssetDetail(event.listIdAssetDetail);
    emit(ToolsAndSuppliesLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteToolsAndSuppliesSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa CCDC - Vật tư',
        ),
      );
    }

    if (checkStatusCodeDone(resultAssetDetail)) {
    } else {
      String msg = "Lỗi khi xóa chi tiết ccdc - vật tư";
      emit(
        CreateToolsAndSuppliesFailedState(
          title: "notice",
          code: resultAssetDetail['status_code'],
          message: msg,
        ),
      );
    }
  }
}
