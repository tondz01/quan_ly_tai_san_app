import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_event.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_state.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/repository/reason_increase_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class ReasonIncreaseBloc extends Bloc<ReasonIncreaseEvent, ReasonIncreaseState> {
  ReasonIncreaseBloc() : super(ReasonIncreaseInitialState()) {
    on<GetListReasonIncreaseEvent>(_getList);
    on<CreateReasonIncreaseEvent>(_create);
    on<CreateReasonIncreaseBatchEvent>(_createBatch);
    on<UpdateReasonIncreaseEvent>(_update);
    on<DeleteReasonIncreaseEvent>(_delete);
    on<DeleteReasonIncreaseBatchEvent>(_deleteBatch);
  }

  Future<void> _getList(
    GetListReasonIncreaseEvent event,
    Emitter<ReasonIncreaseState> emit,
  ) async {
    emit(ReasonIncreaseInitialState());
    emit(ReasonIncreaseLoadingState());
    Map<String, dynamic> result = await ReasonIncreaseRepository()
        .getListReasonIncreaseRepository();
    emit(ReasonIncreaseLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListReasonIncreaseSuccessState(data: result['data']));
      AccountHelper.instance.setReasonIncrease(result['data']);
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListReasonIncreaseFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _create(
    CreateReasonIncreaseEvent event,
    Emitter<ReasonIncreaseState> emit,
  ) async {
    emit(ReasonIncreaseInitialState());
    emit(ReasonIncreaseLoadingState());
    Map<String, dynamic> result = await ReasonIncreaseRepository()
        .createReasonIncreaseRepository(event.params);
    emit(ReasonIncreaseLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateReasonIncreaseSuccessState(data: result['data'].toString()));
    } else {
      String msg = "Lỗi khi tạo nhóm tài sản";
      emit(
        CreateReasonIncreaseFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createBatch(
    CreateReasonIncreaseBatchEvent event,
    Emitter<ReasonIncreaseState> emit,
  ) async {
    emit(ReasonIncreaseInitialState());
    emit(ReasonIncreaseLoadingState());
    Map<String, dynamic> result = await ReasonIncreaseRepository()
        .saveReasonIncreaseBatch(event.params);
    emit(ReasonIncreaseLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(
        CreateReasonIncreaseBatchSuccessState(
          message: "Thêm danh sách nhóm tài sản thành công",
        ),
      );
    } else {
      String msg = "Lỗi khi tạo danh sách nhóm tài sản";
      emit(
        CreateReasonIncreaseBatchFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _update(
    UpdateReasonIncreaseEvent event,
    Emitter<ReasonIncreaseState> emit,
  ) async {
    emit(ReasonIncreaseInitialState());
    emit(ReasonIncreaseLoadingState());
    final result = await ReasonIncreaseRepository().updateReasonIncreaseRepository(
      event.params,
      event.id,
    );
    emit(ReasonIncreaseLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(UpdateReasonIncreaseSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi cập nhật nhóm tài sản',
        ),
      );
    }
  }

  Future<void> _delete(
    DeleteReasonIncreaseEvent event,
    Emitter<ReasonIncreaseState> emit,
  ) async {
    emit(ReasonIncreaseInitialState());
    emit(ReasonIncreaseLoadingState());
    final result = await ReasonIncreaseRepository().deleteReasonIncreaseRepository(
      event.id,
    );
    emit(ReasonIncreaseLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteReasonIncreaseSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa nhóm tài sản',
        ),
      );
    }
  }

  Future<void> _deleteBatch(
    DeleteReasonIncreaseBatchEvent event,
    Emitter<ReasonIncreaseState> emit,
  ) async {
    emit(ReasonIncreaseInitialState());
    emit(ReasonIncreaseLoadingState());
    final result = await ReasonIncreaseRepository().deleteReasonIncreaseBatch(event.ids);
    emit(ReasonIncreaseLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteReasonIncreaseSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa danh sách nhóm CCDC',
        ),
      );
    }
  }
}
