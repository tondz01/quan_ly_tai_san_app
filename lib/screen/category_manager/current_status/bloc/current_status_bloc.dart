import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/repository/current_status_repository.dart';

class CurrentStatusBloc extends Bloc<CurrentStatusEvent, CurrentStatusState> {
  CurrentStatusBloc() : super(CurrentStatusInitialState()) {
    on<GetListCurrentStatusEvent>(_getList);
    on<CreateCurrentStatusEvent>(_create);
    on<CreateCurrentStatusBatchEvent>(_createBatch);
    on<UpdateCurrentStatusEvent>(_update);
    on<DeleteCurrentStatusEvent>(_delete);
    on<DeleteCurrentStatusBatchEvent>(_deleteBatch);
  }

  Future<void> _getList(
    GetListCurrentStatusEvent event,
    Emitter emit,
  ) async {
    emit(CurrentStatusInitialState());
    emit(CurrentStatusLoadingState());
    final result = await CurrentStatusRepository().getListCurrentStatusRepository('CT001');
    emit(CurrentStatusLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListCurrentStatusSuccessState(data: result['data']));
    } else {
      emit(
        GetListCurrentStatusFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi lấy dữ liệu',
        ),
      );
    }
  }

  Future<void> _create(
    CreateCurrentStatusEvent event,
    Emitter emit,
  ) async {
    emit(CurrentStatusInitialState());
    emit(CurrentStatusLoadingState());
    final result = await CurrentStatusRepository().createCurrentStatusRepository(event.params);
    emit(CurrentStatusLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateCurrentStatusSuccessState(data: result['data'].toString()));
    } else {
      emit(
        CreateCurrentStatusFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi tạo loại tài sản',
        ),
      );
    }
  }

  Future<void> _createBatch(
    CreateCurrentStatusBatchEvent event,
    Emitter emit,
  ) async {
    emit(CurrentStatusInitialState());
    emit(CurrentStatusLoadingState());
    final result = await CurrentStatusRepository().saveCurrentStatusBatch(event.params);
    emit(CurrentStatusLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateCurrentStatusSuccessState(data: result['data'].toString()));
    } else {
      emit(
        CreateCurrentStatusFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi tạo danh sách loại tài sản',
        ),
      );
    }
  }

  Future<void> _update(
    UpdateCurrentStatusEvent event,
    Emitter emit,
  ) async {
    emit(CurrentStatusInitialState());
    emit(CurrentStatusLoadingState());
    final result = await CurrentStatusRepository().updateCurrentStatusRepository(
      event.params,
      event.id,
    );
    emit(CurrentStatusLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(UpdateCurrentStatusSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi cập nhật loại tài sản',
        ),
      );
    }
  }

  Future<void> _delete(
    DeleteCurrentStatusEvent event,
    Emitter emit,
  ) async {
    emit(CurrentStatusInitialState());
    emit(CurrentStatusLoadingState());
    final result = await CurrentStatusRepository().deleteCurrentStatusRepository(event.id);
    emit(CurrentStatusLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteCurrentStatusSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa loại tài sản',
        ),
      );
    }
  }

  Future<void> _deleteBatch(
    DeleteCurrentStatusBatchEvent event,
    Emitter emit,
  ) async {
    emit(CurrentStatusInitialState());
    emit(CurrentStatusLoadingState());
    final result = await CurrentStatusRepository().deleteCurrentStatusBatchIds(event.ids);
    emit(CurrentStatusLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteCurrentStatusSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa danh sách loại tài sản',
        ),
      );
    }
  }
}


