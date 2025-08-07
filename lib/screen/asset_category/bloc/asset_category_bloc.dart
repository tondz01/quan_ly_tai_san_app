import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/repository/asset_category_repository.dart';

import 'asset_category_event.dart';
import 'asset_category_state.dart';

class AssetCategoryBloc extends Bloc<AssetCategoryEvent, AssetCategoryState> {
  AssetCategoryBloc() : super(AssetCategoryInitialState()) {
    on<GetListAssetCategoryEvent>(_getListAssetTransfer);
  }

  Future<void> _getListAssetTransfer(
    GetListAssetCategoryEvent event,
    Emitter emit,
  ) async {
    emit(AssetCategoryInitialState());
    emit(AssetCategoryLoadingState());
    Map<String, dynamic> result = await AssetCategoryRepository()
        .getListAssetCategory(event.idCongty);
    emit(AssetCategoryLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetCategorySuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu ${result['status_code']}";
      log('message result ${result['status_code']}');
      emit(
        GetListAssetCategoryFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
