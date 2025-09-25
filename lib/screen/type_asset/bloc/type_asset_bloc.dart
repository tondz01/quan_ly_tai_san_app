import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_state.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/repository/type_asset_repository.dart';

class TypeAssetBloc extends Bloc<TypeAssetEvent, TypeAssetState> {
  TypeAssetBloc() : super(TypeAssetInitialState()) {
    on<GetListTypeAssetEvent>(_getList);
    on<CreateTypeAssetEvent>(_create);
    on<CreateTypeAssetBatchEvent>(_createBatch);
    on<UpdateTypeAssetEvent>(_update);
    on<DeleteTypeAssetEvent>(_delete);
    on<DeleteTypeAssetBatchEvent>(_deleteBatch);
  }

  Future<void> _getList(
    GetListTypeAssetEvent event,
    Emitter emit,
  ) async {
    emit(TypeAssetInitialState());
    emit(TypeAssetLoadingState());
    final result = await TypeAssetRepository().getListTypeAssetRepository('CT001');
    emit(TypeAssetLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(GetListTypeAssetSuccessState(data: result['data']));
    } else {
      emit(
        GetListTypeAssetFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi lấy dữ liệu',
        ),
      );
    }
  }

  Future<void> _create(
    CreateTypeAssetEvent event,
    Emitter emit,
  ) async {
    emit(TypeAssetInitialState());
    emit(TypeAssetLoadingState());
    final result = await TypeAssetRepository().createTypeAssetRepository(event.params);
    emit(TypeAssetLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateTypeAssetSuccessState(data: result['data'].toString()));
    } else {
      emit(
        CreateTypeAssetFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi tạo loại tài sản',
        ),
      );
    }
  }

  Future<void> _createBatch(
    CreateTypeAssetBatchEvent event,
    Emitter emit,
  ) async {
    emit(TypeAssetInitialState());
    emit(TypeAssetLoadingState());
    final result = await TypeAssetRepository().saveTypeAssetBatch(event.params);
    emit(TypeAssetLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(CreateTypeAssetSuccessState(data: result['data'].toString()));
    } else {
      emit(
        CreateTypeAssetFailedState(
          title: 'notice',
          code: result['status_code'],
          message: 'Lỗi khi tạo danh sách loại tài sản',
        ),
      );
    }
  }

  Future<void> _update(
    UpdateTypeAssetEvent event,
    Emitter emit,
  ) async {
    emit(TypeAssetInitialState());
    emit(TypeAssetLoadingState());
    final result = await TypeAssetRepository().updateTypeAssetRepository(
      event.params,
      event.id,
    );
    emit(TypeAssetLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(UpdateTypeAssetSuccessState(data: result['data'].toString()));
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
    DeleteTypeAssetEvent event,
    Emitter emit,
  ) async {
    emit(TypeAssetInitialState());
    emit(TypeAssetLoadingState());
    final result = await TypeAssetRepository().deleteTypeAssetRepository(event.id);
    emit(TypeAssetLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteTypeAssetSuccessState(data: result['data'].toString()));
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
    DeleteTypeAssetBatchEvent event,
    Emitter emit,
  ) async {
    emit(TypeAssetInitialState());
    emit(TypeAssetLoadingState());
    final result = await TypeAssetRepository().deleteTypeAssetBatchIds(event.ids);
    emit(TypeAssetLoadingDismissState());
    if (checkStatusCodeDone(result)) {
      emit(DeleteTypeAssetSuccessState(data: result['data'].toString()));
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


