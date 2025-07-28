import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/models/asset.dart';

abstract class AssetEvent extends Equatable {
  const AssetEvent();
  @override
  List<Object?> get props => [];
}

class LoadAssets extends AssetEvent {
  final List<AssetDTO> assets;
  const LoadAssets(this.assets);
  @override
  List<Object?> get props => [assets];
}

class AddAsset extends AssetEvent {
  final AssetDTO asset;
  const AddAsset(this.asset);
  @override
  List<Object?> get props => [asset];
}

class UpdateAsset extends AssetEvent {
  final AssetDTO asset;
  const UpdateAsset(this.asset);
  @override
  List<Object?> get props => [asset];
}

class DeleteAsset extends AssetEvent {
  final AssetDTO asset;
  const DeleteAsset(this.asset);
  @override
  List<Object?> get props => [asset];
}

class SearchAsset extends AssetEvent {
  final String keyword;
  const SearchAsset(this.keyword);
  @override
  List<Object?> get props => [keyword];
} 