import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/unit/repository/unit_repository.dart';
import 'unit_event.dart';
import 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  UnitBloc() : super(UnitInitialState()) {
    on<GetListUnitEvent>(_getListUnit);
    on<CreateUnitEvent>(_createUnit);
    on<CreateUnitBatchEvent>(_createUnitBatch);
    on<UpdateUnitEvent>(_updateUnit);
    on<DeleteUnitEvent>(_deleteUnit);
    on<DeleteUnitBatchEvent>(_deleteUnitBatch);
  }

  Future<void> _getListUnit(GetListUnitEvent event, Emitter emit) async {
    emit(UnitInitialState());
    emit(UnitLoadingState());
    Map<String, dynamic> result = await UnitRepository().getListUnit();

    emit(UnitLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListUnitSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListUnitFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createUnit(CreateUnitEvent event, Emitter emit) async {
    emit(UnitInitialState());
    emit(UnitLoadingState());
    Map<String, dynamic> result = await UnitRepository().createUnit(
      event.params,
    );
    emit(UnitLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateUnitSuccessState());
    } else {
      String msg = "Lỗi khi tạo đơn vị ${result['message']}";
      emit(
        CreateUnitFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createUnitBatch(
    CreateUnitBatchEvent event,
    Emitter emit,
  ) async {
    emit(UnitInitialState());
    emit(UnitLoadingState());
    Map<String, dynamic> result = await UnitRepository().saveUnitBatch(
      event.params,
    );
    emit(UnitLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateUnitSuccessState());
    } else {
      String msg = "Lỗi khi import đơn vị ${result['message']}";
      emit(
        CreateUnitFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _updateUnit(UpdateUnitEvent event, Emitter emit) async {
    emit(UnitInitialState());
    emit(UnitLoadingState());
    final result = await UnitRepository().updateUnit(event.params, event.id);
    emit(UnitLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(UpdateUnitSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi cập nhật đơn vị',
        ),
      );
    }
  }

  Future<void> _deleteUnit(DeleteUnitEvent event, Emitter emit) async {
    emit(UnitInitialState());
    emit(UnitLoadingState());
    final result = await UnitRepository().deleteUnit(event.id);
    emit(UnitLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteUnitSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa đơn vị',
        ),
      );
    }
  }

  Future<void> _deleteUnitBatch(
    DeleteUnitBatchEvent event,
    Emitter emit,
  ) async {
    emit(UnitInitialState());
    emit(UnitLoadingState());
    final result = await UnitRepository().deleteUnitBatch(event.ids);
    emit(UnitLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteUnitSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa danh sách đơn vị',
        ),
      );
    }
  }
}
