import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';

import 'bloc/asset_handover_bloc.dart';
import 'bloc/asset_handover_state.dart';
import 'provider/asset_handover_provider.dart';

class AssetHandoverView extends StatefulWidget {

  const AssetHandoverView({super.key});

  @override
  State<AssetHandoverView> createState() => _AssetHandoverViewState();
}

class _AssetHandoverViewState extends State<AssetHandoverView> {
  AssetHandoverDto? assetHandoverData;
  Map<String, dynamic>? menuSelectionData;
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy data từ router sau khi dependencies đã được thiết lập
    final extra = GoRouterState.of(context).extra;
    log('Extra data from router: $extra');
    
    if (extra is Map<String, dynamic>) {
      assetHandoverData = extra['AssetHandoverDto'] as AssetHandoverDto?;
      menuSelectionData = extra['menuSelection'] as Map<String, dynamic>?;
      
      if (assetHandoverData != null) {
        _handleAssetHandoverData(assetHandoverData!);
      }
      
      if (menuSelectionData != null) {
        _updateMenuSelection();
      }
    } else if (extra is AssetHandoverDto) {
      assetHandoverData = extra;
      if (assetHandoverData != null) {
        _handleAssetHandoverData(assetHandoverData!);
      }
    }
  }

  void _updateMenuSelection() {
    if (menuSelectionData != null) {
      final selectedIndex = menuSelectionData!['selectedIndex'] as int?;
      final selectedSubIndex = menuSelectionData!['selectedSubIndex'] as int?;
      
      if (selectedIndex != null && selectedSubIndex != null) {
        log('Updating menu selection: index=$selectedIndex, subIndex=$selectedSubIndex');
        // Có thể thêm logic để cập nhật menu selection ở đây nếu cần
      }
    }
  }

  void _handleAssetHandoverData(AssetHandoverDto assetHandoverDto) {
    log('Received AssetHandoverDto: ${assetHandoverDto.name}');
    
    final provider = Provider.of<AssetHandoverProvider>(context, listen: false);
    
    // Khởi tạo provider và chuyển đến detail screen
    provider.onInit(context);
    provider.onChangeScreen(
      item: assetHandoverDto,
      isMainScreen: false,
      isEdit: false,
    );
  }

  @override
  void didUpdateWidget(AssetHandoverView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initData();
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssetHandoverProvider>(
        context,
        listen: false,
      );

      // Chỉ khởi tạo nếu không có data từ router
      if (assetHandoverData == null) {
        provider.onInit(context);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // String _getScreenTitle() {
  //   switch (currentType) {
  //     case 1:
  //       return 'Cấp phát tài sản';
  //     case 2:
  //       return 'Thu hồi tài sản';
  //     case 3:
  //       return 'Điều chuyển tài sản';
  //     default:
  //       return 'Quản lý tài sản';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetHandoverBloc, AssetHandoverState>(
      listener: (context, state) {
        if (state is AssetHandoverLoadingState) {
          // Mostrar loading
        } else if (state is GetListAssetHandoverSuccessState) {
          log('GetListAssetHandoverSuccessState ${state.data.length}');
          context.read<AssetHandoverProvider>().getListAssetHandoverSuccess(
            context,
            state,
          );
        } else if (state is GetListAssetHandoverFailedState) {
          // Manejar error
          log('GetListAssetHandoverFailedState');
        }
      },
      builder: (context, state) {
        // Usar el ChangeNotifierProvider.value en lugar de Consumer
        // Esto asegura que todos los cambios en el provider actualizan la UI
        return ChangeNotifierProvider.value(
          value: context.read<AssetHandoverProvider>(),
          child: Consumer<AssetHandoverProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.data == null) {
                return const Center(child: Text('Không có dữ liệu'));
              }

              return Scaffold(
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      // Cập nhật trạng thái tìm kiếm trong provider
                      provider.searchTerm = value;
                    },
                    onTap: provider.onTapBackHeader,
                    onNew: provider.onTapNewHeader,
                    mainScreen: provider.mainScreen,
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: provider.body,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
