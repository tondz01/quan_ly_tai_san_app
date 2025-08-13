import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import '../model/dieu_dong_tai_san_dto.dart';
import '../repository/dieu_dong_tai_san_repository.dart';
import 'dieu_dong_tai_san_event.dart'
    show DieuDongTaiSanEvent, GetListAssetEvent, GetListDieuDongTaiSanEvent;
import 'dieu_dong_tai_san_state.dart';

class DieuDongTaiSanBloc
    extends Bloc<DieuDongTaiSanEvent, DieuDongTaiSanState> {
  DieuDongTaiSanBloc() : super(DieuDongTaiSanInitialState()) {
    on<GetListDieuDongTaiSanEvent>(_getListDieuDongTaiSan);
    on<GetListAssetEvent>(_getListAsset);
  }

  Future<void> _getListDieuDongTaiSan(
    GetListDieuDongTaiSanEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    List<DieuDongTaiSanDto> _dieuDongTaiSans = await DieuDongTaiSanRepository()
        .getAll(event.idCongTy.toString(), event.typeAssetTransfer);
    emit(DieuDongTaiSanLoadingDismissState());
    emit(GetListDieuDongTaiSanSuccessState(data: _dieuDongTaiSans));
  }

  Future<void> _getListAsset(
    GetListAssetEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListAssetManagement(event.idCongTy);
    emit(DieuDongTaiSanLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListAssetFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
