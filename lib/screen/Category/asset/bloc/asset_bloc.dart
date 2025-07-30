import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/models/asset.dart';
import 'asset_event.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  List<AssetDTO> _allAssets = [];
  AssetBloc() : super(AssetInitial()) {
    on<LoadAssets>((event, emit) {
      _allAssets = List.from(event.assets);
      emit(AssetLoaded(_allAssets));
    });
    on<SearchAsset>((event, emit) {
      final keyword = event.keyword.toLowerCase();
      final filtered = _allAssets.where((a) =>
        a.assetId.toLowerCase().contains(keyword)
      ).toList();
      emit(AssetLoaded(filtered));
    });
    on<AddAsset>((event, emit) {
      if (state is AssetLoaded) {
        final assets = List<AssetDTO>.from((state as AssetLoaded).assets);
        assets.add(event.asset);
        emit(AssetLoaded(assets));
      } else {
        emit(AssetLoaded([event.asset]));
      }
    });
    on<UpdateAsset>((event, emit) {
      if (state is AssetLoaded) {
        final assets = List<AssetDTO>.from((state as AssetLoaded).assets);
        final index = assets.indexWhere((element) => element.assetId == event.asset.assetId);
        if (index != -1) {
          assets[index] = event.asset;
        }
        emit(AssetLoaded(assets));
      }
    });
    on<DeleteAsset>((event, emit) {
      if (state is AssetLoaded) {
        final assets = List<AssetDTO>.from((state as AssetLoaded).assets);
        assets.removeWhere((element) => element.assetId == event.asset.assetId);
        emit(AssetLoaded(assets));
      }
    });
  }
} 