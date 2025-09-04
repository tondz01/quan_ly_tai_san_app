import 'package:equatable/equatable.dart';

class AssetType extends Equatable {
  final String assetTypeId;
  final String assetTypeName;
  
  const AssetType({required this.assetTypeId, required this.assetTypeName});
  AssetType copyWith({String? assetTypeId, String? assetTypeName}) {
    return AssetType(
      assetTypeId: assetTypeId ?? this.assetTypeId,
      assetTypeName: assetTypeName ?? this.assetTypeName,
    );
  }

  @override
  List<Object?> get props => [assetTypeId, assetTypeName]; // Mã tài sản
}
