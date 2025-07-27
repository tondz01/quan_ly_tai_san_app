import 'package:equatable/equatable.dart';

abstract class AssetEvent extends Equatable {
  const AssetEvent();

  @override
  List<Object?> get props => [];
}

class LoadAssets extends AssetEvent {
  const LoadAssets();
}

class LoadAssetsWithPagination extends AssetEvent {
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

class FilterAssets extends AssetEvent {
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

class GetAssetById extends AssetEvent {
  final String id;

  const GetAssetById(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangePage extends AssetEvent {
  final int page;

  const ChangePage(this.page);

  @override
  List<Object?> get props => [page];
} 