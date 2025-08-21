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
    on<UpdateAssetHandoverEvent>(_updateAssetHandover);
    on<DeleteAssetHandoverEvent>(_deleteAssetHandover);
    on<UpdateSigningStatusEvent>(_updateSigningStatus);
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

    emit(GetListAssetHandoverSuccessState(data: dataAssetHandoverDto, dataDepartment: dataDepartment, dataStaff: dataStaff, dataAssetTransfer: dataDieuDongTaiSanDto));
  }

  Future<void> _createAssetHandover(CreateAssetHandoverEvent event, Emitter emit) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository().createAssetHandover(event.request);

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateAssetHandoverSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(ErrorState(title: 'Tạo biên bản bàn giao', code: statusCode, message: 'Thất bại khi tạo biên bản bàn giao'));
    }
    emit(AssetHandoverLoadingDismissState());
  }

  Future<void> _updateAssetHandover(UpdateAssetHandoverEvent event, Emitter emit) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository().updateAssetHandover(event.request, event.id);

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateAssetHandoverSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(ErrorState(title: 'Cập nhật biên bản bàn giao', code: statusCode, message: 'Thất bại khi cập nhật biên bản bàn giao'));
    }
    emit(AssetHandoverLoadingDismissState());
  }

  Future<void> _deleteAssetHandover(DeleteAssetHandoverEvent event, Emitter emit) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository().deleteAssetHandover(event.id);

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteAssetHandoverSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(ErrorState(title: 'Xóa biên bản bàn giao', code: statusCode, message: 'Thất bại khi xóa biên bản bàn giao'));
    }
    emit(AssetHandoverLoadingDismissState());
  }

  Future<void> _updateSigningStatus(
    UpdateSigningStatusEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());
    Map<String, dynamic> result = await AssetHandoverRepository().updateStateUserSignature(
      event.userId,
      event.docId,
    );
    emit(AssetHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateSigningStatusSuccessState());
    } else {
      String msg = "Lỗi khi cập nhập trạng thái bàn giao ${result['message']}";
      emit(
        ErrorState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
