import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import 'asset_handover_event.dart';
import 'asset_handover_state.dart';

class AssetHandoverBloc extends Bloc<AssetHandoverEvent, AssetHandoverState> {
  AssetHandoverBloc() : super(AssetHandoverInitialState()) {
    on<GetListAssetHandoverEvent>(_getListAssetHandover);
    on<CreateAssetHandoverEvent>(_createAssetHandover);
    on<UpdateAssetHandoverEvent>(_updateAssetHandover);
    on<DeleteAssetHandoverEvent>(_deleteAssetHandover);
    on<UpdateSigningStatusEvent>(_updateSigningStatus);
    on<CancelAssetHandoverEvent>(_cancelAssetHandover);
    on<SendToSignerAsetHandoverEvent>(_sendToSigner);
  }

  Future<void> _getListAssetHandover(
    GetListAssetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());

    List<PhongBan> dataDepartment = [];
    List<NhanVien> dataStaff = [];
    List<AssetHandoverDto> dataAssetHandoverDto = [];
    List<DieuDongTaiSanDto> dataDieuDongTaiSanDto = [];

    Map<String, dynamic> result =
        await AssetHandoverRepository().getListAssetHandover();
    Map<String, dynamic> resultAssetTransfer =
        await AssetTransferRepository().getListDieuDongTaiSan();
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

  Future<void> _sendToSigner(
    SendToSignerAsetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());
    Map<String, dynamic> result = await AssetHandoverRepository().sendToSigner(
      event.params,
    );
    emit(AssetHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateAssetHandoverSuccessState(data: result['data'].toString()));
    } else {
      String msg = "Lỗi khi gửi lệnh điều động";
      emit(
        ErrorState(title: "notice", code: result['status_code'], message: msg),
      );
    }
  }

  Future<void> _createAssetHandover(
    CreateAssetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository()
        .createAssetHandover(
          event.request,
          event.listSignatory,
          event.listDetailAssetHandover,
        );

    final int? statusCode = result['status_code'] as int?;
    SGLog.error('tag statusCode', "message: $statusCode");
    if (statusCode == Numeral.STATUS_CODE_SUCCESS ||
        statusCode == Numeral.STATUS_CODE_SUCCESS_CREATE ||
        statusCode == Numeral.STATUS_CODE_DEFAULT) {
      emit(
        CreateAssetHandoverSuccessState(
          data: (result['data'] ?? '').toString(),
        ),
      );
    } else {
      emit(
        ErrorState(
          title: 'Tạo biên bản bàn giao',
          code: statusCode,
          message: 'Thất bại khi tạo biên bản bàn giao',
        ),
      );
    }
    emit(AssetHandoverLoadingDismissState());
  }

  Future<void> _updateAssetHandover(
    UpdateAssetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository()
        .updateAssetHandover(event.request, event.id);

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        UpdateAssetHandoverSuccessState(
          data: (result['data'] ?? '').toString(),
        ),
      );
    } else {
      emit(
        ErrorState(
          title: 'Cập nhật biên bản bàn giao',
          code: statusCode,
          message: 'Thất bại khi cập nhật biên bản bàn giao',
        ),
      );
    }
    emit(AssetHandoverLoadingDismissState());
  }

  Future<void> _deleteAssetHandover(
    DeleteAssetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverLoadingState());

    final Map<String, dynamic> result = await AssetHandoverRepository()
        .deleteAssetHandover(event.id);

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        DeleteAssetHandoverSuccessState(
          data: (result['data'] ?? '').toString(),
        ),
      );
    } else {
      emit(
        ErrorState(
          title: 'Xóa biên bản bàn giao',
          code: statusCode,
          message: 'Thất bại khi xóa biên bản bàn giao',
        ),
      );
    }
    emit(AssetHandoverLoadingDismissState());
  }

  Future<void> _updateSigningStatus(
    UpdateSigningStatusEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());
    Map<String, dynamic> result = await AssetHandoverRepository().updateState(
      event.id,
      event.userId,
      event.request,
      event.idDieuChuyen,
    );
    emit(AssetHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        UpdateSigningStatusSuccessState(
          isUpdateOwnershipUnit: result['data'] == result['data'],
        ),
      );
    } else {
      String msg = "Lỗi khi cập nhập trạng thái bàn giao ${result['message']}";
      emit(
        ErrorState(title: "notice", code: result['status_code'], message: msg),
      );
    }
  }

  // Bloc hủy phiếu ký nội sinh
  Future<void> _cancelAssetHandover(
    CancelAssetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(AssetHandoverInitialState());
    emit(AssetHandoverLoadingState());
    Map<String, dynamic> result = await AssetHandoverRepository()
        .cancelAssetHandover(event.id);
    emit(AssetHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CancelAssetHandoverSuccessState());
    } else {
      String msg =
          "Lỗi khi cập nhập trạng thái lệnh điều động ${result['message']}";
      emit(
        ErrorState(title: "notice", code: result['status_code'], message: msg),
      );
    }
  }
}
