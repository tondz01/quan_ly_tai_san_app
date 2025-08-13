import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san.dart';
import '../model/dieu_dong_tai_san_dto.dart';
import '../repository/dieu_dong_tai_san_repository.dart';
import 'dieu_dong_tai_san_event.dart'
    show DieuDongTaiSanEvent, GetListDieuDongTaiSanEvent;
import 'dieu_dong_tai_san_state.dart';

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
    List<DieuDongTaiSanDto> _dieuDongTaiSans = await DieuDongTaiSanRepository()
        .getAll(event.idCongTy.toString(), event.typeAssetTransfer);
    emit(DieuDongTaiSanLoadingDismissState());
    emit(GetListDieuDongTaiSanSuccessState(data: _dieuDongTaiSans));
  }


}
