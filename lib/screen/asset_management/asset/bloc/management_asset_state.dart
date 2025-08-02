import 'package:equatable/equatable.dart';
import '../models/asset_model.dart';
import '../repository/asset_repository.dart';

abstract class ManagementAssetState extends Equatable {
  const ManagementAssetState();
  
  @override
  List<Object?> get props => [];
}

class AssetInitial extends ManagementAssetState {}

class AssetLoading extends ManagementAssetState {}

class AssetLoaded extends ManagementAssetState {
  final List<AssetModel> assets;
  
  const AssetLoaded(this.assets);
  
  @override
  List<Object?> get props => [assets];
}

class AssetPaginatedLoaded extends ManagementAssetState {
  final List<AssetModel> assets;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final String? searchQuery;
  final String? department;
  final String? assetType;
  
  const AssetPaginatedLoaded({
    required this.assets,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    this.searchQuery,
    this.department,
    this.assetType,
  });

  factory AssetPaginatedLoaded.fromPaginationResult(
    PaginationResult<AssetModel> result,
    {String? searchQuery, String? department, String? assetType}
  ) {
    return AssetPaginatedLoaded(
      assets: result.items,
      currentPage: result.currentPage,
      pageSize: result.pageSize,
      totalItems: result.totalItems,
      totalPages: result.totalPages,
      searchQuery: searchQuery,
      department: department,
      assetType: assetType,
    );
  }
  
  @override
  List<Object?> get props => [
    assets, 
    currentPage, 
    pageSize, 
    totalItems, 
    totalPages, 
    searchQuery, 
    department, 
    assetType
  ];
  
  AssetPaginatedLoaded copyWith({
    List<AssetModel>? assets,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    String? searchQuery,
    String? department,
    String? assetType,
  }) {
    return AssetPaginatedLoaded(
      assets: assets ?? this.assets,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      department: department ?? this.department,
      assetType: assetType ?? this.assetType,
    );
  }
}

class AssetError extends ManagementAssetState {
  final String message;
  
  const AssetError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class AssetDetailLoaded extends ManagementAssetState {
  final AssetModel asset;
  
  const AssetDetailLoaded(this.asset);
  
  @override
  List<Object?> get props => [asset];
} 