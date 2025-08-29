import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import '../model/dieu_dong_tai_san_dto.dart';
import '../repository/dieu_dong_tai_san_repository.dart';
import 'dieu_dong_tai_san_event.dart'
    show
        CancelDieuDongTaiSanEvent,
        CreateDieuDongEvent,
        DeleteDieuDongEvent,
        DieuDongTaiSanEvent,
        GetDataDropdownEvent,
        GetListAssetEvent,
        GetListDieuDongTaiSanEvent,
        UpdateDieuDongEvent,
        UpdateSigningStatusEvent;
import 'dieu_dong_tai_san_state.dart';

class DieuDongTaiSanBloc
    extends Bloc<DieuDongTaiSanEvent, DieuDongTaiSanState> {
  DieuDongTaiSanBloc() : super(DieuDongTaiSanInitialState()) {
    on<GetListDieuDongTaiSanEvent>(_getListDieuDongTaiSan);
    on<GetListAssetEvent>(_getListAsset);
    on<GetDataDropdownEvent>(_getDataDropdown);
    on<CreateDieuDongEvent>(_createLenhDieuDong);
    on<UpdateDieuDongEvent>(_updateDieuDong);
    on<DeleteDieuDongEvent>(_deleteDieuDong);
    on<UpdateSigningStatusEvent>(_updateSigningStatus);
    on<CancelDieuDongTaiSanEvent>(_cancelDieuDongTaiSan);
  }

  Future<void> _getListDieuDongTaiSan(
    GetListDieuDongTaiSanEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    List<DieuDongTaiSanDto> dieuDongTaiSans = await DieuDongTaiSanRepository()
        .getAll(event.typeAssetTransfer);
    emit(DieuDongTaiSanLoadingDismissState());
    emit(GetListDieuDongTaiSanSuccessState(data: dieuDongTaiSans));
  }

  Future<void> _getListAsset(GetListAssetEvent event, Emitter emit) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListAssetManagement(event.idCongTy);
    emit(DieuDongTaiSanLoadingDismissState());
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
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    Map<String, dynamic> result = await AssetTransferRepository()
        .getDataDropdown(event.idCongTy);
    emit(DieuDongTaiSanLoadingDismissState());
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
    CreateDieuDongEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    Map<String, dynamic> result = await AssetTransferRepository()
        .createAssetTransfer(event.request, event.requestDetail, event.listSignatory);
    emit(DieuDongTaiSanLoadingDismissState());
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

  Future<void> _updateDieuDong(UpdateDieuDongEvent event, Emitter emit) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    int result = await DieuDongTaiSanRepository().update(
      event.id,
      event.params,
    );
    emit(DieuDongTaiSanLoadingDismissState());
    if (result == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateDieuDongSuccessState(data: result.toString()));
    } else {
      String msg = "Lỗi khi cập nhật lệnh điều động";
      emit(
        PutPostDeleteFailedState(title: "notice", code: result, message: msg),
      );
    }
  }

  Future<void> _deleteDieuDong(DeleteDieuDongEvent event, Emitter emit) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    int result = await DieuDongTaiSanRepository().delete(event.id);
    emit(DieuDongTaiSanLoadingDismissState());
    if (result == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteDieuDongSuccessState(data: result.toString()));
    } else {
      String msg = "Lỗi khi xóa lệnh điều động";
      emit(
        PutPostDeleteFailedState(title: "notice", code: result, message: msg),
      );
    }
  }

  // Bloc cập nhập trạng thái phiếu ký nội sinh
  Future<void> _updateSigningStatus(
    UpdateSigningStatusEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    Map<String, dynamic> result = await AssetTransferRepository().updateState(
      event.id,
      event.userId,
    );
    emit(DieuDongTaiSanLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateSigningStatusSuccessState());
    } else {
      String msg =
          "Lỗi khi cập nhập trạng thái lệnh điều động ${result['message']}";
      emit(
        UpdateSigningStatusFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  // Bloc hủy phiếu ký nội sinh
  Future<void> _cancelDieuDongTaiSan(
    CancelDieuDongTaiSanEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    Map<String, dynamic> result = await AssetTransferRepository()
        .cancelDieuDongTaiSan(event.id);
    emit(DieuDongTaiSanLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CancelDieuDongTaiSanSuccessState());
    } else {
      String msg =
          "Lỗi khi cập nhập trạng thái lệnh điều động ${result['message']}";
      emit(
        UpdateSigningStatusFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
