import 'package:equatable/equatable.dart';

abstract class ManagementAssetEvent extends Equatable {
  const ManagementAssetEvent();

  @override
  List<Object?> get props => [];
}

class LoadAssets extends ManagementAssetEvent {
  const LoadAssets();
}

class LoadAssetsWithPagination extends ManagementAssetEvent {
  final int page;
  final int pageSize;
  final String? searchQuery;
  final String? department;
  final String? assetType;

  const LoadAssetsWithPagination({
    required this.page,
    required this.pageSize,
    this.searchQuery,
    this.department,
    this.assetType,
  });

  @override
  List<Object?> get props => [page, pageSize, searchQuery, department, assetType];
}

class FilterAssets extends ManagementAssetEvent {
  final String? searchQuery;
  final String? department;
  final String? assetType;

  const FilterAssets({
    this.searchQuery,
    this.department,
    this.assetType,
  });

  @override
  List<Object?> get props => [searchQuery, department, assetType];
}

class GetAssetById extends ManagementAssetEvent {
  final String id;

  const GetAssetById(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangePage extends ManagementAssetEvent {
  final int page;

  const ChangePage(this.page);

  @override
  List<Object?> get props => [page];
} 