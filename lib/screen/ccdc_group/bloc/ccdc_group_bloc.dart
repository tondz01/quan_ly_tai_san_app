import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/repository/ccdc_group_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class CcdcGroupBloc extends Bloc<CcdcGroupEvent, CcdcGroupState> {
  CcdcGroupBloc() : super(CcdcGroupInitialState()) {
    on<GetListCcdcGroupEvent>(_getListCcdcTransfer);
    on<CreateCcdcGroupEvent>(_createCcdcGroup);
    on<CreateCcdcGroupBatchEvent>(_createCcdcGroupBatch);
    on<UpdateCcdcGroupEvent>(_updateCcdcGroup);
    on<DeleteCcdcGroupEvent>(_deleteCcdcGroup);
    on<DeleteCcdcGroupBatchEvent>(_deleteCcdcGroupBatch);
  }

  Future<void> _getListCcdcTransfer(
    GetListCcdcGroupEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    Map<String, dynamic> result = await CcdcGroupRepository()
        .getListCcdcGroupRepository('CT001');
    emit(CcdcGroupLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListCcdcGroupSuccessState(data: result['data']));
      AccountHelper.instance.setCcdcGroup(result['data']);
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListCcdcGroupFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createCcdcGroup(
    CreateCcdcGroupEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    Map<String, dynamic> result = await CcdcGroupRepository()
        .createCcdcGroupRepository(event.params);
    emit(CcdcGroupLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateCcdcGroupSuccessState(data: result['data'].toString()));
    } else {
      String msg = "Lỗi khi tạo nhóm tài sản";
      emit(
        CreateCcdcGroupFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createCcdcGroupBatch(
    CreateCcdcGroupBatchEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    Map<String, dynamic> result = await CcdcGroupRepository()
        .saveCcdcGroupBatch(event.params);
    emit(CcdcGroupLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(
        CreateCcdcGroupBatchSuccessState(
          message: "Thêm danh sách nhóm tài sản thành công",
        ),
      );
    } else {
      String msg = "Lỗi khi tạo danh sách nhóm tài sản";
      emit(
        CreateCcdcGroupBatchFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  //CALL API UPDATE
  Future<void> _updateCcdcGroup(
    UpdateCcdcGroupEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    final result = await CcdcGroupRepository().updateCcdcGroupRepository(
      event.params,
      event.id,
    );
    emit(CcdcGroupLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(UpdateCcdcGroupSuccessState(data: result['data'].toString()));
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

  //CALL API UPDATE
  Future<void> _deleteCcdcGroup(
    DeleteCcdcGroupEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    final result = await CcdcGroupRepository().deleteCcdcGroupRepository(
      event.id,
    );
    emit(CcdcGroupLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteCcdcGroupSuccessState(data: result['data'].toString()));
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

  Future<void> _deleteCcdcGroupBatch(
    DeleteCcdcGroupBatchEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    final result = await CcdcGroupRepository().deleteCcdcGroupBatch(event.id);
    emit(CcdcGroupLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteCcdcGroupSuccessState(data: result['data'].toString()));
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
