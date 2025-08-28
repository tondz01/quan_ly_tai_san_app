import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/repository/asset_group_repository.dart';
import 'ccdc_group_event.dart';
import 'ccdc_group_state.dart';

class CcdcGroupBloc extends Bloc<CcdcGroupEvent, CcdcGroupState> {
  CcdcGroupBloc() : super(AssetGroupInitialState()) {
    on<GetListAssetGroupEvent>(_getListAssetTransfer);
    on<CreateAssetGroupEvent>(_createAssetGroup);
    on<UpdateAssetGroupEvent>(_updateAssetGroup);
    on<DeleteAssetGroupEvent>(_deleteAssetGroup);
  }

  Future<void> _getListAssetTransfer(
    GetListAssetGroupEvent event,
    Emitter emit,
  ) async {
    emit(AssetGroupInitialState());
    emit(AssetGroupLoadingState());
    Map<String, dynamic> result =
        await AssetGroupRepository().getListAssetGroup();
    emit(AssetGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetGroupSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListAssetGroupFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createAssetGroup(
    CreateAssetGroupEvent event,
    Emitter emit,
  ) async {
    emit(AssetGroupInitialState());
    emit(AssetGroupLoadingState());
    Map<String, dynamic> result = await AssetGroupRepository().createAssetGroup(
      event.params,
    );
    emit(AssetGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateAssetGroupSuccessState(data: result['data'].toString()));
    } else {
      String msg = "Lỗi khi tạo nhóm tài sản";
      emit(
        CreateAssetGroupFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  //CALL API UPDATE
  Future<void> _updateAssetGroup(
    UpdateAssetGroupEvent event,
    Emitter emit,
  ) async {
    emit(AssetGroupInitialState());
    emit(AssetGroupLoadingState());
    final result = await AssetGroupRepository().updateAssetGroup(
      event.params,
      event.id,
    );
    emit(AssetGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateAssetGroupSuccessState(data: result['data'].toString()));
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
  Future<void> _deleteAssetGroup(
    DeleteAssetGroupEvent event,
    Emitter emit,
  ) async {
    emit(AssetGroupInitialState());
    emit(AssetGroupLoadingState());
    final result = await AssetGroupRepository().deleteAssetGroup(event.id);
    emit(AssetGroupLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteAssetGroupSuccessState(data: result['data'].toString()));
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
