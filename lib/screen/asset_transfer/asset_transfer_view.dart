import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';

import 'bloc/asset_transfer_bloc.dart';
import 'bloc/asset_transfer_state.dart';

class AssetTransferView extends StatefulWidget {
  final int typeAssetTransfer;
  const AssetTransferView({super.key, required this.typeAssetTransfer});

  @override
  State<AssetTransferView> createState() => _AssetTransferViewState();
}

class _AssetTransferViewState extends State<AssetTransferView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    Provider.of<AssetTransferProvider>(
      context,
      listen: false,
    ).onInit(context, widget.typeAssetTransfer);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetTransferBloc, AssetTransferState>(
      listener: (context, state) {
        if (state is AssetTransferInitialState) {}
        if (state is AssetTransferLoadingState) {}
        if (state is AssetTransferLoadingDismissState) {}
        if (state is GetListAssetTransferSuccessState) {
          log('message GetListToolsAndSuppliesSuccessState');
          context.read<AssetTransferProvider>().getListAssetTransferSuccess(
            context,
            state,
          );
        }
        if (state is GetListAssetTransferFailedState) {}
      },
      builder: (context, state) {
        return Consumer<AssetTransferProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.data == null) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            provider.controllerDropdownPage ??= TextEditingController(
              text: provider.rowsPerPage.toString(),
            );

            return Scaffold(
              appBar: AppBar(
                title: HeaderComponent(
                  controller: _searchController,
                  onSearchChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
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
        );
      },
    );
  }
}
