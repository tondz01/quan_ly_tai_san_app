import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
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
    Map<String, dynamic> result =
        await ToolsAndSuppliesRepository().getListToolsAndSupplies(event.idCongTy);
    emit(ToolsAndSuppliesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListToolsAndSuppliesSuccessState(data: result['data']));
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
    Map<String, dynamic> result =
        await ToolsAndSuppliesRepository().getListPhongBan(event.idCongTy);
    emit(ToolsAndSuppliesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
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
    Map<String, dynamic> result = await ToolsAndSuppliesRepository().createToolsAndSupplies(
      event.params,
    );
    emit(ToolsAndSuppliesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
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
    emit(ToolsAndSuppliesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateToolsAndSuppliesSuccessState(data: result['data'].toString()));
    } else {
      emit(PutPostDeleteFailedState(
        title: 'notice',
        code: result['status_code'],
        message: 'Lỗi khi cập nhật CCDC - Vật tư',
      ));
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
    emit(ToolsAndSuppliesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteToolsAndSuppliesSuccessState(data: result['data'].toString()));
    } else {
      emit(PutPostDeleteFailedState(
        title: 'notice',
        code: result['status_code'],
        message: 'Lỗi khi xóa CCDC - Vật tư',
      ));
    }
  }
}
