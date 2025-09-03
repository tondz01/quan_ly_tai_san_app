import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/asset/models/asset.dart';

abstract class AssetState extends Equatable {
  const AssetState();
  @override
  List<Object?> get props => [];
}

class AssetInitial extends AssetState {}

class AssetLoaded extends AssetState {
  final List<AssetDTO> assets;
  const AssetLoaded(this.assets);
  @override
  List<Object?> get props => [assets];
}

class AssetError extends AssetState {
  final String message;
  const AssetError(this.message);
  @override
  List<Object?> get props => [message];
} 