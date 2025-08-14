import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';

import 'asset_handover_event.dart';
import 'asset_handover_state.dart';

class AssetHandoverBloc extends Bloc<AssetHandoverEvent, AssetHandoverState> {
  AssetHandoverBloc() : super(AssetHandoverInitialState()) {
    on<GetListAssetHandoverEvent>(_getListAssetHandover);
    on<CreateAssetHandoverEvent>(_createAssetHandover);
  }

  Future<void> _getListAssetHandover(GetListAssetHandoverEvent event, Emitter emit) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());

    List<PhongBan> dataDepartment = [];
    List<NhanVien> dataStaff = [];
    List<AssetHandoverDto> dataAssetHandoverDto = [];
    List<DieuDongTaiSanDto> dataDieuDongTaiSanDto = [];

    Map<String, dynamic> result = await AssetHandoverRepository().getListAssetHandover();
    Map<String, dynamic> resultAssetTransfer = await AssetTransferRepository().getListDieuDongTaiSan("ct001");
    dataDepartment = await DepartmentsProvider().fetchDepartments();
    dataStaff = await NhanVienProvider().fetchNhanViens();
    dataAssetHandoverDto = result['data'];
    dataDieuDongTaiSanDto = resultAssetTransfer['data'];

    emit(AssetHandoverLoadingDismissState());

    emit(
      GetListAssetHandoverSuccessState(
        data: dataAssetHandoverDto,
        dataDepartment: dataDepartment,
        dataStaff: dataStaff,
        dataAssetTransfer: dataDieuDongTaiSanDto,
      ),
    );
  }

  Future<void> _createAssetHandover(CreateAssetHandoverEvent event, Emitter emit) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository().createAssetHandover(event.request);

    emit(AssetHandoverLoadingDismissState());

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateAssetHandoverSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(CreateAssetHandoverFailedState(
        title: 'Tạo biên bản bàn giao',
        code: statusCode,
        message: 'Thất bại khi tạo biên bản bàn giao',
      ));
    }
  }
}
