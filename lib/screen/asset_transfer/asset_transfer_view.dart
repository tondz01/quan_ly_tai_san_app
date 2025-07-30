import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';

class AssetTransferView extends StatefulWidget {
  final int typeAssetTransfer;

  const AssetTransferView({
    super.key,
    required this.typeAssetTransfer,
  });

  @override
  State<AssetTransferView> createState() => _AssetTransferViewState();
}

class _AssetTransferViewState extends State<AssetTransferView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  late int currentType;

  @override
  void initState() {
    super.initState();
    currentType = widget.typeAssetTransfer;
    _initData();
  }

  @override
  void didUpdateWidget(AssetTransferView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recargar si cambia el tipo de transferencia de activos
    if (oldWidget.typeAssetTransfer != widget.typeAssetTransfer) {
      currentType = widget.typeAssetTransfer;
      _initData();
    }
  }

  void _initData() {
    log('initData $currentType');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetTransferProvider>(
        context,
        listen: false,
      ).onInit(context, currentType);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getScreenTitle() {
    switch (currentType) {
      case 1:
        return 'Cấp phát tài sản';
      case 2:
        return 'Thu hồi tài sản';
      case 3:
        return 'Điều chuyển tài sản';
      default:
        return 'Quản lý tài sản';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetTransferBloc, AssetTransferState>(
      listener: (context, state) {
        if (state is AssetTransferLoadingState) {
          // Mostrar loading
        } else if (state is GetListAssetTransferSuccessState) {
          log('GetListAssetTransferSuccessState');
          context
              .read<AssetTransferProvider>()
              .getListAssetTransferSuccess(context, state);
        } else if (state is GetListAssetTransferFailedState) {
          // Manejar error
        }
      },
      builder: (context, state) {
        // Usar el ChangeNotifierProvider.value en lugar de Consumer
        // Esto asegura que todos los cambios en el provider actualizan la UI
        return ChangeNotifierProvider.value(
          value: context.read<AssetTransferProvider>(),
          child: Consumer<AssetTransferProvider>(
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
                      provider.searchTerm = value;
                    },
                    onTap: provider.onTapBackHeader,
                    onNew: provider.onTapNewHeader,
                    mainScreen: _getScreenTitle(),
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
