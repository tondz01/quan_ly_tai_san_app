import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';

import 'tool_and_supplies_handover_event.dart';
import 'tool_and_supplies_handover_state.dart';

class ToolAndSuppliesHandoverBloc
    extends Bloc<ToolAndSuppliesHandoverEvent, ToolAndSuppliesHandoverState> {
  ToolAndSuppliesHandoverBloc() : super(ToolAndSuppliesHandoverInitialState()) {
    on<GetListToolAndSuppliesHandoverEvent>(_getListToolAndSuppliesHandover);
    on<CreateToolAndSuppliesHandoverEvent>(_createToolAndSuppliesHandover);
    on<UpdateToolAndSuppliesHandoverEvent>(_updateToolAndSuppliesHandover);
    on<DeleteToolAndSuppliesHandoverEvent>(_deleteToolAndSuppliesHandover);
    on<UpdateSigningStatusCcdcEvent>(_updateSigningStatus);
    on<CancelToolAndSuppliesHandoverEvent>(_cancelToolAndSuppliesHandover);
    on<SendToSignerAsetHandoverEvent>(_sendToSigner);
  }

  Future<void> _getListToolAndSuppliesHandover(
    GetListToolAndSuppliesHandoverEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverInitialState());
    emit(ToolAndSuppliesHandoverLoadingState());

    List<PhongBan> dataDepartment = [];
    List<NhanVien> dataStaff = [];
    List<ToolAndSuppliesHandoverDto> dataToolAndSuppliesHandoverDto = [];
    List<ToolAndMaterialTransferDto> dataDieuDongTaiSanDto = [];
    List<ToolsAndSuppliesDto> dataCcdc = [];
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
    Map<String, dynamic> result =
        await ToolAndSuppliesHandoverRepository()
            .getListToolAndSuppliesHandover();

    dataDieuDongTaiSanDto = await ToolAndMaterialTransferRepository()
        .getAllToolAndMeterialTransfer(null);

    Map<String, dynamic> resultCcdc = await ToolsAndSuppliesRepository()
        .getListToolsAndSupplies(userInfo.idCongTy);

    dataDepartment = await DepartmentsProvider().fetchDepartments();
    dataStaff = await NhanVienProvider().fetchNhanViens();
    dataToolAndSuppliesHandoverDto = result['data'];
    dataCcdc = resultCcdc['data'];

    emit(ToolAndSuppliesHandoverLoadingDismissState());

    emit(
      GetListToolAndSuppliesHandoverSuccessState(
        data: dataToolAndSuppliesHandoverDto,
        dataDepartment: dataDepartment,
        dataStaff: dataStaff,
        dataCcdcransfer: dataDieuDongTaiSanDto,
        dataCcdc: dataCcdc,
      ),
    );
  }

  Future<void> _sendToSigner(
    SendToSignerAsetHandoverEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverInitialState());
    emit(ToolAndSuppliesHandoverLoadingState());
    Map<String, dynamic> result = await ToolAndSuppliesHandoverRepository()
        .sendToSigner(event.params);
    emit(ToolAndSuppliesHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        UpdateToolAndSuppliesHandoverSuccessState(
          data: result['data'].toString(),
        ),
      );
    } else {
      String msg = "Lỗi khi gửi lệnh điều động";
      emit(
        ErrorState(title: "notice", code: result['status_code'], message: msg),
      );
    }
  }

  Future<void> _createToolAndSuppliesHandover(
    CreateToolAndSuppliesHandoverEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverLoadingState());

    final Map<String, dynamic> result =
        await ToolAndSuppliesHandoverRepository().createToolAndSuppliesHandover(
          event.request,
          event.listSignatory,
        );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        CreateToolAndSuppliesHandoverSuccessState(
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
    emit(ToolAndSuppliesHandoverLoadingDismissState());
  }

  Future<void> _updateToolAndSuppliesHandover(
    UpdateToolAndSuppliesHandoverEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverLoadingState());

    final Map<String, dynamic> result =
        await ToolAndSuppliesHandoverRepository().updateToolAndSuppliesHandover(
          event.request,
        );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        UpdateToolAndSuppliesHandoverSuccessState(
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
    emit(ToolAndSuppliesHandoverLoadingDismissState());
  }

  Future<void> _deleteToolAndSuppliesHandover(
    DeleteToolAndSuppliesHandoverEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverLoadingState());

    final Map<String, dynamic> result =
        await ToolAndSuppliesHandoverRepository().deleteToolAndSuppliesHandover(
          event.id,
        );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        DeleteToolAndSuppliesHandoverSuccessState(
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
    emit(ToolAndSuppliesHandoverLoadingDismissState());
  }

  Future<void> _updateSigningStatus(
    UpdateSigningStatusCcdcEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverInitialState());
    emit(ToolAndSuppliesHandoverLoadingState());
    Map<String, dynamic> result = await ToolAndSuppliesHandoverRepository()
        .updateState(event.id, event.userId);
    emit(ToolAndSuppliesHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(
        UpdateSigningStatusSuccessState(
          isUpdateOwnershipUnit: result['data'] == '2',
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
  Future<void> _cancelToolAndSuppliesHandover(
    CancelToolAndSuppliesHandoverEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndSuppliesHandoverInitialState());
    emit(ToolAndSuppliesHandoverLoadingState());
    Map<String, dynamic> result = await ToolAndSuppliesHandoverRepository()
        .cancelToolAndSuppliesHandover(event.id);
    emit(ToolAndSuppliesHandoverLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CancelToolAndSuppliesHandoverSuccessState());
    } else {
      String msg =
          "Lỗi khi cập nhập trạng thái lệnh điều động ${result['message']}";
      emit(
        ErrorState(title: "notice", code: result['status_code'], message: msg),
      );
    }
  }
}
