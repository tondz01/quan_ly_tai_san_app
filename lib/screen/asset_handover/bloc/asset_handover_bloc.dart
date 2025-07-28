import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';

import 'asset_handover_event.dart';
import 'asset_handover_state.dart';

class AssetHandoverBloc
    extends Bloc<AssetHandoverEvent, AssetHandoverState> {
  AssetHandoverBloc() : super(AssetHandoverInitialState()) {
    on<GetListAssetHandoverEvent>(_getListAssetHandover);
  }

  Future<void> _getListAssetHandover(
    GetListAssetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());
    Map<String, dynamic> result = await AssetHandoverRepository()
        .getListAssetHandover();  
    emit(AssetHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetHandoverSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListAssetHandoverFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
