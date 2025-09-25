import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_state.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/repository/type_ccdc_repository.dart';

class TypeCcdcBloc extends Bloc<TypeCcdcEvent, TypeCcdcState> {
  TypeCcdcBloc() : super(TypeCcdcInitialState()) {
    on<GetListTypeCcdcEvent>(_getList);
    on<CreateTypeCcdcEvent>(_create);
    on<CreateTypeCcdcBatchEvent>(_createBatch);
    on<UpdateTypeCcdcEvent>(_update);
    on<DeleteTypeCcdcEvent>(_delete);
    on<DeleteTypeCcdcBatchEvent>(_deleteBatch);
  }

  Future<void> _getList(GetListTypeCcdcEvent event, Emitter emit) async {
    emit(TypeCcdcInitialState());
    emit(TypeCcdcLoadingState());
    final result = await TypeCcdcRepository().getListTypeCcdcRepository(
      'CT001',
    );
    emit(TypeCcdcLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListTypeCcdcSuccessState(data: result['data']));
    } else {
      emit(
        GetListTypeCcdcFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi lấy dữ liệu',
        ),
      );
    }
  }

  Future<void> _create(CreateTypeCcdcEvent event, Emitter emit) async {
    emit(TypeCcdcInitialState());
    emit(TypeCcdcLoadingState());
    final result = await TypeCcdcRepository().createTypeCcdcRepository(
      event.params,
    );
    emit(TypeCcdcLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateTypeCcdcSuccessState(data: result['data'].toString()));
    } else {
      emit(
        CreateTypeCcdcFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi tạo loại CCDC',
        ),
      );
    }
  }

  Future<void> _createBatch(
    CreateTypeCcdcBatchEvent event,
    Emitter emit,
  ) async {
    emit(TypeCcdcInitialState());
    emit(TypeCcdcLoadingState());
    final result = await TypeCcdcRepository().saveTypeCcdcBatch(event.params);
    emit(TypeCcdcLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateTypeCcdcSuccessState(data: result['data'].toString()));
    } else {
      emit(
        CreateTypeCcdcFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi tạo danh sách loại CCDC',
        ),
      );
    }
  }

  Future<void> _update(UpdateTypeCcdcEvent event, Emitter emit) async {
    emit(TypeCcdcInitialState());
    emit(TypeCcdcLoadingState());
    final result = await TypeCcdcRepository().updateTypeCcdcRepository(
      event.params,
      event.id,
    );
    emit(TypeCcdcLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(UpdateTypeCcdcSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi cập nhật loại CCDC',
        ),
      );
    }
  }

  Future<void> _delete(DeleteTypeCcdcEvent event, Emitter emit) async {
    emit(TypeCcdcInitialState());
    emit(TypeCcdcLoadingState());
    final result = await TypeCcdcRepository().deleteTypeCcdcRepository(
      event.id,
    );
    emit(TypeCcdcLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteTypeCcdcSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa loại CCDC',
        ),
      );
    }
  }

  Future<void> _deleteBatch(
    DeleteTypeCcdcBatchEvent event,
    Emitter emit,
  ) async {
    emit(TypeCcdcInitialState());
    emit(TypeCcdcLoadingState());
    final result = await TypeCcdcRepository().deleteTypeCcdcBatchIds(event.ids);
    emit(TypeCcdcLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteTypeCcdcSuccessState(data: result['data'].toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi xóa danh sách loại CCDC',
        ),
      );
    }
  }
}
