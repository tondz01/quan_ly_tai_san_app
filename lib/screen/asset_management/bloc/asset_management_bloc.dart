import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'asset-management_event.dart';
import 'asset_management_state.dart';

class AssetManagementBloc
    extends Bloc<AssetManagementEvent, AssetManagementState> {
  AssetManagementBloc() : super(AssetManagementInitialState()) {
    on<GetListAssetManagementEvent>(_getListAssetManagement);
    // on<CreateAssetManagementEvent>(_createAssetManagement);
  }
}

Future<void> _getListAssetManagement(
  GetListAssetManagementEvent event,
  Emitter emit,
) async {
  emit(AssetManagementInitialState());
  emit(AssetManagementLoadingState());
  Map<String, dynamic> result = await AssetManagementRepository()
      .getListAssetManagement(event.idCongTy);
  emit(AssetManagementLoadingDismissState());
  if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
    emit(
      GetListAssetManagementSuccessState(data: result['data']),
    );
  } else {
    String msg = "Lỗi khi lấy dữ liệu";
    emit(
      GetListAssetManagementFailedState(
        title: "notice",
        code: result['status_code'],
        message: msg,
      ),
    );
  }
}
