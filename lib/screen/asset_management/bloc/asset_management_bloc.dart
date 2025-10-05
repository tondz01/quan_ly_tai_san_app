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
    // on<GetListChildAssetsEvent>((event, emit) async {
    //   await _getListChildAssets(event, emit);
    // });
    on<GetListKhauHaoEvent>((event, emit) async {
      await _getListKhauHao(event, emit);
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
    on<GetAllChildAssetsEvent>((event, emit) async {
      await _getAllChildAssets(event, emit);
    });
    on<CreateAssetEvent>((event, emit) async {
      await _createAsset(event, emit);
    });
    on<CreateAssetBatchEvent>((event, emit) async {
      await _createAssetBatch(event, emit);
    });
    on<UpdateAssetEvent>((event, emit) async {
      await _updateAsset(event, emit);
    });
    on<DeleteAssetEvent>((event, emit) async {
      await _deleteAsset(event, emit);
    });
    on<DeleteAssetBatchEvent>((event, emit) async {
      await _deleteAssetBatch(event, emit);
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
      // log('message test: ${result['data']}');
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

  // CALL API GET LIST KHẤU HAO
  Future<void> _getListKhauHao(GetListKhauHaoEvent event, Emitter emit) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListKhauHao(event.idCongTy);
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListKhauHaoSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListKhauHaoFailedState(
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
        GetListKhauHaoFailedState(
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

  Future<void> _getAllChildAssets(
    GetAllChildAssetsEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository()
        .getAllChildAssets(event.idCongTy);
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetAllChildAssetsSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu tài sản con";
      emit(
        GetAllChildAssetsFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  ///CREATE
  Future<void> _createAsset(CreateAssetEvent event, Emitter emit) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository().createAsset(
      event.request,
      event.childAssets,
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

  ///CREATE BATCH
  Future<void> _createAssetBatch(
    CreateAssetBatchEvent event,
    Emitter emit,
  ) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());

    final Map<String, dynamic> result = await AssetManagementRepository()
        .createAssetBatch(event.params);

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS ||
        statusCode == Numeral.STATUS_CODE_SUCCESS_CREATE) {
      emit(CreateAssetSuccessState());
    } else {
      String msg =
          'Thất bại khi lưu danh sách tài sản';
      emit(
        CreateAssetFailedState(
          title: 'Tạo tài sản',
          code: statusCode,
          message: msg,
        ),
      );
    }
    emit(AssetManagementLoadingDismissState());
  }

  ///UPDATE
  Future<void> _updateAsset(UpdateAssetEvent event, Emitter emit) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository().updateAsset(
      event.id,
      event.request,
    );
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateAssetSuccessState());
    } else {
      String msg = "Lỗi khi tạo nhóm tài sản";
      emit(
        UpdateAndDeleteAssetFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _deleteAsset(DeleteAssetEvent event, Emitter emit) async {
    emit(AssetManagementInitialState());
    emit(AssetManagementLoadingState());
    Map<String, dynamic> result = await AssetManagementRepository().deleteAsset(
      event.id,
    );
    emit(AssetManagementLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteAssetSuccessState());
    } else {
      String msg = "Lỗi khi xóa tài sản";
      emit(
        UpdateAndDeleteAssetFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _deleteAssetBatch(DeleteAssetBatchEvent event, Emitter emit) async {
    emit(AssetManagementLoadingState());

    final Map<String, dynamic> result = await AssetManagementRepository().deleteAssetBatch(
      event.id,
    );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteAssetSuccessState());
    } else {
      emit(
        UpdateAndDeleteAssetFailedState(
          title: 'Xóa tài sản',
          code: statusCode,
          message: 'Thất bại khi xóa tài sản',
        ),
      );
    }
    emit(AssetManagementLoadingDismissState());
  }
}
