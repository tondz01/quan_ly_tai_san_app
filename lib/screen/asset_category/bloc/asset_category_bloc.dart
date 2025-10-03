import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/constants/asset_category_constants.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/repository/asset_category_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import 'asset_category_event.dart';
import 'asset_category_state.dart';

class AssetCategoryBloc extends Bloc<AssetCategoryEvent, AssetCategoryState> {
  List<AssetCategoryDto> _allAssetCategories = [];
  final repository = AssetCategoryRepository();
  
  AssetCategoryBloc() : super(AssetCategoryInitialState()) {
    on<GetListAssetCategoryEvent>(_getListAssetTransfer);
    on<CreateAssetCategoryEvent>(_createAssetCategory);
    on<UpdateAssetCategoryEvent>(_updateAssetCategory);
    on<DeleteAssetCategoryEvent>(_deleteAssetCategory);
    on<SearchAssetCategoryEvent>(_searchAssetCategory);
    on<DeleteAssetCategoryBatchEvent>(_deleteAssetCategoryBatch);
  }

  Future<void> _getListAssetTransfer(
    GetListAssetCategoryEvent event,
    Emitter emit,
  ) async {
    emit(AssetCategoryLoadingState());
    try {
      Map<String, dynamic> result = await repository.getListAssetCategory(event.idCongty);
      if (checkStatusCodeDone(result)) {
        _allAssetCategories = result['data'];
        emit(AssetCategoryLoaded(_allAssetCategories));
      } else {
        String msg = "Lỗi khi lấy dữ liệu ${result['message']}";
        SGLog.error('AssetCategoryBloc', 'GetListAssetCategory error: $msg');
        emit(AssetCategoryError(msg));
      }
    } catch (e) {
      SGLog.error('AssetCategoryBloc', 'GetListAssetCategory error: $e');
      emit(AssetCategoryError(AssetCategoryConstants.errorLoadAssetCategories));
    }
  }

  Future<void> _createAssetCategory(
    CreateAssetCategoryEvent event,
    Emitter emit,
  ) async {
    try {
      Map<String, dynamic> result = await repository.createAssetCategory(event.params);
      if (checkStatusCodeDone(result)) {
        emit(AddAssetCategorySuccess(AssetCategoryConstants.successAddAssetCategory));
        add(GetListAssetCategoryEvent(event.context, 'ct001'));
      } else {
        emit(AssetCategoryError(result['message'] ?? AssetCategoryConstants.errorAddAssetCategory));
      }
    } catch (e) {
      SGLog.error('AssetCategoryBloc', 'CreateAssetCategory error: $e');
      emit(AssetCategoryError(AssetCategoryConstants.errorAddAssetCategory));
    }
  }

  Future<void> _updateAssetCategory(
    UpdateAssetCategoryEvent event,
    Emitter emit,
  ) async {
    try {
      final result = await repository.updateAssetCategory(event.params, event.id);
      if (checkStatusCodeDone(result)) {
        emit(UpdateAssetCategorySuccess(AssetCategoryConstants.successUpdateAssetCategory));
        add(GetListAssetCategoryEvent(event.context, 'ct001'));
      } else {
        emit(AssetCategoryError(result['message'] ?? AssetCategoryConstants.errorUpdateAssetCategory));
      }
    } catch (e) {
      SGLog.error('AssetCategoryBloc', 'UpdateAssetCategory error: $e');
      emit(AssetCategoryError(AssetCategoryConstants.errorUpdateAssetCategory));
    }
  }

  Future<void> _deleteAssetCategory(
    DeleteAssetCategoryEvent event,
    Emitter emit,
  ) async {
    try {
      final result = await repository.deleteAssetCategory(event.id);
      if (checkStatusCodeDone(result)) {
        emit(DeleteAssetCategorySuccess(AssetCategoryConstants.successDeleteAssetCategory));
        add(GetListAssetCategoryEvent(event.context, 'ct001'));
      } else {
        emit(AssetCategoryError(result['message'] ?? AssetCategoryConstants.errorDeleteAssetCategory));
      }
    } catch (e) {
      SGLog.error('AssetCategoryBloc', 'DeleteAssetCategory error: $e');
      emit(AssetCategoryError(AssetCategoryConstants.errorDeleteAssetCategory));
    }
  }

  Future<void> _searchAssetCategory(
    SearchAssetCategoryEvent event,
    Emitter emit,
  ) async {
    final searchLower = event.keyword.toLowerCase();
    final filtered = _allAssetCategories.where((item) {
      bool nameMatch = AppUtility.fuzzySearch(
        item.tenMoHinh?.toLowerCase() ?? '',
        searchLower,
      );
      bool idMatch = (item.id?.toLowerCase().contains(searchLower)) ?? false;
      bool companyMatch = (item.idCongTy?.toLowerCase().contains(searchLower)) ?? false;
      bool methodMatch = (item.loaiKyKhauHao?.toLowerCase().contains(searchLower)) ?? false;
      
      return nameMatch || idMatch || companyMatch || methodMatch;
    }).toList();
    emit(AssetCategoryLoaded(filtered));
  }

  Future<void> _deleteAssetCategoryBatch(
    DeleteAssetCategoryBatchEvent event,
    Emitter emit,
  ) async {
    try {
      // Xóa từng item một vì API batch có thể không tồn tại
      int successCount = 0;
      int failCount = 0;
      List<String> errors = [];

      for (String id in event.data) {
        try {
          final result = await repository.deleteAssetCategory(id);
          if (checkStatusCodeDone(result)) {
            successCount++;
          } else {
            failCount++;
            errors.add('ID $id: ${result['message'] ?? 'Lỗi không xác định'}');
          }
        } catch (e) {
          failCount++;
          errors.add('ID $id: $e');
        }
      }

      if (failCount == 0) {
        emit(DeleteAssetCategoryBatchSuccess());
        add(GetListAssetCategoryEvent(event.context, 'ct001'));
      } else if (successCount > 0) {
        emit(DeleteAssetCategoryBatchSuccess());
        add(GetListAssetCategoryEvent(event.context, 'ct001'));
      } else {
        emit(DeleteAssetCategoryBatchFailure('Xóa thất bại tất cả mô hình tài sản. Lỗi: ${errors.join(', ')}'));
      }
    } catch (e) {
      SGLog.error('AssetCategoryBloc', 'DeleteAssetCategoryBatch error: $e');
      emit(DeleteAssetCategoryBatchFailure(AssetCategoryConstants.errorDeleteAssetCategory));
    }
  }
}
