import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';
import 'tool_and_material_transfer_event.dart'
    show
        CancelToolAndMaterialTransferEvent,
        CreateToolAndMaterialTransferEvent,
        DeleteToolAndMaterialTransferEvent,
        GetDataDropdownEvent,
        GetListAssetEvent,
        GetListToolAndMaterialTransferEvent,
        ToolAndMaterialTransferEvent,
        UpdateSigningTAMTStatusEvent,
        UpdateToolAndMaterialTransferEvent;
import 'tool_and_material_transfer_state.dart';

class ToolAndMaterialTransferBloc
    extends Bloc<ToolAndMaterialTransferEvent, ToolAndMaterialTransferState> {
  ToolAndMaterialTransferBloc() : super(ToolAndMaterialTransferInitialState()) {
    on<GetListToolAndMaterialTransferEvent>(_getListToolAndMaterialTransfer);
    on<GetListAssetEvent>(_getListAsset);
    on<GetDataDropdownEvent>(_getDataDropdown);
    on<CreateToolAndMaterialTransferEvent>(_createLenhDieuDong);
    on<UpdateToolAndMaterialTransferEvent>(_updateToolAndMaterialTransfer);
    on<DeleteToolAndMaterialTransferEvent>(_deleteToolAndMaterialTransfer);
    on<UpdateSigningTAMTStatusEvent>(_updateSigningStatus);
    on<CancelToolAndMaterialTransferEvent>(_cancelDieuDongTaiSan);
  }

  Future<void> _getListToolAndMaterialTransfer(
    GetListToolAndMaterialTransferEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    List<ToolAndMaterialTransferDto> toolAndMaterialTransfers =
        await ToolAndMaterialTransferRepository().getAllToolAndMeterialTransfer(
          event.typeAssetTransfer,
        );
    emit(ToolAndMaterialTransferLoadingDismissState());
    emit(
      GetListToolAndMaterialTransferSuccessState(
        data: toolAndMaterialTransfers,
      ),
    );
  }

  Future<void> _getListAsset(GetListAssetEvent event, Emitter emit) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .getListToolsAndSupplies(event.idCongTy);
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListAssetFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _getDataDropdown(
    GetDataDropdownEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    Map<String, dynamic> result = await ToolAndMaterialTransferRepository()
        .getDataDropdown(event.idCongTy);
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        GetDataDropdownSuccessState(
          dataPb: result['data_pb'],
          dataNv: result['data_nv'],
        ),
      );
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListAssetFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  ///CREATE
  Future<void> _createLenhDieuDong(
    CreateToolAndMaterialTransferEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    Map<String, dynamic> result = await ToolAndMaterialTransferRepository()
        .createToolAndMaterialTransfer(event.request, event.requestDetail);
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateDieuDongSuccessState());
    } else {
      String msg = "Lỗi khi tạo lệnh điều động";
      emit(
        CreateDieuDongFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _updateToolAndMaterialTransfer(
    UpdateToolAndMaterialTransferEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    int result = await ToolAndMaterialTransferRepository().update(
      event.id,
      event.params,
    );
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateDieuDongSuccessState(data: result.toString()));
    } else {
      String msg = "Lỗi khi cập nhật lệnh điều động";
      emit(
        PutPostDeleteFailedState(title: "notice", code: result, message: msg),
      );
    }
  }

  Future<void> _deleteToolAndMaterialTransfer(
    DeleteToolAndMaterialTransferEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    int result = await ToolAndMaterialTransferRepository()
        .deleteToolAndMaterialTransfer(event.id);
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteDieuDongSuccessState(data: result.toString()));
    } else {
      String msg = "Lỗi khi xóa lệnh điều động";
      emit(
        PutPostDeleteFailedState(title: "notice", code: result, message: msg),
      );
    }
  }

  //Update trạng thái biên bản
  Future<void> _updateSigningStatus(
    UpdateSigningTAMTStatusEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    Map<String, dynamic> result = await ToolAndMaterialTransferRepository()
        .updateState(event.id, event.userId);
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateSigningTAMTStatusSuccessState());
    } else {
      String msg =
          "Lỗi khi cập nhập trạng thái lệnh điều động ${result['message']}";
      emit(
        UpdateSigningTAMTStatusFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _cancelDieuDongTaiSan(
    CancelToolAndMaterialTransferEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    Map<String, dynamic> result = await ToolAndMaterialTransferRepository()
        .cancelToolAndMaterialTransfer(event.id);
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CancelToolAndMaterialTransferSuccessState());
    } else {
      String msg =
          "Lỗi khi cập nhập trạng thái lệnh điều động ${result['message']}";
      emit(
        UpdateSigningTAMTStatusFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
