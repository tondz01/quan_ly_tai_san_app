import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';

import 'asset_transfer_event.dart';
import 'asset_transfer_state.dart';

class AssetTransferBloc extends Bloc<AssetTransferEvent, AssetTransferState> {
  AssetTransferBloc() : super(AssetTransferInitialState()) {
    on<GetListAssetTransferEvent>(_getListAssetTransfer);
  }

  Future<void> _getListAssetTransfer(GetListAssetTransferEvent event, Emitter emit) async {
    emit(AssetTransferInitialState());
    emit(AssetTransferLoadingState());
    Map<String, dynamic> result = await AssetTransferRepository().getListAssetTransfer(event.typeAssetTransfer);
    List<NhanVien> listNhanVien = await NhanVienProvider().fetchNhanViens();
    List<PhongBan> listPhongBan = await DepartmentsProvider().fetchDepartments();

    emit(AssetTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        GetListAssetTransferSuccessState(data: result['data'], listNhanVien: listNhanVien, listPhongBan: listPhongBan),
      );
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(GetListAssetTransferFailedState(title: "notice", code: result['status_code'], message: msg));
    }
  }
}