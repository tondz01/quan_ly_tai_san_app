
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/repository/ccdc_group_repository.dart';

class CcdcGroupBloc extends Bloc<CcdcGroupEvent, CcdcGroupState> {
  CcdcGroupBloc() : super(CcdcGroupInitialState()) {
    on<GetListCcdcGroupEvent>(_getListCcdcTransfer);
    on<CreateCcdcGroupEvent>(_createCcdcGroup);
    on<UpdateCcdcGroupEvent>(_updateCcdcGroup);
    on<DeleteCcdcGroupEvent>(_deleteCcdcGroup);
  }

  Future<void> _getListCcdcTransfer(
    GetListCcdcGroupEvent event,
    Emitter emit,
  ) async {
    emit(CcdcGroupInitialState());
    emit(CcdcGroupLoadingState());
    Map<String, dynamic> result =
        await CcdcGroupRepository().getListCcdcGroupRepository();
    emit(CcdcGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListCcdcGroupSuccessState(data: result['data']));
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
    Map<String, dynamic> result = await CcdcGroupRepository().createCcdcGroupRepository(
      event.params,
    );
    emit(CcdcGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
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
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
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
    final result = await CcdcGroupRepository().deleteCcdcGroupRepository(event.id);
    emit(CcdcGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
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
}
