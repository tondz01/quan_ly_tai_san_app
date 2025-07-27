import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';

import 'tools_and_supplies_event.dart';
import 'tools_and_supplies_state.dart';

class ToolsAndSuppliesBloc
    extends Bloc<ToolsAndSuppliesEvent, ToolsAndSuppliesState> {
  ToolsAndSuppliesBloc() : super(ToolsAndSuppliesInitialState()) {
    on<GetListToolsAndSuppliesEvent>(_getListToolsAndSupplies);
  }

  Future<void> _getListToolsAndSupplies(
    GetListToolsAndSuppliesEvent event,
    Emitter emit,
  ) async {
    emit(ToolsAndSuppliesInitialState());
    emit(ToolsAndSuppliesLoadingState());
    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .getListToolsAndSupplies();  
    emit(ToolsAndSuppliesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListToolsAndSuppliesSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListToolsAndSuppliesFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
