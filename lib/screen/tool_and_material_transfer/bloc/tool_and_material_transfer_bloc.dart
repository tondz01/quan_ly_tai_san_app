import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_repository.dart';

import 'tool_and_material_transfer_event.dart';
import 'tool_and_material_transfer_state.dart';

class ToolAndMaterialTransferBloc
    extends Bloc<ToolAndMaterialTransferEvent, ToolAndMaterialTransferState> {
  ToolAndMaterialTransferBloc() : super(ToolAndMaterialTransferInitialState()) {
    on<GetListToolAndMaterialTransferEvent>(_getListToolAndMaterialTransfer);
  }

  Future<void> _getListToolAndMaterialTransfer(
    GetListToolAndMaterialTransferEvent event,
    Emitter emit,
  ) async {
    emit(ToolAndMaterialTransferInitialState());
    emit(ToolAndMaterialTransferLoadingState());
    Map<String, dynamic> result = await ToolAndMaterialTransferRepository()
        .getListToolAndMaterialTransfer();  
    emit(ToolAndMaterialTransferLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        emit(GetListToolAndMaterialTransferSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListToolAndMaterialTransferFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
