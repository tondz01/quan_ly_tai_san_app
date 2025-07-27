import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/asset_repository.dart';
import 'asset_event.dart';
import 'asset_state.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepository repository;

  List<DropdownMenuItem<int>> rowPerPageItems =
      [80, 100, 120, 140, 160, 180, 200].map((pageSize) {
        return DropdownMenuItem<int>(value: pageSize, child: Text('$pageSize'));
      }).toList();

  int defaultPageSize = 80;

  AssetBloc({required this.repository}) : super(AssetInitial()) {
    defaultPageSize = rowPerPageItems[0].value ?? 80;
    on<LoadAssets>(_onLoadAssets);
    on<LoadAssetsWithPagination>(_onLoadAssetsWithPagination);
    on<FilterAssets>(_onFilterAssets);
    on<GetAssetById>(_onGetAssetById);
    on<ChangePage>(_onChangePage);
  }

  Future<void> _onLoadAssets(LoadAssets event, Emitter<AssetState> emit) async {
    try {
      emit(AssetLoading());
      final assets = await repository.getAssets();
      emit(AssetLoaded(assets));
    } catch (e) {
      emit(AssetError(e.toString()));
    }
  }

  Future<void> _onLoadAssetsWithPagination(LoadAssetsWithPagination event, Emitter<AssetState> emit) async {
    try {
      emit(AssetLoading());
      final result = await repository.getAssetsWithPagination(
        page: event.page,
        pageSize: event.pageSize,
        searchQuery: event.searchQuery,
        department: event.department,
        assetType: event.assetType,
      );

      emit(AssetPaginatedLoaded.fromPaginationResult(result, searchQuery: event.searchQuery, department: event.department, assetType: event.assetType));
    } catch (e) {
      emit(AssetError(e.toString()));
    }
  }

  Future<void> _onFilterAssets(FilterAssets event, Emitter<AssetState> emit) async {
    try {
      emit(AssetLoading());

      // Nếu đang ở chế độ phân trang
      if (state is AssetPaginatedLoaded) {
        final result = await repository.getAssetsWithPagination(
          page: 1, // Trở về trang đầu tiên khi lọc
          pageSize: (state as AssetPaginatedLoaded).pageSize,
          searchQuery: event.searchQuery,
          department: event.department,
          assetType: event.assetType,
        );

        emit(AssetPaginatedLoaded.fromPaginationResult(result, searchQuery: event.searchQuery, department: event.department, assetType: event.assetType));
      } else {
        // Lọc bình thường nếu không phân trang
        final assets = await repository.filterAssets(searchQuery: event.searchQuery, department: event.department, assetType: event.assetType);
        emit(AssetLoaded(assets));
      }
    } catch (e) {
      emit(AssetError(e.toString()));
    }
  }

  Future<void> _onChangePage(ChangePage event, Emitter<AssetState> emit) async {
    if (state is AssetPaginatedLoaded) {
      final currentState = state as AssetPaginatedLoaded;

      try {
        emit(AssetLoading());
        final result = await repository.getAssetsWithPagination(
          page: event.page,
          pageSize: currentState.pageSize,
          searchQuery: currentState.searchQuery,
          department: currentState.department,
          assetType: currentState.assetType,
        );

        emit(AssetPaginatedLoaded.fromPaginationResult(result, searchQuery: currentState.searchQuery, department: currentState.department, assetType: currentState.assetType));
      } catch (e) {
        emit(AssetError(e.toString()));
      }
    }
  }

  Future<void> _onGetAssetById(GetAssetById event, Emitter<AssetState> emit) async {
    try {
      emit(AssetLoading());
      final asset = await repository.getAssetById(event.id);

      if (asset != null) {
        emit(AssetDetailLoaded(asset));
      } else {
        emit(const AssetError('Không tìm thấy tài sản'));
      }
    } catch (e) {
      emit(AssetError(e.toString()));
    }
  }
}
