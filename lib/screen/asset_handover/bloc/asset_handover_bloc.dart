// bloc/dieu_dong_tai_san_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/dieu_dong_tai_san_repository.dart';


class DieuDongTaiSanBloc
    extends Bloc<DieuDongTaiSanEvent, DieuDongTaiSanState> {
  DieuDongTaiSanBloc() : super(DieuDongTaiSanInitialState()) {
    on<GetListDieuDongTaiSanEvent>(_getListDieuDongTaiSan);
  }

  Future<void> _getListDieuDongTaiSan(
    GetListDieuDongTaiSanEvent event,
    Emitter emit,
  ) async {
    emit(DieuDongTaiSanInitialState());
    emit(DieuDongTaiSanLoadingState());
    try {
      final data = await DieuDongTaiSanRepository().getAll(event.idCongTy);

      emit(DieuDongTaiSanLoadingDismissState());
      emit(GetListDieuDongTaiSanSuccessState(data: data));
    } catch (e) {
      emit(DieuDongTaiSanLoadingDismissState());
      emit(
        GetListDieuDongTaiSanFailedState(
          title: "notice",
          code: Numeral.STATUS_CODE_403,
          message: e.toString(),
        ),
      );
    }
  }
}
