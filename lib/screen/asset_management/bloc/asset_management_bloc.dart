import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'asset_management_event.dart';
import 'asset_management_state.dart';

class AssetManagementBloc
    extends Bloc<AssetManagementEvent, AssetManagementState> {
  AssetManagementBloc() : super(AssetManagementInitialState()) {
    on<GetListAssetManagementEvent>((event, emit) async {
      await _getListAssetManagement(event, emit);
    });
    on<GetListAssetGroupEvent>((event, emit) async {
      await _getListAssetGroup(event, emit);
    });
    on<GetListProjectEvent>((event, emit) async {
      await _getListProject(event, emit);
    });
    on<GetListCapitalSourceEvent>((event, emit) async {
      await _getListCapitalSource(event, emit);
    });
    on<GetListDepartmentEvent>((event, emit) async {
      await _getListDepartment(event, emit);
    });
    on<CreateAssetEvent>((event, emit) async {
      await _createAsset(event, emit);
    });
  }

  Future<void> _getListAssetManagement(
    GetListAssetManagementEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListAssetManagement(event.idCongTy);
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetManagementSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListAssetManagementFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _getListAssetGroup(
    GetListAssetGroupEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListAssetGroup(event.idCongTy);
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListAssetGroupSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu asset group";
      emit(
        GetListAssetGroupFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _getListProject(GetListProjectEvent event, Emitter emit) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository().getListDuAn(
      event.idCongTy,
    );
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListProjectSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu project";
      emit(
        GetListProjectFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _getListCapitalSource(
    GetListCapitalSourceEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListCapitalSource(event.idCongTy);
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListCapitalSourceSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu nguồn kinh phí";
      emit(
        GetListCapitalSourceFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _getListDepartment(
    GetListDepartmentEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListDepartment(event.idCongTy);
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListDepartmentSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu phòng ban";
      emit(
        GetListDepartmentFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  ///CREATE
  Future<void> _createAsset(
    CreateAssetEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository().createAsset(
      event.request,
    );
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateAssetSuccessState());
    } else {
      String msg = "Lỗi khi tạo nhóm tài sản";
      emit(
        CreateAssetFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }
}
